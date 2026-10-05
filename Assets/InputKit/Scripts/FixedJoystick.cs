using UnityEngine.EventSystems;
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
    public class FixedJoystick : Joystick
    {
        public override void OnPointerUp(PointerEventData eventData)
        {
            base.OnPointerUp(eventData);
            handle.anchoredPosition = Vector2.zero;
        }
    }
}
