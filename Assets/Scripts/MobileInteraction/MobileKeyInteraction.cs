using UnityEngine;
using UnityEngine.InputSystem;

public class MobileEKeySimulator : MonoBehaviour
{
    // Drag your mobile [E] UI Button here or attach this script directly to it
    public void TriggerMobileE()
    {
        // This forces Unity to simulate a press of the 'E' key on the current keyboard device
        if (Keyboard.current != null)
        {
            // Note: Since we can't force-press a physical keyboard key programmatically in the New Input System easily,
            // the cleanest workaround is to invoke whatever method your game uses when E is pressed, 
            // OR use InputSimulator. But even simpler: let's fire a custom event or call your player interaction check.
        }

        Debug.Log("Mobile E Button Tapped!");
    }
}