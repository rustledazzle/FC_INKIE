using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;
using System.Collections.Generic;

public class EndSummaryManager : MonoBehaviour
{
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
    public Button cinematicButton;

    void Start()
    {
        CalculateAndDisplaySummary();
        SetupNavigationButtons();
    }

    void SetupNavigationButtons()
    {
        if (returnToStagesButton != null)
            returnToStagesButton.onClick.AddListener(() => LoadScene("StagesScene"));

        if (mainMenuButton != null)
            mainMenuButton.onClick.AddListener(() => LoadScene("MenuScene"));

        if (cinematicButton != null)
            cinematicButton.onClick.AddListener(() => Debug.Log("End Cinematic Button Clicked!"));
    }

    private void LoadScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
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

        float decimalPercentage = (float)finalScore / maxTotalScore;
        float displayPercentage = decimalPercentage * 100f;

        if (grandTotalText) grandTotalText.text = $"total {finalScore}/{maxTotalScore} ({displayPercentage:0.0}%)";

        string assignedGrade = GenerateFeedback(decimalPercentage);

        // Push overall campaign summary to Firebase
        SaveCampaignSummaryToCloud(totalClinical, totalInfo, totalEmpathy, totalSafety, finalScore, displayPercentage, assignedGrade);
    }

    void SaveCampaignSummaryToCloud(int clinical, int info, int empathy, int safety, int grandTotal, float percentage, string grade)
    {
        FirebaseUser currentUser = FirebaseAuth.DefaultInstance.CurrentUser;
        if (currentUser == null) return;

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

        Dictionary<string, object> summaryUpdate = new Dictionary<string, object>
        {
            { "CampaignSummary", campaignSummary }
        };

        // MergeAll keeps all your individual Stage data intact!
        db.Collection("Users").Document(currentUser.UserId)
          .SetAsync(summaryUpdate, SetOptions.MergeAll)
          .ContinueWithOnMainThread(task =>
          {
              if (task.IsFaulted) Debug.LogError("Failed to save Campaign Summary: " + task.Exception);
              else if (task.IsCompleted) Debug.Log("Campaign Summary successfully backed up to cloud!");
          });
    }

    string GenerateFeedback(float percentage)
    {
        if (percentage >= 0.90f)
        {
            gradeText.text = "Grade: OUTSTANDING";
            gradeText.color = Color.green;
            commentText.text = "Excellent work, Doctor! Your diagnostic skills and adherence to safety protocols are top-tier.";
            return "OUTSTANDING";
        }
        else if (percentage >= 0.75f)
        {
            gradeText.text = "Grade: PROFICIENT";
            gradeText.color = Color.blue;
            commentText.text = "Great job! You have a solid grasp of family medicine.";
            return "PROFICIENT";
        }
        else if (percentage >= 0.60f)
        {
            gradeText.text = "Grade: COMPETENT";
            gradeText.color = new Color(1f, 0.5f, 0f);
            commentText.text = "You passed, but there is room for improvement. Ensure you gather all necessary patient history.";
            return "COMPETENT";
        }
        else
        {
            gradeText.text = "Grade: NEEDS IMPROVEMENT";
            gradeText.color = Color.red;
            commentText.text = "Please review your textbook materials and retry the simulation to improve patient outcomes.";
            return "NEEDS IMPROVEMENT";
        }
    }
}