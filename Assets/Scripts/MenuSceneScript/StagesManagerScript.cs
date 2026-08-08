using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StagesMenuManager : MonoBehaviour
{
    [Header("Buttons")]
    public Button backButton;
    public Button stage1Button;
    public Button stage2Button;
    public Button stage3Button;
    public Button stage4Button;

    void Start()
    {
        if (backButton != null)
            backButton.onClick.AddListener(() => SceneManager.LoadScene("MenuScene"));

        if (stage1Button != null)
            stage1Button.onClick.AddListener(() => SceneManager.LoadScene("MainScene"));

        if (stage2Button != null)
            stage2Button.onClick.AddListener(() => SceneManager.LoadScene("Stage2Scene"));

        if (stage3Button != null)
            stage3Button.onClick.AddListener(() => SceneManager.LoadScene("Stage3Scene"));

        if (stage4Button != null)
            stage4Button.onClick.AddListener(() => SceneManager.LoadScene("Stage4Scene"));

        Debug.Log("StagesMenuManager initialized. Buttons are ready to use.");
    }
}
