using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    public Button newGameButton;
    public Button libraryButton; // Replaced continue with library based on previous setup
    public Button stagesButton;
    public Button optionsButton;
    public Button exitButton;

    void Start()
    {
        // 1. Lock or Unlock the Stages button based on GameManager progress
        if (GameManager.Instance != null)
        {
            stagesButton.interactable = GameManager.Instance.hasCompletedTutorial;
        }
        else
        {
            stagesButton.interactable = false; // Default to locked if no GameManager exists yet
        }

        // 2. Button Listeners
        newGameButton.onClick.AddListener(() => PlayClickAndLoad("TutorialScene"));
        libraryButton.onClick.AddListener(() => PlayClickAndLoad("LibraryScene"));
        stagesButton.onClick.AddListener(() => PlayClickAndLoad("StagesScene"));
        optionsButton.onClick.AddListener(() => PlayClickAndLoad("OptionsScene"));
        exitButton.onClick.AddListener(() =>
        {
            if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
            Application.Quit();
        });
    }

    private void PlayClickAndLoad(string sceneName)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        SceneManager.LoadScene(sceneName);
    }
}