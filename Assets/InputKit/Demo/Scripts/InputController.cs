using UnityEngine;
using InputKit; // Make sure to include the InputKit namespace

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
    public class InputController : MonoBehaviour
    {
        private void Update()
        {
            // Checks if the fire button (e.g., attack or shoot) is pressed.
            if(InputHandler.GetFire())
            {
              Debug.Log("Fire button pressed");
            }

            // Checks if the jump button (e.g., to make the character jump) is pressed.
            if(InputHandler.GetJump())
            {
              Debug.Log("Jump button pressed");
            }

            // Checks if the crouch button (e.g., for crouching action) is pressed.
            if(InputHandler.GetCrouch())
            {
              Debug.Log("Crouch button pressed");
            }

            // Checks if the sprint button (e.g., for running faster) is pressed.
            if(InputHandler.GetSprint())
            {
              Debug.Log("Sprint button pressed");
            }

            // Checks if the reload button (e.g., to reload a weapon) is pressed.
            if(InputHandler.GetReload())
            {
              Debug.Log("Reload button pressed");
            }

            // Checks if the inventory button (e.g., to open the inventory) is pressed.
            if(InputHandler.GetInventory())
            {
              Debug.Log("Inventory button pressed");
            }

            // Checks if the interact button (e.g., to interact with objects) is pressed.
            if(InputHandler.GetInteract())
            {
              Debug.Log("Interact button pressed");
            }

            // Checks if the map button (e.g., to open the map) is pressed.
            if(InputHandler.GetMap())
            {
              Debug.Log("Map button pressed");
            }

            // Checks if the "previous" button (e.g., to go to the previous menu or page) is pressed.
            if(InputHandler.GetPrevious())
            {
              Debug.Log("Previous button pressed");
            }

            // Checks if the "next" button (e.g., to go to the next menu or page) is pressed.
            if(InputHandler.GetNext())
            {
              Debug.Log("Next button pressed");
            }

            // Checks if the "back" button (e.g., to go back or cancel) is pressed.
            if(InputHandler.GetBack())
            {
              Debug.Log("Back button pressed");
            }

            // Checks if the pause button (e.g., to pause the game) is pressed.
            if(InputHandler.GetPause())
            {
              Debug.Log("Pause button pressed");
            }

            // Checks if the left directional button (e.g., left arrow or joystick left) is active.
            if(InputHandler.GetLeft())
            {
              Debug.Log("Left button pressed");
            }

            // Checks if the right directional button (e.g., right arrow or joystick right) is active.
            if(InputHandler.GetRight())
            {
              Debug.Log("Right button pressed");
            }

            // Checks if a swipe left action is detected (e.g., for touch or swipe gesture).
            if(InputHandler.GetSwipe() == InputHandler.SwipeLeft)
            {
              Debug.Log("Swipe left detected");
            }

            // Checks if a swipe right action is detected (e.g., for touch or swipe gesture).
            if(InputHandler.GetSwipe() == InputHandler.SwipeRight)
            {
              Debug.Log("Swipe right detected");
            }
            
            // Checks if there is any movement input (e.g., W, A, S, D, joystick input).
            if(InputHandler.GetMove() != Vector2.zero)
            {
              Debug.Log("Move detected: " + InputHandler.GetMove());
            }

            // Checks if the screen position of the input pointer (e.g., mouse or touch position) is non-zero.
            if(InputHandler.GetScreenPosition() != Vector2.zero)
            {
              // Debug.Log("Screen position detected: " + InputHandler.GetScreenPosition());
            }
            
            // Checks if the world position of the input pointer is non-zero (converted from screen position).
            if(InputHandler.GetWorldPosition() != Vector2.zero)
            {
              // Debug.Log("World position detected: " + InputHandler.GetWorldPosition());
            }

            // Performs a 2D raycast at the input position and checks if any 2D colliders are hit.
            Collider2D hit2D = InputHandler.GetCast2D();
            if (hit2D != null) 
            {
                Debug.Log("2D Object hit: " + hit2D.name);
            }
              
            // Performs a 3D raycast at the input position and checks if any 3D colliders are hit.
            Collider hit3D = InputHandler.GetCast3D();
            if (hit3D != null) 
            {
                Debug.Log("3D Object hit: " + hit3D.name);
            }             

            // Performs a UI raycast at the input position and checks if any UI elements are hit.
            RectTransform uiHit = InputHandler.GetCastRect();
            if (uiHit != null) 
            {
                Debug.Log("UI Element hit: " + uiHit.name);
            }     

            // Retrieves a custom float value from the new input system, using the action name "CustomFloat".
            float customFloat = InputHandler.GetKey<float>("CustomFloat");

            // Retrieves a custom Vector2 value from the new input system, using the action name "CustomVector2".
            Vector2 customVector2 = InputHandler.GetKey<Vector2>("CustomVector2");

            // Retrieves a custom boolean value from the new input system, using the action name "CustomBool".
            bool customBool = InputHandler.GetKey<bool>("CustomBool");
        }
    }
}