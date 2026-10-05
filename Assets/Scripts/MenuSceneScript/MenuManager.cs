using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;

public class MenuManager : MonoBehaviour
{
    [Header("Main Menu Buttons")]
    public Button newGameButton;
    public Button libraryButton;
    public Button stagesButton;
    public Button optionsButton;
    public Button exitButton;
    public Button badgeButton;

    [Header("Reminder Panel")]
    public GameObject reminderPanel;
    public Button proceedButton;
    public Button closeReminderButton;

    [Header("Data Management")]
    public Button resetDataButton;

    [Header("Reset Data Confirmation UI")]
    public GameObject resetConfirmationPanel; // Assign your reset confirmation panel here in the Inspector
    public TMP_InputField resetInput;         // Assign the input field where user types "Reset"
    public TMP_Text resetFeedbackText;        // Assign feedback text for reset errors
    public Color errorColor = Color.red;

    [Header("Cloud Data UI")]
    public TMP_Text welcomeText;
    public TMP_Text statsText;
    public Button signOutButton;

    // Keys to wipe when ResetDataButton is pressed
    private readonly string[] allBadgeKeys = new string[]
    {
        "Badge_Tutorial",
        "Badge_PerfectStage1",
        "Badge_PerfectEmpathy",
        "Badge_PerfectSafety",
        "Badge_OutstandingGrade",
        "Badge_NoCaseFile",
        "Badge_ChiefResident",
        "Badge_SpecialCases"

    };

    private readonly string[] allStagePrefixes = new string[]
    {
        "Stage1_Morning",
        "Stage1_Afternoon",
        "SpecialCases",
        "Stage4",
        "CampaignSummary", // Added to clear end campaign stats
        "Campaign_End"
    };

    void Start()
    {
        // 1. Lock or Unlock the Stages button based on Tutorial completion or stage progress
        bool hasProgressed = PlayerPrefs.GetInt("UnlockedStageLevel", 0) > 0 ||
                             PlayerPrefs.GetInt("Badge_Tutorial", 0) == 1 ||
                             (GameManager.Instance != null && GameManager.Instance.hasCompletedTutorial);

        if (stagesButton != null)
        {
            stagesButton.interactable = hasProgressed;
        }

        // Hide reminder and reset confirmation panels when the menu loads
        if (reminderPanel != null) reminderPanel.SetActive(false);
        if (resetConfirmationPanel != null) resetConfirmationPanel.SetActive(false);

        // 2. Main Menu Button Listeners
        if (newGameButton != null) newGameButton.onClick.AddListener(ShowReminder);
        if (libraryButton != null) libraryButton.onClick.AddListener(() => PlayClickAndLoad("LibraryScene"));
        if (stagesButton != null) stagesButton.onClick.AddListener(() => PlayClickAndLoad("StagesScene"));
        if (optionsButton != null) optionsButton.onClick.AddListener(() => PlayClickAndLoad("OptionsScene"));
        if (badgeButton != null) badgeButton.onClick.AddListener(() => PlayClickAndLoad("BadgesScene"));

        // Wire up the reset button to open the confirmation panel instead of direct wipe
        if (resetDataButton != null)
        {
            resetDataButton.onClick.AddListener(OpenResetConfirmationPanel);
        }

        // Wire up the sign out button
        if (signOutButton != null)
        {
            signOutButton.onClick.AddListener(SignOut);
        }

        if (exitButton != null)
        {
            exitButton.onClick.AddListener(() =>
            {
                if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
                Application.Quit();
            });
        }

        // 3. Reminder Panel Button Listeners
        if (proceedButton != null)
            proceedButton.onClick.AddListener(() => PlayClickAndLoad("TutorialScene"));

        if (closeReminderButton != null)
            closeReminderButton.onClick.AddListener(HideReminder);

        // 4. Fetch Cloud Data for Either Guest or Registered User
        FetchPlayerData();
    }

