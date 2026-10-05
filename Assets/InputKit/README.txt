Introduction:

Input Kit is a versatile input management system designed to simplify the input handling process for Unity developers. It abstracts input from multiple devices such as desktop, console, mobile, and web, enabling seamless cross-platform compatibility. Whether you’re working with 2D or 3D games, Input Kit ensures a consistent experience across platforms, letting you focus on gameplay instead of input management.

---

Warning:
To use Unity's new input system with this asset, please follow the setup instructions at the link below:

https://docs.unity3d.com/Packages/com.unity.inputsystem@1.14/manual/index.html

Installation:

1. Go to Window > Package Manager in the Unity editor.
2. Open the Package Manager window.
3. Select My Assets from the Packages menu to view the packages you've purchased.
4. Find and select Input Kit from the list (use the search function if necessary).
5. Follow the prompts to complete the installation.

---

Getting Started:

Once the package is installed, you can access the Input Kit in Unity under the Assets folder.

1. Navigate to Input Kit > Prefabs > InputManager.
2. Drag and drop the InputManager prefab into your scene hierarchy.

---

How to Use:

Input Manager Prefab:

1. Input System: Choose whether you want to use the New Input System or the Legacy Input System.
2. Main Camera: Ensure the Main Camera is present in your scene, as it’s needed for raycasting.
3. Graphic Raycaster: If you want to detect touch or mouse clicks on UI elements, drag and drop your Canvas with a Graphic Raycaster into the designated field.
4. Joystick Prefab: If you are using joystick controls, drag and drop the joystick prefab of your choice into the appropriate field.
5. Mobile UI Buttons: For mobile games, drag and drop the buttons you want to use into the designated fields here.

Joysticks:

Input Kit provides four types of joysticks:
Fixed, Dynamic, Floating, Variable

Find them in Assets > InputKit > Prefabs > Joysticks. Drag and drop the joystick of your choice into your Canvas in the hierarchy.

Joystick Prefab Configuration:

1. Axis Selection: Select which axis (horizontal, vertical, or both) the joystick should respond to.
2. Snapping: Enable snapping to restrict movement to four or eight directions.
3. Movement Range: Control how far the joystick handle can move.
4. Smoothness: Adjust how fluidly the joystick input translates into movement.
