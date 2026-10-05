using UnityEngine;
using UnityEngine.InputSystem;

public class NpcInteraction : MonoBehaviour
{
    [Header("Patient Details")]
    [SerializeField] private TextAsset inkJSON;
    [TextArea(5, 10)]
    [SerializeField] private string patientNotes;

    [Header("UI Prompt")]
    [SerializeField] private GameObject interactPrompt;

    private bool playerInRange;
    private bool hasBeenDiagnosed = false;

    // Dynamically tracks the NPC the player is currently standing next to
    public static NpcInteraction activeNPC;

    void Start()
    {
        if (interactPrompt != null) interactPrompt.SetActive(false);
    }

    void Update()
    {
        // PC 'E' key check
        if (playerInRange && !DialogueManager.Instance.isDialogueActive && !hasBeenDiagnosed)
        {
            if (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame)
            {
                TriggerDialogue();
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player") && !hasBeenDiagnosed)
        {
            playerInRange = true;
            activeNPC = this; // Set this specific NPC as the active one in range!
            if (interactPrompt != null) interactPrompt.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player"))
        {
            playerInRange = false;
            if (activeNPC == this)
            {
                activeNPC = null; // Clear it when walking away
            }
            if (interactPrompt != null) interactPrompt.SetActive(false);
        }
    }

    // This is called by your mobile button to interact with whichever NPC is currently nearby
    public static void TriggerActiveNPC()
    {
        if (activeNPC != null && !DialogueManager.Instance.isDialogueActive && !activeNPC.hasBeenDiagnosed)
        {
            activeNPC.TriggerDialogue();
        }
    }

    private void TriggerDialogue()
    {
        hasBeenDiagnosed = true;
        if (interactPrompt != null) interactPrompt.SetActive(false);
        DialogueManager.Instance.EnterDialogueMode(inkJSON, patientNotes);
    }
}