using UnityEngine;

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
    /// <summary>
    /// Provides a static interface for accessing input actions from the <see cref="InputManager"/>.
    /// </summary>
    public static class InputHandler
    {
        /// <summary>
        /// Reference to the singleton instance of <see cref="InputManager"/>.
        /// </summary>
        private static InputManager Instance => InputManager.Instance;

        /// <summary> Represents the None direction of a swipe gesture.</summary>
        public static SwipeDirection SwipeNone = SwipeDirection.None;

        /// <summary> Represents the Left direction of a swipe gesture.</summary>
        public static SwipeDirection SwipeLeft = SwipeDirection.Left;

        /// <summary> Represents the Right direction of a swipe gesture.</summary>
        public static SwipeDirection SwipeRight = SwipeDirection.Right;

        /// <summary> Represents the Up direction of a swipe gesture.</summary>
        public static SwipeDirection SwipeUp = SwipeDirection.Up;

        /// <summary> Represents the Down direction of a swipe gesture.</summary>
        public static SwipeDirection SwipeDown = SwipeDirection.Down;

        /// <summary> Represents the direction of a swipe gesture.</summary>
        public enum SwipeDirection { None, Up, Down, Left, Right }

        /// <summary>Checks if the fire input was triggered.</summary>
        public static bool GetFire() => Instance?.GetFire() ?? false;

        /// <summary>Checks if the jump input was triggered.</summary>
        public static bool GetJump() => Instance?.GetJump() ?? false;

        /// <summary>Checks if the crouch input was triggered.</summary>
        public static bool GetCrouch() => Instance?.GetCrouch() ?? false;

        /// <summary>Checks if the sprint input was triggered.</summary>
        public static bool GetSprint() => Instance?.GetSprint() ?? false;

        /// <summary>Checks if the reload input was triggered.</summary>
        public static bool GetReload() => Instance?.GetReload() ?? false;

        /// <summary>Checks if the inventory input was triggered.</summary>
        public static bool GetInventory() => Instance?.GetInventory() ?? false;

        /// <summary>Checks if the interact input was triggered.</summary>
        public static bool GetInteract() => Instance?.GetInteract() ?? false;

        /// <summary>Checks if the map input was triggered.</summary>
        public static bool GetMap() => Instance?.GetMap() ?? false;

        /// <summary>Checks if the previous input was triggered.</summary>
        public static bool GetPrevious() => Instance?.GetPrevious() ?? false;

        /// <summary>Checks if the next input was triggered.</summary>
        public static bool GetNext() => Instance?.GetNext() ?? false;

        /// <summary>Checks if the back input was triggered.</summary>
        public static bool GetBack() => Instance?.GetBack() ?? false;

        /// <summary>Checks if the pause input was triggered.</summary>
        public static bool GetPause() => Instance?.GetPause() ?? false;

        /// <summary>Checks if the left directional input is active.</summary>
        public static bool GetLeft() => Instance?.GetLeft() ?? false;

        /// <summary>Checks if the right directional input is active.</summary>
        public static bool GetRight() => Instance?.GetRight() ?? false;

        /// <summary>
        /// Gets the current swipe direction based on the input method.
        /// </summary>
        public static SwipeDirection GetSwipe() => Instance?.GetSwipe() ?? SwipeDirection.None;

        /// <summary>
        /// Gets the current movement vector.
        /// </summary>
        public static Vector2 GetMove() => Instance?.GetMove() ?? Vector2.zero;

        /// <summary>
        /// Gets the current screen position of the input pointer.
        /// </summary>
        public static Vector2 GetScreenPosition() => Instance?.GetScreenPosition() ?? Vector2.zero;

        /// <summary>
        /// Gets the world position based on the input pointer and main camera.
        /// </summary>
        public static Vector2 GetWorldPosition() => Instance?.GetWorldPosition() ?? Vector2.zero;

        /// <summary>
        /// Performs a 2D raycast at the pointer position and returns the hit collider.
        /// </summary>
        public static Collider2D GetCast2D() => Instance?.GetCast2D() ?? null;

        /// <summary>
        /// Performs a 3D raycast at the pointer position and returns the hit collider.
        /// </summary>
        public static Collider GetCast3D() => Instance?.GetCast3D() ?? null;

        /// <summary>
        /// Performs a UI raycast at the pointer position and returns the hit RectTransform.
        /// </summary>
        public static RectTransform GetCastRect() => Instance?.GetCastRect() ?? null;

#if ENABLE_INPUT_SYSTEM
        /// <summary>
        /// Gets the value of a specified input action from the new Input System.
        /// </summary>
        /// <typeparam name="T">The type of value to retrieve (e.g., bool, float, Vector2).</typeparam>
        /// <param name="actionName">The name of the action in the Input Actions asset.</param>
        /// <returns>The current value of the action, or default if unavailable.</returns>
        public static T GetKey<T>(string actionName) where T : struct
        {
            return Instance != null ? Instance.GetKey<T>(actionName) : default;
        }
#endif
    }
}
