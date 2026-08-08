using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuManager : MonoBehaviour
{
    public Button newGameButton;
    public Button continueButton;
    public Button stagesButton;
    public Button optionsButton;
    public Button exitButton;

    void Start()
    {
        newGameButton.onClick.AddListener(() => SceneManager.LoadScene("TypeYourNameScene"));
        continueButton.onClick.AddListener(() => SceneManager.LoadScene("StagesScene"));
        stagesButton.onClick.AddListener(() => SceneManager.LoadScene("StagesScene"));
        optionsButton.onClick.AddListener(() => SceneManager.LoadScene("OptionsScene"));
        exitButton.onClick.AddListener(() => Application.Quit());
    }
}
