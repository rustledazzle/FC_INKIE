using UnityEngine;
using UnityEngine.InputSystem;

public static class GameInput
{
    private static bool mobileETriggered = false;

    // Call this from your mobile UI button OnClick()
    public static void PressInteractButton()
    {
        mobileETriggered = true;
    }

    // Replace your Keyboard check with this single helper function anywhere in your game!
    public static bool IsInteractPressed()
    {
        bool keyboardE = (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame);

        if (mobileETriggered)
        {
            mobileETriggered = false; // Reset it immediately after reading
            return true;
        }

        return keyboardE;
    }
}