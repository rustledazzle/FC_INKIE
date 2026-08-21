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
            backButton.onClick.AddListener(() => PlayClickAndLoad("MenuScene"));

        if (stage1Button != null)
            stage1Button.onClick.AddListener(() => PlayClickAndLoad("Stage1Scene"));

        if (stage2Button != null)
            stage2Button.onClick.AddListener(() => PlayClickAndLoad("Stage2Scene")); //temporary scene name, change to actual scene name when available

        if (stage3Button != null)
            stage3Button.onClick.AddListener(() => PlayClickAndLoad("Stage3Scene")); //temporary scene name, change to actual scene name when available

        if (stage4Button != null)
            stage4Button.onClick.AddListener(() => PlayClickAndLoad("Stage4Scene")); //temporary scene name, change to actual scene name when available

        Debug.Log("StagesMenuManager initialized. Buttons are ready to use.");
    }

    // --- NEW: Helper function to play the click sound and load the scene ---
    private void PlayClickAndLoad(string sceneName)
    {
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayClick();
        }
        SceneManager.LoadScene(sceneName);
    }
}