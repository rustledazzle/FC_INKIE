using UnityEngine;
using UnityEngine.InputSystem;

public class NPCInteract : MonoBehaviour
{
    [Header("Patient Details")]
    [SerializeField] private TextAsset inkJSON;
    [TextArea(5, 10)]
    [SerializeField] private string patientNotes;

    private bool playerInRange;

    // NEW: A lock to prevent talking to the same patient twice
    private bool hasBeenDiagnosed = false;

    void Update()
    {
        // We now check if hasBeenDiagnosed is false before allowing interaction!
        if (playerInRange && !DialogueManager.Instance.isDialogueActive && !hasBeenDiagnosed)
        {
            if (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame)
            {
                hasBeenDiagnosed = true; // Lock this patient so they can't be diagnosed again
                DialogueManager.Instance.EnterDialogueMode(inkJSON, patientNotes);
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player")) playerInRange = true;
    }

    private void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.CompareTag("Player")) playerInRange = false;
    }
}