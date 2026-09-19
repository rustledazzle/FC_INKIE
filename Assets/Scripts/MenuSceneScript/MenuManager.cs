using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    [Header("Main Menu Buttons")]
    public Button newGameButton;
    public Button libraryButton;
    public Button stagesButton;
    public Button optionsButton;
    public Button exitButton;
    public Button badgeButton; // NEW: Badge button for testing

    [Header("Reminder Panel")]
    public GameObject reminderPanel;
    public Button proceedButton;
    public Button closeReminderButton;

    [Header("Data Management")]
    public Button resetDataButton; // NEW: Drag your Reset button here

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
        // New Game now OPENS the reminder panel instead of loading the scene directly!
        newGameButton.onClick.AddListener(ShowReminder);

        libraryButton.onClick.AddListener(() => PlayClickAndLoad("LibraryScene"));
        stagesButton.onClick.AddListener(() => PlayClickAndLoad("StagesScene"));
        optionsButton.onClick.AddListener(() => PlayClickAndLoad("OptionsScene"));
        badgeButton.onClick.AddListener(() => PlayClickAndLoad("BadgesScene")); // NEW: Badge button functionality

        // NEW: Wire up the reset button
        if (resetDataButton != null)
        {
            resetDataButton.onClick.AddListener(ResetGameData);
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
    }

    // Functions to show/hide the reminder panel
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

    // NEW: Function to wipe all saved data
    public void ResetGameData()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        // Deletes all saved scores and prefixes from the local drive
        PlayerPrefs.DeleteAll();
        PlayerPrefs.Save();

        // Lock the stages button immediately so the player sees the reset happen
        stagesButton.interactable = false;
        if (GameManager.Instance != null)
        {
            GameManager.Instance.hasCompletedTutorial = false;
        }

        Debug.Log("All saved data has been wiped clean!");
    }
}