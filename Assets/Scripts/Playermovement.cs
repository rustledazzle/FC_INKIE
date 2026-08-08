using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMovement : MonoBehaviour
{
    [Header("Movement Settings")]
    public float moveSpeed = 5f;

    private Rigidbody2D rb;
    private Vector2 movement;
    private Animator anim;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        anim = GetComponent<Animator>();
    }

    void Update()
    {
        // 1. Freeze player and set IsMoving to false when dialogue is active
        if (DialogueManager.Instance != null && DialogueManager.Instance.isDialogueActive)
        {
            movement = Vector2.zero;
            if (anim != null) anim.SetBool("IsMoving", false);
            return;
        }

        movement = Vector2.zero;

        // 2. Read input
        if (Keyboard.current != null)
        {
            if (Keyboard.current.wKey.isPressed || Keyboard.current.upArrowKey.isPressed) movement.y = 1;
            if (Keyboard.current.sKey.isPressed || Keyboard.current.downArrowKey.isPressed) movement.y = -1;
            if (Keyboard.current.aKey.isPressed || Keyboard.current.leftArrowKey.isPressed) movement.x = -1;
            if (Keyboard.current.dKey.isPressed || Keyboard.current.rightArrowKey.isPressed) movement.x = 1;
        }

        movement.Normalize();

        // 3. Send the movement data directly to your Animator Parameters!
        UpdateAnimation();
    }

    void FixedUpdate()
    {
        if (DialogueManager.Instance != null && !DialogueManager.Instance.isDialogueActive)
        {
            rb.MovePosition(rb.position + movement * moveSpeed * Time.fixedDeltaTime);
        }
    }

    // --- NEW ANIMATION LOGIC ---
    private void UpdateAnimation()
    {
        if (anim == null) return;

        // Check if we are pressing any keys
        bool isMoving = movement.sqrMagnitude > 0;

        // Tells your transition arrows (image_adca58, image_adca3d) whether to walk or idle
        anim.SetBool("IsMoving", isMoving);

        // If we are walking, tell the Animator which direction so it triggers the right state
        if (isMoving)
        {
            anim.SetFloat("MoveX", movement.x);
            anim.SetFloat("MoveY", movement.y);
        }
    }
}