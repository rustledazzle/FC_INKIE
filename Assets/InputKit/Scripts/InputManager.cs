using System.Collections.Generic;
using UnityEngine.EventSystems;
#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif
using UnityEngine.UI;
using UnityEngine;
using System;

/// <summary>
/// ----------------------------------------------------------------------------
/// Copyright (c) Dogan Kirnaz, 2025  
/// All rights reserved.
///
/// This script is the intellectual property of Dogan Kirnaz.  
/// Unauthorized use, reproduction, or distribution is strictly prohibited.
/// ----------------------------------------------------------------------------
/// </summary>


namespace InputKit
{
    public class InputManager : MonoBehaviour
    {
        [Tooltip("The input method to use (NewInput or OldInput).")]
        [SerializeField] private InputMethod inputMethod = InputMethod.NewInput;

        [Tooltip("The main camera used for input-related calculations.")]
        [SerializeField] private Camera mainCamera;

        [Tooltip("The GraphicRaycaster used for UI raycasting.")]
        [SerializeField] private GraphicRaycaster graphicRaycaster;

        [Tooltip("The mobile joystick used for movement input.")]
        [SerializeField] private Joystick mobileJoystick;

        [Header("Mobile Buttons")]
        [Tooltip("Button for firing actions.")]
        [SerializeField] private Button fireButton;

        [Tooltip("Button for jumping actions.")]
        [SerializeField] private Button jumpButton;

        [Tooltip("Button for crouching actions.")]
        [SerializeField] private Button crouchButton;

        [Tooltip("Button for sprinting actions.")]
        [SerializeField] private Button sprintButton;

        [Tooltip("Button for reloading actions.")]
        [SerializeField] private Button reloadButton;

        [Tooltip("Button for opening the inventory.")]
        [SerializeField] private Button inventoryButton;

        [Tooltip("Button for opening the map.")]
        [SerializeField] private Button mapButton;

        [Tooltip("Button for interacting with objects.")]
        [SerializeField] private Button interactButton;

        [Tooltip("Button for selecting the previous item.")]
        [SerializeField] private Button previousButton;

        [Tooltip("Button for selecting the next item.")]
        [SerializeField] private Button nextButton;

        [Tooltip("Button for going back.")]
        [SerializeField] private Button backButton;

        [Tooltip("Button for pausing the game.")]
        [SerializeField] private Button pauseButton;

        /// <summary>
        /// Singleton instance of the InputManager.
        /// </summary>
        public static InputManager Instance;

        private enum ButtonType { Non, Left, Right }
        private enum InputMethod { NewInput, OldInput }

        private PlayerInput playerInput;
        private Vector2 swipeStartPos;
        private float swipeThreshold = 50f;
        private bool fire, jump, crouch, sprint, reload, inventory, interact, map, previous, next, back, pause;

        private void Awake()
        {
            if (Instance == null)
            {
                Instance = this;
                DontDestroyOnLoad(gameObject);
            }
            else
            {
                Destroy(gameObject);
                return;
            }
        }

        private void Start()
        {
            mobileJoystick ??= FindFirstObjectByType<Joystick>();
            graphicRaycaster ??= FindFirstObjectByType<GraphicRaycaster>();

#if ENABLE_INPUT_SYSTEM
            playerInput ??= GetComponent<PlayerInput>();
            NewInput.SetInputButtons(playerInput, fire, jump, crouch, sprint, reload, inventory, interact, map, previous, next, back, pause);
#endif
            EnsureCamera();
            SetMobileButtons();
        }

        private void SetMobileButtons()
        {
            if (fireButton != null) fireButton.onClick.AddListener(() => fire = true);
            if (jumpButton != null) jumpButton.onClick.AddListener(() => jump = true);
            if (crouchButton != null) crouchButton.onClick.AddListener(() => crouch = true);
            if (sprintButton != null) sprintButton.onClick.AddListener(() => sprint = true);
            if (reloadButton != null) reloadButton.onClick.AddListener(() => reload = true);
            if (inventoryButton != null) inventoryButton.onClick.AddListener(() => inventory = true);
            if (interactButton != null) interactButton.onClick.AddListener(() => interact = true);
            if (mapButton != null) mapButton.onClick.AddListener(() => map = true);
            if (previousButton != null) previousButton.onClick.AddListener(() => previous = true);
            if (nextButton != null) nextButton.onClick.AddListener(() => next = true);
            if (backButton != null) backButton.onClick.AddListener(() => back = true);
            if (pauseButton != null) pauseButton.onClick.AddListener(() => pause = true);
        }

        /// <summary>
        /// Gets movement input from the appropriate method (new, old, or mobile).
        /// </summary>
        public Vector2 GetMove()
        {
            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                return NewInput.GetMove(playerInput);
#endif
            }
            return OldInput.GetMove() != Vector2.zero
                ? OldInput.GetMove()
                : mobileJoystick?.Direction ?? Vector2.zero;
        }

        /// <summary>Returns true if left button is pressed.</summary>
        public bool GetLeft() => GetButton(ButtonType.Left);

        /// <summary>Returns true if right button is pressed.</summary>
        public bool GetRight() => GetButton(ButtonType.Right);

