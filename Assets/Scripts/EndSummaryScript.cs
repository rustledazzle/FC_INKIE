using UnityEngine;
using UnityEngine.UI; // Required for Button functionality
using UnityEngine.SceneManagement; // Required for loading scenes
using TMPro;

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
    public Button cinematicButton; // Placeholder for the upcoming ending cinematic

    void Start()
    {
        CalculateAndDisplaySummary();
        SetupNavigationButtons();
    }

    void SetupNavigationButtons()
    {
        if (returnToStagesButton != null)
        {
            returnToStagesButton.onClick.AddListener(() => LoadScene("StagesScene"));
        }

        if (mainMenuButton != null)
        {
            mainMenuButton.onClick.AddListener(() => LoadScene("MenuScene"));
        }

        if (cinematicButton != null)
        {
            // Currently acts as a placeholder until your cinematic scene is ready
            cinematicButton.onClick.AddListener(() => Debug.Log("End Cinematic Button Clicked! Replace this with LoadScene later."));
        }
    }

    private void LoadScene(string sceneName)
    {
        // Optional: Add audio manager click sound here if you have one
        // if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        SceneManager.LoadScene(sceneName);
    }

    void CalculateAndDisplaySummary()
    {
        // 1. Fetch the HIGHEST scores across all 4 stages using the exact prefixes
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

        // 2. Format and display the individual category strings
        if (clinicalText) clinicalText.text = $"clinical score total {totalClinical}/{maxClinical}";
        if (infoText) infoText.text = $"info score {totalInfo}/{maxInfo}";
        if (empathyText) empathyText.text = $"empathy score {totalEmpathy}/{maxEmpathy}";
        if (safetyText) safetyText.text = $"safety score {totalSafety}/{maxSafety}";

        // 3. Calculate Grand Total and Percentage
        int finalScore = totalClinical + totalInfo + totalEmpathy + totalSafety;
        int maxTotalScore = maxClinical + maxInfo + maxEmpathy + maxSafety;

        float decimalPercentage = (float)finalScore / maxTotalScore;
        float displayPercentage = decimalPercentage * 100f;

        // 4. Update the Big Text to show Total AND Percentage
        if (grandTotalText) grandTotalText.text = $"total {finalScore}/{maxTotalScore} ({displayPercentage:0.0}%)";

        // 5. Generate final feedback
        GenerateFeedback(decimalPercentage);
    }

    void GenerateFeedback(float percentage)
    {
        if (percentage >= 0.90f)
        {
            gradeText.text = "Grade: OUTSTANDING";
            gradeText.color = Color.green;
            commentText.text = "Excellent work, Doctor! Your diagnostic skills and adherence to safety protocols are top-tier.";
        }
        else if (percentage >= 0.75f)
        {
            gradeText.text = "Grade: PROFICIENT";
            gradeText.color = Color.blue;
            commentText.text = "Great job! You have a solid grasp of family medicine.";
        }
        else if (percentage >= 0.60f)
        {
            gradeText.text = "Grade: COMPETENT";
            gradeText.color = new Color(1f, 0.5f, 0f);
            commentText.text = "You passed, but there is room for improvement. Ensure you gather all necessary patient history.";
        }
        else
        {
            gradeText.text = "Grade: NEEDS IMPROVEMENT";
            gradeText.color = Color.red;
            commentText.text = "Please review your textbook materials and retry the simulation to improve patient outcomes.";
        }
    }
}