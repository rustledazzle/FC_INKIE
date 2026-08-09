using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class TutorialManager : MonoBehaviour
{
    [Header("UI Elements")]
    public GameObject tutorialPanel;
    public TextMeshProUGUI tutorialText;
    public Button nextButton;
    public Button closeButton;

    private int currentPage = 0;

    // Type your 2 pages of tutorial text here!
    private string[] pages = {
        "Welcome to the Clinic!\n\nUse your WASD keys to move around the room.",
        "Your goal today is to diagnose 3 patients.\n\nWalk up to a patient and press 'E' to begin a consultation. Good luck!"
    };

    void Start()
    {
        // Pause the player from walking while reading the tutorial
        if (DialogueManager.Instance != null) DialogueManager.Instance.SetDialogueActiveState(true);

        tutorialPanel.SetActive(true);
        currentPage = 0;
        UpdateUI();

        nextButton.onClick.AddListener(NextPage);
        closeButton.onClick.AddListener(CloseTutorial);
    }

    void NextPage()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        currentPage++;
        UpdateUI();
    }

    void UpdateUI()
    {
        tutorialText.text = pages[currentPage];

        // If we are on the last page (Page 2), hide Next and show Close
        if (currentPage >= pages.Length - 1)
        {
            nextButton.gameObject.SetActive(false);
            closeButton.gameObject.SetActive(true);
        }
        else
        {
            nextButton.gameObject.SetActive(true);
            closeButton.gameObject.SetActive(false);
        }
    }

    void CloseTutorial()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        tutorialPanel.SetActive(false);

        // Unfreeze the player so they can walk
        if (DialogueManager.Instance != null) DialogueManager.Instance.SetDialogueActiveState(false);
    }
}