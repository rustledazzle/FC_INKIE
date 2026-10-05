using UnityEngine;
using UnityEngine.InputSystem;
using InputKit;

public class PlayerMovement : MonoBehaviour
{
    [Header("Movement Settings")]
    public float moveSpeed = 5f;

    [Header("Mobile Joystick Reference")]
    public InputKit.Joystick mobileJoystick; // Drag your FixedJoystick here from the Hierarchy

    private Rigidbody2D rb;
    private Vector2 movement;
    private Animator anim;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        anim = GetComponent<Animator>();

        if (mobileJoystick == null)
        {
            mobileJoystick = FindFirstObjectByType<InputKit.Joystick>();
        }
    }

    void Update()
    {
        // 1. Freeze player completely when dialogue is active
        if (DialogueManager.Instance != null && DialogueManager.Instance.isDialogueActive)
        {
            movement = Vector2.zero;
            if (anim != null) anim.SetBool("IsMoving", false);
            return;
        }

        movement = Vector2.zero;

        // 2. Read Mobile Joystick Input
        if (mobileJoystick != null)
        {
            movement = mobileJoystick.Direction;
        }

        // 3. Fallback to PC Keyboard WASD / Arrow Keys
        if (movement == Vector2.zero && Keyboard.current != null)
        {
            if (Keyboard.current.wKey.isPressed || Keyboard.current.upArrowKey.isPressed) movement.y = 1;
            if (Keyboard.current.sKey.isPressed || Keyboard.current.downArrowKey.isPressed) movement.y = -1;
            if (Keyboard.current.aKey.isPressed || Keyboard.current.leftArrowKey.isPressed) movement.x = -1;
            if (Keyboard.current.dKey.isPressed || Keyboard.current.rightArrowKey.isPressed) movement.x = 1;
        }

        // 4. Force Strict 4-Way Cardinal Movement (Eliminates diagonal clunkiness)
        if (Mathf.Abs(movement.x) > Mathf.Abs(movement.y))
        {
            movement = new Vector2(Mathf.Sign(movement.x), 0);
        }
        else if (Mathf.Abs(movement.y) > Mathf.Abs(movement.x))
        {
            movement = new Vector2(0, Mathf.Sign(movement.y));
        }
        else
        {
            movement = Vector2.zero;
        }

        UpdateAnimation();

        // 5. Check Interaction using SimulateEKey (Handles both PC 'E' key AND Mobile Button tap)
        if (SimulateEKey.CheckInteractPressed())
        {
            TriggerInteraction();
        }
    }

    void FixedUpdate()
    {
        if (DialogueManager.Instance == null || !DialogueManager.Instance.isDialogueActive)
        {
            rb.MovePosition(rb.position + movement * moveSpeed * Time.fixedDeltaTime);
        }
    }

    private void UpdateAnimation()
    {
        if (anim == null) return;
        bool isMoving = movement.sqrMagnitude > 0;
        anim.SetBool("IsMoving", isMoving);
        if (isMoving)
        {
            anim.SetFloat("MoveX", movement.x);
            anim.SetFloat("MoveY", movement.y);
        }
    }

    void TriggerInteraction()
    {
        Debug.Log("Interaction input received via keyboard or mobile button!");

        // If your Windows code relies on a trigger collider or script on your patient, 
        // you can call it here or let your existing interaction system catch it.
    }
}