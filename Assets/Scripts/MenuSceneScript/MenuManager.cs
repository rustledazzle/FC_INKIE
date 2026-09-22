using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro; // Required for text elements
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

    [Header("Cloud Data UI")]
    public TMP_Text welcomeText;
    public TMP_Text statsText;
    public Button signOutButton;

    void Start()
    {
        // 1. Lock or Unlock the Stages button based on GameManager progress
        if (GameManager.Instance != null)
        {
            stagesButton.interactable = GameManager.Instance.hasCompletedTutorial;
        }
        else
        {
            stagesButton.interactable = false;
        }

        // Hide the reminder panel when the menu loads
        if (reminderPanel != null) reminderPanel.SetActive(false);

        // 2. Main Menu Button Listeners
        newGameButton.onClick.AddListener(ShowReminder);
        libraryButton.onClick.AddListener(() => PlayClickAndLoad("LibraryScene"));
        stagesButton.onClick.AddListener(() => PlayClickAndLoad("StagesScene"));
        optionsButton.onClick.AddListener(() => PlayClickAndLoad("OptionsScene"));
        badgeButton.onClick.AddListener(() => PlayClickAndLoad("BadgesScene"));

        // Wire up the reset button
        if (resetDataButton != null)
        {
            resetDataButton.onClick.AddListener(ResetGameData);
        }

        // Wire up the sign out button
        if (signOutButton != null)
        {
            signOutButton.onClick.AddListener(SignOut);
        }

        exitButton.onClick.AddListener(() =>
        {
            if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
            Application.Quit();
        });

        // 3. Reminder Panel Button Listeners
        if (proceedButton != null)
            proceedButton.onClick.AddListener(() => PlayClickAndLoad("TutorialScene"));

        if (closeReminderButton != null)
            closeReminderButton.onClick.AddListener(HideReminder);

        // 4. Fetch Cloud Data as soon as the menu finishes setting up
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

    public void ResetGameData()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        PlayerPrefs.DeleteAll();
        PlayerPrefs.Save();

        stagesButton.interactable = false;
        if (GameManager.Instance != null)
        {
            GameManager.Instance.hasCompletedTutorial = false;
        }

        Debug.Log("All saved data has been wiped clean!");
    }

    // --- NEW: Cloud Data Functions ---
    public void FetchPlayerData()
    {
        FirebaseUser currentUser = FirebaseAuth.DefaultInstance.CurrentUser;

        if (currentUser == null)
        {
            Debug.LogWarning("No user logged in, returning to login screen.");
            SceneManager.LoadScene("LoginScene");
            return;
        }

        if (welcomeText != null) welcomeText.text = "Logged in as: " + currentUser.Email;
        if (statsText != null) statsText.text = "Syncing cloud data...";

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        DocumentReference docRef = db.Collection("Users").Document(currentUser.UserId);

        docRef.GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsFaulted)
            {
                Debug.LogError("Error fetching data: " + task.Exception);
                if (statsText != null) statsText.text = "Failed to load cloud data.";
                return;
            }

            DocumentSnapshot snapshot = task.Result;

            if (snapshot.Exists && statsText != null)
            {
                // 1. Check if they have a saved level in Firebase
                int unlockedLevel = 0;
                if (snapshot.ContainsField("HighestUnlockedLevel"))
                {
                    unlockedLevel = snapshot.GetValue<int>("HighestUnlockedLevel");
                }

                // 2. Translate that level into a clean UI status
                string progressText = "Tutorial Pending";
                if (unlockedLevel == 1) progressText = "Stage 1 Unlocked";
                else if (unlockedLevel == 2) progressText = "Stage 2 Unlocked";
                else if (unlockedLevel == 3) progressText = "Stage 3 Unlocked";
                else if (unlockedLevel >= 4) progressText = "Chief Resident (All Stages Completed)";

                // 3. Display it on the badge!
                statsText.text = $"Current Progress:\n{progressText}";

                // 4. Force the local device to unlock the stages based on cloud data
                if (unlockedLevel > PlayerPrefs.GetInt("UnlockedStageLevel", 0))
                {
                    PlayerPrefs.SetInt("UnlockedStageLevel", unlockedLevel);
                    PlayerPrefs.Save();
                }

                // 5. Instantly make the stages button clickable if they have progressed
                if (unlockedLevel > 0)
                {
                    if (GameManager.Instance != null) GameManager.Instance.hasCompletedTutorial = true;
                    if (stagesButton != null) stagesButton.interactable = true;
                }
            }
            else if (statsText != null)
            {
                statsText.text = "Welcome to your first shift!";
            }
        });
    }

    public void SignOut()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        FirebaseAuth.DefaultInstance.SignOut();
        SceneManager.LoadScene("LoginScene");
    }
}