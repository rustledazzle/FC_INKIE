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

    [Header("Reminder Panel")]
    public GameObject reminderPanel;
    public Button proceedButton;
    public Button closeReminderButton;

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
}