        /// <summary>Returns the current screen touch or pointer position.</summary>
        public Vector2 GetScreenPosition()
        {
            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                return NewInput.GetPosition(playerInput);
#endif
            }
            return OldInput.GetPosition();
        }

        /// <summary>Converts the screen position to a world position using the main camera.</summary>
        public Vector2 GetWorldPosition() => (Vector2)GetWorldPoint();

        /// <summary>Detects swipe direction based on input movement.</summary>
        public InputHandler.SwipeDirection GetSwipe()
        {
            var swipeCurrentPos = Vector2.zero;
            var isPressed = false;
            var isReleased = false;

            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                swipeCurrentPos = NewInput.GetPosition(playerInput);
                isPressed = NewInput.GetPress(playerInput);
                isReleased = NewInput.GetRelease(playerInput);
#endif
            }
            else
            {
                swipeCurrentPos = OldInput.GetPosition();
                isPressed = OldInput.GetDown();
                isReleased = OldInput.GetUp();
            }

            if (isPressed) swipeStartPos = swipeCurrentPos;

            if (isReleased)
            {
                Vector2 swipeDelta = swipeCurrentPos - swipeStartPos;

                if (swipeDelta.magnitude > swipeThreshold)
                {
                    return Mathf.Abs(swipeDelta.x) > Mathf.Abs(swipeDelta.y)
                        ? (swipeDelta.x > 0 ? InputHandler.SwipeDirection.Right : InputHandler.SwipeDirection.Left)
                        : (swipeDelta.y > 0 ? InputHandler.SwipeDirection.Up : InputHandler.SwipeDirection.Down);
                }
            }

            return InputHandler.SwipeDirection.None;
        }

        /// <summary>Performs a Physics2D raycast and returns the hit Collider2D, if any.</summary>
        public Collider2D GetCast2D()
        {
            EnsureCamera();
            if (mainCamera == null) return null;

            if (IsInputDown())
            {
                var worldPoint = GetWorldPoint();
                return Physics2D.Raycast(worldPoint, Vector2.zero).collider;
            }

            return null;
        }

        /// <summary>Performs a Physics raycast and returns the hit 3D Collider, if any.</summary>
        public Collider GetCast3D()
        {
            EnsureCamera();
            if (mainCamera == null) return null;

            if (IsInputDown())
            {
                var worldPoint = GetWorldPoint();
                return Physics.Raycast(worldPoint, Vector3.forward, out RaycastHit hit) ? hit.collider : null;
            }

            return null;
        }

        /// <summary>Performs a UI raycast and returns the first hit RectTransform, if any.</summary>
        public RectTransform GetCastRect()
        {
            EnsureCamera();
            if (mainCamera == null) return null;

            if (IsInputDown())
            {
                var eventSystem = EventSystem.current;
                if (eventSystem == null) return null;

                PointerEventData pointerData = new PointerEventData(eventSystem)
                {
                    position = GetScreenPosition()
                };

                graphicRaycaster ??= FindFirstObjectByType<GraphicRaycaster>();
                if (graphicRaycaster == null) return null;

                List<RaycastResult> results = new List<RaycastResult>();
                graphicRaycaster.Raycast(pointerData, results);

                return results.Count > 0 ? results[0].gameObject.GetComponent<RectTransform>() : null;
            }

            return null;
        }

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetFire() => GetAction(ref fire, OldInput.GetFire);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetJump() => GetAction(ref jump, OldInput.GetJump);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetCrouch() => GetAction(ref crouch, OldInput.GetCrouch);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetSprint() => GetAction(ref sprint, OldInput.GetSprint);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetReload() => GetAction(ref reload, OldInput.GetReload);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetInventory() => GetAction(ref inventory, OldInput.GetInventory);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetInteract() => GetAction(ref interact, OldInput.GetInteract);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetMap() => GetAction(ref map, OldInput.GetMap);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetPrevious() => GetAction(ref previous, OldInput.GetPrevious);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetNext() => GetAction(ref next, OldInput.GetNext);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetBack() => GetAction(ref back, OldInput.GetBack);

        /// <summary>Returns true if the input is pressed or held (mouse/touch/click).</summary>
        public bool GetPause() => GetAction(ref pause, OldInput.GetPause);

#if ENABLE_INPUT_SYSTEM
        /// <summary>
        /// Gets the current value of an action (button, float, or vector) using the new Input System.
        /// </summary>
        /// <typeparam name="T">The type of input to return (bool, float, Vector2).</typeparam>
        /// <param name="actionName">The action name defined in Input Actions asset.</param>
        public T GetKey<T>(string actionName) where T : struct
        {
            if (inputMethod == InputMethod.NewInput && playerInput.actions.FindAction(actionName) != null)
            {
                return NewInput.GetActionValue<T>(playerInput, actionName);
            }
            return default;
        }
#endif

        private bool GetAction(ref bool actionFlag, Func<bool> oldInputAction)
        {
            if (actionFlag)
            {
                actionFlag = false;
                return true;
            }
            else if(inputMethod == InputMethod.OldInput) return oldInputAction();

            return false;
        }

        private bool IsInputDown()
        {
            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                return NewInput.GetPress(playerInput);
#endif
            }
            return OldInput.GetDown();
        }

        private Vector3 GetWorldPoint()
        {
            EnsureCamera();
            if (mainCamera == null) return Vector3.zero;

            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                return mainCamera.ScreenToWorldPoint(NewInput.GetPosition(playerInput));
#endif
            }

            return mainCamera.ScreenToWorldPoint(OldInput.GetPosition());
        }

        private bool GetButton(ButtonType type)
        {
            if (inputMethod == InputMethod.NewInput)
            {
#if ENABLE_INPUT_SYSTEM
                return NewInput.GetButton(playerInput, type.ToString());
#endif
            }

            return type switch
            {
                ButtonType.Left => OldInput.GetDown(),
                ButtonType.Right => OldInput.GetRight(),
                _ => false
            };
        }

        private void EnsureCamera() => mainCamera ??= Camera.main;
    }
}
