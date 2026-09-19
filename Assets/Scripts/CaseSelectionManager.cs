using UnityEngine;
using UnityEngine.UI;

public class CaseSelectionManager : MonoBehaviour
{
    [Header("UI Elements")]
    public GameObject selectionPanel; // Drag your CaseSelectionMenu here
    public Button hSyndromeButton;    // Drag your Case1_HSyndrome button here
    public Button leptoButton;        // Drag your Case2_Leptospirosis button here

    [Header("Ink Stories (Drag your .json files here)")]
    public TextAsset hSyndromeInk;
    public TextAsset leptoInk;

    [Header("Medical Notes (Case File)")]
    [TextArea(3, 5)]
    public string hSyndromeNotes = "Patient: Maria, 16 years old, female\nChief Complaint: 'Namamaga ang pisngi at may maitim na balat sa hita.'\nCompanion: Aling Liza (mother)";

    [TextArea(3, 5)]
    public string leptoNotes = "Patient: Pending\nChief Complaint: Continuous fever after wading in floodwaters.";

    void Start()
    {
        // 1. Show the selection menu when the scene starts
        if (selectionPanel != null) selectionPanel.SetActive(true);

        // 2. Hook up the buttons to start the specific cases, passing the button itself to disable it later!
        if (hSyndromeButton != null)
        {
            hSyndromeButton.onClick.AddListener(() => StartCase(hSyndromeButton, hSyndromeInk, hSyndromeNotes));
        }

        if (leptoButton != null)
        {
            leptoButton.onClick.AddListener(() => StartCase(leptoButton, leptoInk, leptoNotes));
        }
    }

    void Update()
    {
        // Automatically hide the selection menu while reading a case file OR viewing feedback
        if (DialogueManager.Instance != null && selectionPanel != null)
        {
            bool isReadingDialogue = DialogueManager.Instance.isDialogueActive;
            bool isViewingFeedback = DialogueManager.Instance.IsFeedbackPanelActive();

            // If BOTH the dialogue box and the feedback panel are closed, turn the menu back on!
            if (!isReadingDialogue && !isViewingFeedback)
            {
                selectionPanel.SetActive(true);
            }
            else
            {
                selectionPanel.SetActive(false);
            }
        }
    }

    void StartCase(Button clickedButton, TextAsset inkStory, string notes)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (DialogueManager.Instance != null && inkStory != null)
        {
            // 1. Turn off the button so the player can't click it again and cheat the score!
            if (clickedButton != null) clickedButton.interactable = false;

            // 2. Manually hide the panel right as the dialogue starts
            if (selectionPanel != null) selectionPanel.SetActive(false);

            // 3. Tell the DialogueManager to start the story!
            DialogueManager.Instance.EnterDialogueMode(inkStory, notes);
        }
        else
        {
            Debug.LogWarning("Cannot start case! Missing Ink Story JSON or DialogueManager.");
        }
    }

    // You can trigger this function from a button when a case finishes to bring the menu back!
    public void ShowMenuAgain()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        if (selectionPanel != null) selectionPanel.SetActive(true);
    }
}