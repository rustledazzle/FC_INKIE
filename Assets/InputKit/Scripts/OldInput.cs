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
    public static class OldInput
    {
        public static bool GetDown()
        {
            return Input.GetMouseButtonDown(0) ||
               (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began) ||
               Input.GetKeyDown(KeyCode.Return) ||
               Input.GetKeyDown(KeyCode.KeypadEnter) ||
               Input.GetKeyDown((KeyCode)Gamepad.X);
        }

        public static bool GetUp()
        {
            return Input.GetMouseButtonUp(0) ||
               Input.touchCount > 0 && (Input.GetTouch(0).phase == TouchPhase.Ended || Input.GetTouch(0).phase == TouchPhase.Canceled) ||
               Input.GetKeyUp(KeyCode.Return) ||
               Input.GetKeyUp(KeyCode.KeypadEnter) ||
               Input.GetKeyUp((KeyCode)Gamepad.X);
        }

        public static bool GetRight()
        {
            return Input.GetMouseButtonDown(1) || Input.GetKeyDown((KeyCode)Gamepad.B);
        }

        public static Vector2 GetPosition()
        {
            if (Input.touchSupported && Input.touchCount > 0)
                return Input.GetTouch(0).position;
            else
                return Input.mousePosition;
        }

        public static Vector2 GetMove()
        {
            Vector2 move = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            if (move.magnitude > 1)
                move.Normalize();
            return move;
        }

        public static bool GetJump()
        {
            return Input.GetKeyDown(KeyCode.Space) ||
            Input.GetKeyUp((KeyCode)Gamepad.A);           
        }

        public static bool GetCrouch()
        {
            return Input.GetKeyDown(KeyCode.LeftControl) ||
            Input.GetKeyUp((KeyCode)Gamepad.L3); 
        }

        public static bool GetSprint()
        {
            return Input.GetKey(KeyCode.LeftShift) ||
            Input.GetKey((KeyCode)Gamepad.LB); 
        }

        public static bool GetReload()
        {
            return Input.GetKeyDown(KeyCode.R) ||
            Input.GetKeyUp((KeyCode)Gamepad.X); 
        }

        public static bool GetInventory()
        {
            return Input.GetKeyDown(KeyCode.Tab) || Input.GetKeyDown(KeyCode.I) ||
            Input.GetKeyUp((KeyCode)Gamepad.Y); 
        }

        public static bool GetFire()
        {
            return Input.GetMouseButton(0) ||
            Input.GetKey((KeyCode)Gamepad.A); 
        }

        public static bool GetInteract()
        {
            return Input.GetKeyDown(KeyCode.F) ||
            Input.GetKeyUp((KeyCode)Gamepad.Y); 
        }

        public static bool GetMap()
        {
            return Input.GetKeyDown(KeyCode.M) ||
            Input.GetKeyUp((KeyCode)Gamepad.Back); 
        }

        public static bool GetPrevious()
        {
            return Input.GetKeyDown(KeyCode.Q) ||
            Input.GetKeyUp((KeyCode)Gamepad.LB); 
        }

        public static bool GetNext()
        {
            return Input.GetKeyDown(KeyCode.E) ||
            Input.GetKeyUp((KeyCode)Gamepad.RB); 
        }

        public static bool GetBack()
        {
            return Input.GetKeyDown(KeyCode.Escape) ||
            Input.GetKeyUp((KeyCode)Gamepad.B); 
        }

        public static bool GetPause()
        {
            return Input.GetKeyDown(KeyCode.Escape) || Input.GetKeyDown(KeyCode.P) ||
            Input.GetKeyUp((KeyCode)Gamepad.Start); 
        }

        private enum Gamepad
        {
            A = KeyCode.JoystickButton0, // Confirm / Jump (Cross (×))
            B = KeyCode.JoystickButton1, // Cancel / Back (Circle (⭘))
            X = KeyCode.JoystickButton2, // Interact / Reload (Square (◻))
            Y = KeyCode.JoystickButton3, // Use / Inventory (Triangle (△))
            LB = KeyCode.JoystickButton4, // Sprint / Previous
            RB = KeyCode.JoystickButton5, // Fire / Next
            Back = KeyCode.JoystickButton6, // Map / Secondary Menu
            Start = KeyCode.JoystickButton7, // Pause / Main Menu
            L3 = KeyCode.JoystickButton8, // Crouch / Toggle
            R3 = KeyCode.JoystickButton9 // Melee / Toggle Look
        }
    }
}
