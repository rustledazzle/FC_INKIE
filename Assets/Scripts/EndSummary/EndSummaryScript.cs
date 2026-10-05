using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;

public class EndSummaryManager : MonoBehaviour
{
    [Header("Scene Transitions")]
    [Tooltip("Drag a full-screen black UI Panel with a CanvasGroup here.")]
    public CanvasGroup fadePanel;
    public float fadeDuration = 1.0f;

    [Header("Debug / God Mode")]
    [Tooltip("Check this to prevent any data from saving to Firebase during UI testing.")]
    public bool isDebugMode = false;

    [Header("God Mode UI Swapping")]
    [Tooltip("Drag the normal buttons here. They will HIDE when God Mode is activated.")]
    public GameObject[] normalUIElements;
    [Tooltip("Drag your custom Debug buttons here. They will SHOW when God Mode is activated.")]
    public GameObject[] debugUIElements;

    [Header("Category UI Texts")]
    public TextMeshProUGUI clinicalText;
    public TextMeshProUGUI infoText;
    public TextMeshProUGUI empathyText;
    public TextMeshProUGUI safetyText;

    [Header("Big Total UI Text")]
    public TextMeshProUGUI grandTotalText;

    [Header("Maximum Score Settings")]
    public int maxClinical = 55;
    public int maxInfo = 55;
    public int maxEmpathy = 55;
    public int maxSafety = 55;

    [Header("Feedback UI")]
    public TextMeshProUGUI gradeText;
    public TextMeshProUGUI commentText;

    [Header("Navigation Buttons")]
    public Button returnToStagesButton;
    public Button mainMenuButton;

    void Start()
    {
        // Start the scene by fading in from black
        if (fadePanel != null) StartCoroutine(FadeIn());

        CalculateAndDisplaySummary();
        SetupNavigationButtons();
    }

    void SetupNavigationButtons()
    {
        if (returnToStagesButton != null)
            returnToStagesButton.onClick.AddListener(() => LoadScene("StagesScene"));

        if (mainMenuButton != null)
            mainMenuButton.onClick.AddListener(() => LoadScene("MenuScene"));
    }

