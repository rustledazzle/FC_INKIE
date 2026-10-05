#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

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
    [CustomEditor(typeof(Joystick), true)]
    public class JoystickEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            SerializedProperty background = serializedObject.FindProperty("background");
            SerializedProperty handle = serializedObject.FindProperty("handle");

            DrawPropertiesExcluding(serializedObject, "background", "handle");

            GUI.enabled = background.objectReferenceValue == null;
            EditorGUILayout.PropertyField(background);

            GUI.enabled = handle.objectReferenceValue == null;
            EditorGUILayout.PropertyField(handle);
            GUI.enabled = true;

            serializedObject.ApplyModifiedProperties();
        }
    }
}
#endif