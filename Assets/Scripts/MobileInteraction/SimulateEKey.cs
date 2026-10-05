using UnityEngine;
using UnityEngine.InputSystem;

public class SimulateEKey : MonoBehaviour
{
    // A global flag that any script can check
    public static bool isMobileInteractPressed = false;

    // Hook this up to your mobile [E] button's OnClick() event
    public void SimulatePress()
    {
        NpcInteraction.TriggerActiveNPC();
        Debug.Log("Mobile E-Button Tapped!");
    }

    // Call this from your existing interaction checking script alongside your 'E' key check
    public static bool CheckInteractPressed()
    {
        bool keyboardE = (Keyboard.current != null && Keyboard.current.eKey.wasPressedThisFrame);

        if (isMobileInteractPressed)
        {
            isMobileInteractPressed = false; // Reset it immediately so it only triggers once per tap
            return true;
        }

        return keyboardE;
    }
}