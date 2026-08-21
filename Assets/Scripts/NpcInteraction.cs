using UnityEngine;
using UnityEngine.InputSystem;

public class NPCInteract : MonoBehaviour
{
    [Header("Patient Details")]
    [SerializeField] private TextAsset inkJSON;
    [TextArea(5, 10)]
    [SerializeField] private string patientNotes;

    [Header("UI Prompt")]
    [SerializeField] private GameObject interactPrompt; // NEW: Drag your World Space Canvas here!

    private bool playerInRange;
    private bool hasBeenDiagnosed = false;

    void Start()
    {
        if (interactPrompt != null) interactPrompt.SetActive(false);
    }

    void Update()
    {
        if (playerInRange && !DialogueManager.Instance.isDialogueActive && !hasBeenDiagnosed)
        {
            if (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame)
            {
                hasBeenDiagnosed = true;
                if (interactPrompt != null) interactPrompt.SetActive(false); // Hide prompt when talking
                DialogueManager.Instance.EnterDialogueMode(inkJSON, patientNotes);
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player") && !hasBeenDiagnosed)
        {
            playerInRange = true;
            if (interactPrompt != null) interactPrompt.SetActive(true); // Show prompt
        }
    }

    private void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player"))
        {
            playerInRange = false;
            if (interactPrompt != null) interactPrompt.SetActive(false); // Hide prompt
        }
    }
}