    // --- Existing Menu Functions ---
    private void ShowReminder()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        if (reminderPanel != null) reminderPanel.SetActive(true);
    }

    private void HideReminder()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        if (reminderPanel != null) reminderPanel.SetActive(false);
    }

    private void PlayClickAndLoad(string sceneName)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        SceneManager.LoadScene(sceneName);
    }

    // Helper to get the active Firestore Document ID (works for both Guest and Registered users)
    private string GetActiveDocumentId()
    {
        string activeDocId = PlayerPrefs.GetString("ActiveDocumentId", "");
        if (!string.IsNullOrEmpty(activeDocId))
        {
            return activeDocId;
        }

        FirebaseUser currentUser = FirebaseAuth.DefaultInstance != null ? FirebaseAuth.DefaultInstance.CurrentUser : null;
        return currentUser != null ? currentUser.UserId : "";
    }

    // =========================================================================
    // RESET DATA CONFIRMATION WORKFLOW
    // =========================================================================
    public void OpenResetConfirmationPanel()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (resetConfirmationPanel != null)
        {
            if (resetInput != null) resetInput.text = "";
            if (resetFeedbackText != null) resetFeedbackText.text = "";
            resetConfirmationPanel.SetActive(true);
        }
    }

    public void CloseResetConfirmationPanel()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (resetConfirmationPanel != null)
        {
            resetConfirmationPanel.SetActive(false);
        }
    }

    public void ConfirmAndExecuteResetData()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        string userInput = resetInput != null ? resetInput.text.Trim() : "";

        // Verify that the user typed exactly "Reset"
        if (!string.Equals(userInput, "Reset", System.StringComparison.CurrentCultureIgnoreCase))
        {
            if (resetFeedbackText != null)
            {
                resetFeedbackText.text = "Please type exactly 'Reset' to confirm.";
                resetFeedbackText.color = errorColor;
            }
            return;
        }

        Debug.Log("Reset confirmed by user. Executing full data wipe...");

        // Get document ID before wiping PlayerPrefs
        string docId = GetActiveDocumentId();

        // Preserve Audio Settings and Active Login Session
        PlayerPrefs.SetInt("UnlockedStageLevel", 0);

        foreach (string badgeKey in allBadgeKeys)
        {
            PlayerPrefs.SetInt(badgeKey, 0);
        }

        foreach (string prefix in allStagePrefixes)
        {
            PlayerPrefs.DeleteKey(prefix + "_Clinical");
            PlayerPrefs.DeleteKey(prefix + "_Info");
            PlayerPrefs.DeleteKey(prefix + "_Empathy");
            PlayerPrefs.DeleteKey(prefix + "_Safety");
        }

        PlayerPrefs.Save();

        if (stagesButton != null) stagesButton.interactable = false;
        if (GameManager.Instance != null)
        {
            GameManager.Instance.hasCompletedTutorial = false;
        }

        // Also reset progress in Firebase Firestore for the current user/guest
        if (!string.IsNullOrEmpty(docId))
        {
            FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
            Dictionary<string, object> resetCloudData = new Dictionary<string, object>
            {
                { "TutorialCompleted", false },
                { "HighestUnlockedLevel", 0 },
                { "Badges", new Dictionary<string, object>() }
            };

            foreach (string prefix in allStagePrefixes)
            {
                resetCloudData[prefix] = FieldValue.Delete;
            }

            db.Collection("Users").Document(docId).SetAsync(resetCloudData, SetOptions.MergeAll);
        }

        if (statsText != null) statsText.text = "Current Progress:\nTutorial Pending";

        // Hide panel and reload or refresh state
        if (resetConfirmationPanel != null) resetConfirmationPanel.SetActive(false);

        Debug.Log("All gameplay progress has been wiped clean!");
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    // --- Cloud Data Functions (Supports Both Guest & Registered Users) ---
    public void FetchPlayerData()
    {
        string docId = GetActiveDocumentId();
        FirebaseUser currentUser = FirebaseAuth.DefaultInstance != null ? FirebaseAuth.DefaultInstance.CurrentUser : null;

        // If neither a Guest session nor a Firebase Auth user exists, return to LoginScene
        if (string.IsNullOrEmpty(docId) && currentUser == null)
        {
            Debug.LogWarning("No user or guest logged in, returning to login screen.");
            SceneManager.LoadScene("LoginScene");
            return;
        }

        // Display welcome text immediately using saved PlayerName or Email
        string savedName = PlayerPrefs.GetString("PlayerName", "");
        bool isGuestDoc = docId.StartsWith("Guest_");

        if (welcomeText != null)
        {
            if (isGuestDoc && !string.IsNullOrEmpty(savedName))
            {
                welcomeText.text = $"Logged in as: {savedName} (Guest)";
            }
            else if (currentUser != null && !string.IsNullOrEmpty(currentUser.Email))
            {
                welcomeText.text = !string.IsNullOrEmpty(savedName)
                    ? $"Logged in as: {savedName} ({currentUser.Email})"
                    : $"Logged in as: {currentUser.Email}";
            }
            else if (!string.IsNullOrEmpty(savedName))
            {
                welcomeText.text = $"Logged in as: {savedName}";
            }
        }

        if (statsText != null) statsText.text = "Syncing cloud data...";

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        DocumentReference docRef = db.Collection("Users").Document(docId);

        docRef.GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsFaulted)
            {
                Debug.LogError("Error fetching data: " + task.Exception);
                if (statsText != null) statsText.text = "Failed to load cloud data.";
                return;
            }

            DocumentSnapshot snapshot = task.Result;

            if (snapshot.Exists)
            {
                // Update Welcome Text if Username exists in cloud
                if (snapshot.ContainsField("Username") && welcomeText != null)
                {
                    string cloudName = snapshot.GetValue<string>("Username");
                    PlayerPrefs.SetString("PlayerName", cloudName);
                    welcomeText.text = isGuestDoc
                        ? $"Logged in as: {cloudName} (Guest)"
                        : $"Logged in as: {cloudName}";
                }

                // 1. Check Tutorial & Stage level in Firebase
                int unlockedLevel = snapshot.ContainsField("HighestUnlockedLevel")
                    ? snapshot.GetValue<int>("HighestUnlockedLevel")
                    : 0;

                bool tutorialDone = unlockedLevel > 0 ||
                                    PlayerPrefs.GetInt("Badge_Tutorial", 0) == 1 ||
                                    (snapshot.ContainsField("TutorialCompleted") && snapshot.GetValue<bool>("TutorialCompleted"));

                if (snapshot.ContainsField("Badges"))
                {
                    var badgesMap = snapshot.GetValue<Dictionary<string, object>>("Badges");
                    if (badgesMap.ContainsKey("Badge_Tutorial") && badgesMap["Badge_Tutorial"] is bool b && b)
                    {
                        tutorialDone = true;
                    }
                }

                // 2. Translate that level into a clean UI status matching StagesMenuManager
                string progressText = "Tutorial Pending";
                if (tutorialDone && unlockedLevel == 0) progressText = "Stage 1 Unlocked";
                else if (unlockedLevel == 1) progressText = "Stage 2 Unlocked";
                else if (unlockedLevel == 2) progressText = "Stage 3 Unlocked";
                else if (unlockedLevel == 3) progressText = "Stage 4 Unlocked";
                else if (unlockedLevel >= 4) progressText = "Chief Resident (All Stages Completed)";

                // 3. Display it on the UI
                if (statsText != null)
                {
                    statsText.text = $"Current Progress:\n{progressText}";
                }

                // 4. Sync local state
                PlayerPrefs.SetInt("UnlockedStageLevel", unlockedLevel);
                if (tutorialDone) PlayerPrefs.SetInt("Badge_Tutorial", 1);
                PlayerPrefs.Save();

                // 5. Lock or unlock the stages button accurately
                if (GameManager.Instance != null) GameManager.Instance.hasCompletedTutorial = tutorialDone;
                if (stagesButton != null) stagesButton.interactable = tutorialDone;
            }
            else
            {
                if (statsText != null) statsText.text = "Welcome to your first shift!";
                if (stagesButton != null) stagesButton.interactable = false;
            }
        });
    }

    public void SignOut()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        // Clear active session keys so the next login starts fresh
        PlayerPrefs.DeleteKey("ActiveDocumentId");
        PlayerPrefs.DeleteKey("PlayerName");
        PlayerPrefs.Save();

        if (FirebaseAuth.DefaultInstance != null)
        {
            FirebaseAuth.DefaultInstance.SignOut();
        }

        SceneManager.LoadScene("LoginScene");
    }
}