    private void LoadScene(string sceneName)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        // Use the fade out routine instead of loading instantly
        if (fadePanel != null)
        {
            StartCoroutine(FadeOutAndLoadScene(sceneName));
        }
        else
        {
            SceneManager.LoadScene(sceneName);
        }
    }

    // ==========================================
    // FADE COROUTINES
    // ==========================================
    private IEnumerator FadeIn()
    {
        fadePanel.gameObject.SetActive(true);
        fadePanel.alpha = 1f;

        float timer = 0f;
        while (timer < fadeDuration)
        {
            timer += Time.deltaTime;
            fadePanel.alpha = Mathf.Lerp(1f, 0f, timer / fadeDuration);
            yield return null;
        }

        fadePanel.alpha = 0f;
        fadePanel.blocksRaycasts = false; // Allow the player to click buttons again
    }

    private IEnumerator FadeOutAndLoadScene(string sceneName)
    {
        fadePanel.gameObject.SetActive(true);
        fadePanel.blocksRaycasts = true; // Stop the player from clicking while fading
        fadePanel.alpha = 0f;

        float timer = 0f;
        while (timer < fadeDuration)
        {
            timer += Time.deltaTime;
            fadePanel.alpha = Mathf.Lerp(0f, 1f, timer / fadeDuration);
            yield return null;
        }

        fadePanel.alpha = 1f;
        SceneManager.LoadScene(sceneName);
    }

    // ==========================================
    // SCORE & FIREBASE LOGIC
    // ==========================================
    private string GetActiveUserDocumentId()
    {
        string activeDocId = PlayerPrefs.GetString("ActiveDocumentId", "");
        if (!string.IsNullOrEmpty(activeDocId)) return activeDocId;

        FirebaseUser currentUser = FirebaseAuth.DefaultInstance != null ? FirebaseAuth.DefaultInstance.CurrentUser : null;
        return currentUser != null ? currentUser.UserId : "";
    }

    void CalculateAndDisplaySummary()
    {
        int totalClinical = PlayerPrefs.GetInt("Stage1_Morning_Clinical", 0) +
                            PlayerPrefs.GetInt("Stage1_Afternoon_Clinical", 0) +
                            PlayerPrefs.GetInt("SpecialCases_Clinical", 0) +
                            PlayerPrefs.GetInt("Stage4_Clinical", 0);

        int totalInfo = PlayerPrefs.GetInt("Stage1_Morning_Info", 0) +
                        PlayerPrefs.GetInt("Stage1_Afternoon_Info", 0) +
                        PlayerPrefs.GetInt("SpecialCases_Info", 0) +
                        PlayerPrefs.GetInt("Stage4_Info", 0);

        int totalEmpathy = PlayerPrefs.GetInt("Stage1_Morning_Empathy", 0) +
                           PlayerPrefs.GetInt("Stage1_Afternoon_Empathy", 0) +
                           PlayerPrefs.GetInt("SpecialCases_Empathy", 0) +
                           PlayerPrefs.GetInt("Stage4_Empathy", 0);

        int totalSafety = PlayerPrefs.GetInt("Stage1_Morning_Safety", 0) +
                          PlayerPrefs.GetInt("Stage1_Afternoon_Safety", 0) +
                          PlayerPrefs.GetInt("SpecialCases_Safety", 0) +
                          PlayerPrefs.GetInt("Stage4_Safety", 0);

        if (clinicalText) clinicalText.text = $"clinical score total {totalClinical}/{maxClinical}";
        if (infoText) infoText.text = $"info score {totalInfo}/{maxInfo}";
        if (empathyText) empathyText.text = $"empathy score {totalEmpathy}/{maxEmpathy}";
        if (safetyText) safetyText.text = $"safety score {totalSafety}/{maxSafety}";

        int finalScore = totalClinical + totalInfo + totalEmpathy + totalSafety;
        int maxTotalScore = maxClinical + maxInfo + maxEmpathy + maxSafety;

        float decimalPercentage = maxTotalScore > 0 ? (float)finalScore / maxTotalScore : 0f;
        float displayPercentage = decimalPercentage * 100f;

        // Save local percentage and mark the campaign as fully complete (Level 4 + Chief Resident Badge)
        PlayerPrefs.SetFloat("FinalCampaignPercentage", decimalPercentage);
        PlayerPrefs.SetInt("UnlockedStageLevel", 4);
        PlayerPrefs.SetInt("Badge_ChiefResident", 1);
        PlayerPrefs.Save();

        if (grandTotalText) grandTotalText.text = $"total {finalScore}/{maxTotalScore} ({displayPercentage:0.0}%)";

        string assignedGrade = GenerateFeedback(decimalPercentage);

        if (!isDebugMode)
        {
            SaveCampaignSummaryToCloud(totalClinical, totalInfo, totalEmpathy, totalSafety, finalScore, displayPercentage, assignedGrade);
        }
        else
        {
            Debug.LogWarning("GOD MODE ACTIVE: Cloud save bypassed to protect your database.");
        }
    }

    void SaveCampaignSummaryToCloud(int clinical, int info, int empathy, int safety, int grandTotal, float percentage, string grade)
    {
        string docId = GetActiveUserDocumentId();
        if (string.IsNullOrEmpty(docId)) return;

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;

        Dictionary<string, object> campaignSummary = new Dictionary<string, object>
        {
            { "TotalClinical", clinical },
            { "TotalInfo", info },
            { "TotalEmpathy", empathy },
            { "TotalSafety", safety },
            { "GrandTotalScore", grandTotal },
            { "Percentage", percentage },
            { "FinalGrade", grade },
            { "CompletedAt", FieldValue.ServerTimestamp }
        };

        // Also push the completed progression flags up to the cloud document
        Dictionary<string, object> summaryUpdate = new Dictionary<string, object>
        {
            { "CampaignSummary", campaignSummary },
            { "HighestUnlockedLevel", 4 },
            { "LastActive", FieldValue.ServerTimestamp }
        };

        db.Collection("Users").Document(docId)
          .SetAsync(summaryUpdate, SetOptions.MergeAll)
          .ContinueWithOnMainThread(task =>
          {
              if (task.IsFaulted) Debug.LogError("Failed to save Campaign Summary: " + task.Exception);
              else if (task.IsCompleted) Debug.Log($"Campaign Summary successfully backed up to cloud for {docId}!");
          });
    }

    string GenerateFeedback(float percentage)
    {
        if (percentage >= 0.90f)
        {
            if (gradeText) { gradeText.text = "Grade: OUTSTANDING"; gradeText.color = Color.green; }
            if (commentText) commentText.text = "Excellent work, Doctor! Your diagnostic skills and adherence to safety protocols are top-tier.";
            return "OUTSTANDING";
        }
        else if (percentage >= 0.75f)
        {
            if (gradeText) { gradeText.text = "Grade: PROFICIENT"; gradeText.color = Color.blue; }
            if (commentText) commentText.text = "Great job! You have a solid grasp of family medicine.";
            return "PROFICIENT";
        }
        else if (percentage >= 0.60f)
        {
            if (gradeText) { gradeText.text = "Grade: COMPETENT"; gradeText.color = new Color(1f, 0.5f, 0f); }
            if (commentText) commentText.text = "You passed, but there is room for improvement. Ensure you gather all necessary patient history.";
            return "COMPETENT";
        }
        else
        {
            if (gradeText) { gradeText.text = "Grade: NEEDS IMPROVEMENT"; gradeText.color = Color.red; }
            if (commentText) commentText.text = "Please review your textbook materials and retry the simulation to improve patient outcomes.";
            return "NEEDS IMPROVEMENT";
        }
    }

    // ==========================================
    // GOD MODE DEBUG BUTTONS & UI SWAPPING
    // ==========================================
    public void TestFailedGrade()
    {
        ActivateGodMode();
        InjectFakeScores(2); // Injects low scores
        CalculateAndDisplaySummary();
    }

    public void TestPassedGrade()
    {
        ActivateGodMode();
        InjectFakeScores(14); // Injects high scores
        CalculateAndDisplaySummary();
    }

    private void ActivateGodMode()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        isDebugMode = true;

        // Hide normal player buttons
        foreach (GameObject ui in normalUIElements)
        {
            if (ui != null) ui.SetActive(false);
        }

        // Show explicit debug buttons
        foreach (GameObject ui in debugUIElements)
        {
            if (ui != null) ui.SetActive(true);
        }
    }

    private void InjectFakeScores(int scorePerMetric)
    {
        string[] stages = { "Stage1_Morning", "Stage1_Afternoon", "SpecialCases", "Stage4" };
        string[] metrics = { "_Clinical", "_Info", "_Empathy", "_Safety" };

        foreach (string stage in stages)
        {
            foreach (string metric in metrics)
            {
                PlayerPrefs.SetInt(stage + metric, scorePerMetric);
            }
        }
        PlayerPrefs.Save();
        Debug.Log($"God Mode: Local PlayerPrefs overwritten with {scorePerMetric} per metric.");
    }
}