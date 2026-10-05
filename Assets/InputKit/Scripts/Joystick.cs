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
    public class Joystick : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
    {
        [Header("Joystick Settings")]
        [Tooltip("Defines the axis of movement for the joystick.")]
        [SerializeField] private Axis axis = Axis.Both;

        [Tooltip("Enables snapping of the joystick to predefined angles.")]
        [SerializeField] private Snap snapping = Snap.None;

        [Tooltip("Determines how far the handle can move relative to the background.")]
        [SerializeField][Range(0.1f, 1.0f)] private float flexibility = 1f;

        [Tooltip("Controls the smoothness of the joystick's movement.")]
        [SerializeField][Range(0.0f, 1.0f)] private float smoothness = 0.5f;

        [Space(25)]
        [Tooltip("The background of the joystick.")]
        [SerializeField] protected RectTransform background = null;

        [Tooltip("The handle of the joystick.")]
        [SerializeField] protected RectTransform handle = null;

        [HideInInspector] public Vector2 Direction => snapping != Snap.None ? SnapVector(SmoothVector(input)) : SmoothVector(input);
        [HideInInspector] public float Flexibility { get => flexibility; set => flexibility = Mathf.Abs(value); }
        [HideInInspector] public Axis Axis { get => axis; set => axis = value; }
        [HideInInspector] public Snap Snapping { get => snapping; set => snapping = value; }
        [HideInInspector] public float Smoothness { get => smoothness; set => smoothness = value; }

        protected Canvas canvas;
        protected Camera cam;
        private Vector2 input = Vector2.zero;

        protected virtual void Start()
        {
            canvas = GetComponentInParent<Canvas>();
            if (canvas == null)
            {
                Debug.LogError("The Joystick is not placed inside a canvas");
                return;
            }

            ConfigureHandle();
        }

        private void ConfigureHandle()
        {
            Vector2 center = new Vector2(0.5f, 0.5f);
            background.pivot = center;
            handle.anchorMin = center;
            handle.anchorMax = center;
            handle.pivot = center;
            handle.anchoredPosition = Vector2.zero;
        }

        public virtual void OnPointerDown(PointerEventData eventData) => OnDrag(eventData);

        public virtual void OnDrag(PointerEventData eventData)
        {
            cam = canvas.renderMode == RenderMode.ScreenSpaceCamera ? canvas.worldCamera : null;

            Vector2 position = RectTransformUtility.WorldToScreenPoint(cam, background.position);
            Vector2 radius = background.sizeDelta / 2;

            input = (eventData.position - position) / (radius * canvas.scaleFactor);
            FormatInput();
            HandleInput(input.magnitude, input.normalized, radius);
            handle.anchoredPosition = input * radius * flexibility;
        }

        protected virtual void HandleInput(float magnitude, Vector2 normalized, Vector2 radius) => input = magnitude > 1f ? normalized : input;
        private void FormatInput()
        {
            if (axis == Axis.Horizontal)
                input.y = 0f;
            else if (axis == Axis.Vertical)
                input.x = 0f;
        }

        private Vector2 SnapVector(Vector2 value)
        {
            if (value == Vector2.zero) return value;

            float angle = Mathf.Atan2(value.y, value.x) * Mathf.Rad2Deg;
            if (angle < 0) angle += 360;

            float[] snapAngles;

            switch (snapping)
            {
                case Snap.Four:
                    snapAngles = new float[] { 0, 90, 180, 270 };
                    break;
                case Snap.Eight:
                    snapAngles = new float[] { 0, 45, 90, 135, 180, 225, 270, 315 };
                    break;
                default:
                    snapAngles = new float[] { angle };
                    break;
            }

            float closestAngle = snapAngles[0];
            float minDiff = Mathf.Abs(angle - closestAngle);

            for (int i = 1; i < snapAngles.Length; i++)
            {
                float diff = Mathf.Abs(angle - snapAngles[i]);
                if (diff < minDiff)
                {
                    minDiff = diff;
                    closestAngle = snapAngles[i];
                }
            }

            return AngleToVector2(closestAngle);
        }

        private Vector2 SmoothVector(Vector2 value)
        {
            if (value == Vector2.zero) return value;
            return Vector2.Lerp(value, snapping != Snap.None ? SnapVector(value) : value, 1 - smoothness);
        }

        private Vector2 AngleToVector2(float angle)
        {
            float rad = angle * Mathf.Deg2Rad;
            return new Vector2(Mathf.Cos(rad), Mathf.Sin(rad)).normalized;
        }

        public virtual void OnPointerUp(PointerEventData eventData)
        {
            input = Vector2.zero;
            handle.anchoredPosition = Vector2.zero;
        }
    }

    public enum Snap { None, Four, Eight }

    public enum Axis { Both, Vertical, Horizontal }
}