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
            stage2Button.onClick.AddListener(() => PlayClickAndLoad("Stage1Afternoon"));

        if (stage3Button != null)
            stage3Button.onClick.AddListener(() => PlayClickAndLoad("SpecialCasesScene"));

        if (stage4Button != null)
            stage4Button.onClick.AddListener(() => PlayClickAndLoad("Stage4Scene"));

        // Apply the lock state to the buttons immediately when the menu opens
        UpdateStageLocks();

        Debug.Log("StagesMenuManager initialized. Buttons are ready to use.");
    }

    void UpdateStageLocks()
    {
        // Get the highest unlocked stage level. Default is 0 (Only Stage 1 unlocked).
        int unlockedLevel = PlayerPrefs.GetInt("UnlockedStageLevel", 0);

        // Stage 1 (Morning) is always unlocked
        if (stage1Button != null) stage1Button.interactable = true;

        // Stage 2 (Afternoon) requires Level 1 or higher
        if (stage2Button != null) stage2Button.interactable = (unlockedLevel >= 1);

        // Stage 3 (Special Cases) requires Level 2 or higher
        if (stage3Button != null) stage3Button.interactable = (unlockedLevel >= 2);

        // Stage 4 requires Level 3 or higher
        if (stage4Button != null) stage4Button.interactable = (unlockedLevel >= 3);
    }

    // --- Helper function to play the click sound and load the scene ---
    private void PlayClickAndLoad(string sceneName)
    {
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayClick();
        }
        SceneManager.LoadScene(sceneName);
    }
}