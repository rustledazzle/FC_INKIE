using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class TutorialManager : MonoBehaviour
{
    [Header("UI Elements")]
    public GameObject tutorialPanel;
    public TextMeshProUGUI tutorialText;
    public Image tutorialImage; // NEW: The UI image component
    public Button nextButton;
    public Button closeButton;

    [Header("Tutorial Content (Edit in Unity!)")]
    [TextArea(3, 5)]
    public string[] pages;
    public Sprite[] pageImages; // NEW: The screenshots for each page

    private int currentPage = 0;

    void Start()
    {
        // Safety check: if you leave the pages empty, don't show the panel at all
        if (pages == null || pages.Length == 0)
        {
            tutorialPanel.SetActive(false);
            return;
        }

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
        // Update the text
        tutorialText.text = pages[currentPage];

        // NEW: Update the image if one exists for this page
        if (tutorialImage != null)
        {
            if (pageImages != null && currentPage < pageImages.Length && pageImages[currentPage] != null)
            {
                tutorialImage.sprite = pageImages[currentPage];
                tutorialImage.gameObject.SetActive(true);
            }
            else
            {
                // Hide the image slot if there is no screenshot for this specific page
                tutorialImage.gameObject.SetActive(false);
            }
        }

        // If we are on the last page, hide Next and show Close
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