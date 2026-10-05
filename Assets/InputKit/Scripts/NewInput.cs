#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
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
    public static class NewInput
    {
        public static void SetInputButtons(PlayerInput input, bool fire, bool jump, bool crouch, bool sprint, bool reload, bool inventory, bool interact, bool map, bool previous, bool next, bool back, bool pause)
        {
            input.actions["Fire"].performed += ctx => { fire = ctx.ReadValue<float>() == 1; };
            input.actions["Jump"].performed += ctx => { jump = ctx.ReadValue<float>() == 1; };
            input.actions["Crouch"].performed += ctx => { crouch = ctx.ReadValue<float>() == 1; };
            input.actions["Sprint"].performed += ctx => { sprint = ctx.ReadValue<float>() == 1; };
            input.actions["Reload"].performed += ctx => { reload = ctx.ReadValue<float>() == 1; };
            input.actions["Inventory"].performed += ctx => { inventory = ctx.ReadValue<float>() == 1; };
            input.actions["Interact"].performed += ctx => { interact = ctx.ReadValue<float>() == 1; };
            input.actions["Map"].performed += ctx => { map = ctx.ReadValue<float>() == 1; };
            input.actions["Previous"].performed += ctx => { previous = ctx.ReadValue<float>() == 1; };
            input.actions["Next"].performed += ctx => { next = ctx.ReadValue<float>() == 1; };
            input.actions["Back"].performed += ctx => { back = ctx.ReadValue<float>() == 1; };
            input.actions["Pause"].performed += ctx => { pause = ctx.ReadValue<float>() == 1; };
        }

        public static T GetActionValue<T>(PlayerInput input, string actionName) where T : struct
        {
            var action = input.actions[actionName];
            if (action != null)
            {
                return action.ReadValue<T>();
            }
            return default;
        }

        public static Vector2 GetMove(PlayerInput input)
        {
            return input.actions["Move"].ReadValue<Vector2>();
        }

        public static bool GetButton(PlayerInput input, string actionName)
        {
            var action = input.actions[actionName];
            return action.WasPressedThisFrame() && action.ReadValue<float>() == 1;
        }

        public static Vector2 GetPosition(PlayerInput input)
        {
            return input.actions["Position"].ReadValue<Vector2>();
        }

        public static bool GetPress(PlayerInput input)
        {
            return input.actions["Press"].WasPressedThisFrame();
        }

        public static bool GetRelease(PlayerInput input)
        {
            return input.actions["Press"].WasReleasedThisFrame();
        }
    }
}
#endif