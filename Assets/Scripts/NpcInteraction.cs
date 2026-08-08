using UnityEngine;
using UnityEngine.InputSystem;

public class NPCInteract : MonoBehaviour
{
    [Header("Patient Details")]
    [SerializeField] private TextAsset inkJSON;

    // This allows you to type multiple lines of notes in the Inspector!
    [TextArea(5, 10)]
    [SerializeField] private string patientNotes;

    private bool playerInRange;

    void Update()
    {
        if (playerInRange && !DialogueManager.Instance.isDialogueActive)
        {
            if (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame)
            {
                // Pass both the Ink file AND the notes to the Dialogue Manager
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