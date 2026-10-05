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
    public class DynamicJoystick : Joystick
    {
        public override void OnPointerUp(PointerEventData eventData)
        {
            base.OnPointerUp(eventData);
            handle.anchoredPosition = Vector2.zero;
        }

        public override void OnDrag(PointerEventData eventData)
        {
            base.OnDrag(eventData);

            Vector2 position = RectTransformUtility.WorldToScreenPoint(cam, background.position);
            Vector2 moveDirection = eventData.position - position;
            float maxRadius = background.sizeDelta.x * 0.5f;

            if (moveDirection.magnitude > maxRadius) moveDirection = moveDirection.normalized * maxRadius;

            handle.anchoredPosition = moveDirection;
        }
    }
}
