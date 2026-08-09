using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    public Button newGameButton;
    public Button libraryButton; // Replaced continueButton
    public Button stagesButton;
    public Button optionsButton;
    public Button exitButton;

    void Start()
    {
        // Start the Stage 1 Tutorial we built!
        newGameButton.onClick.AddListener(() => SceneManager.LoadScene("TutorialScene"));

        // Open the medical reviewer/info scene
        libraryButton.onClick.AddListener(() => SceneManager.LoadScene("LibraryScene"));

        // Go to level select
        stagesButton.onClick.AddListener(() => SceneManager.LoadScene("StagesScene"));

        // Open settings
        optionsButton.onClick.AddListener(() => SceneManager.LoadScene("OptionsScene"));

        // Quit the game
        exitButton.onClick.AddListener(() => Application.Quit());
    }
}