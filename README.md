# First Contact: A Family Medicine Simulation Game for Enhancing Primary Care Training

**First Contact** is a hybrid 2D top-down exploration and visual novel simulation game designed to gamify and enhance primary care training for medical residents. 

## Core Features
* **Dynamic Clinical Narrative:** Branching patient dialogue driven by the Ink narrative engine, directly reflecting the player's diagnostic choices and bedside manner.
* **Rubric-Based Scoring:** Real-time tracking of player performance across four key dimensions: Clinical Reasoning, Information Gathering, Empathy, and Safety.
* **Interactive 2D Clinic:** Physics-based world exploration utilizing Unity's New Input System and Cinemachine camera tracking.
* **Medical Archive (Library Scene):** An offline-first, dynamic database of medical cases and visual diagrams that unlocks as players progress through shifts.
* **Shift Progression System:** Evaluates the player's cumulative score at the end of each shift, awarding a star rating based on clinical performance.

## Technology Stack
* **Game Engine:** Unity (UI Canvas, Cinemachine, New Input System)
* **Narrative Engine:** Inkle (Ink)
* **Backend Services:** Firebase (Firestore Database, Authentication)

---

## Local Setup & Installation Instructions

### 1. Clone the Repository
Clone this repository to your local machine using Git and open the project in your installed version of Unity.

### 2. Install Firebase Unity SDK (Required)
Because Firebase's native plugin files (like `FirebaseCppApp.bundle`) exceed GitHub's 100MB file limit, the SDK is not included in this repository. You must import it manually:
1. Download the [Firebase Unity SDK](https://firebase.google.com/download/unity) from the official Google developer site.
2. Extract the downloaded `.zip` file.
3. In the Unity Editor, go to **Assets > Import Package > Custom Package**.
4. Navigate to your extracted folder and import the packages used in this project (specifically `FirebaseAuth.unitypackage` and `FirebaseFirestore.unitypackage`). 
5. Click **Import** and allow Unity to resolve dependencies and auto-generate the necessary plugin bundles in your local folder.

### 3. Firebase Credentials (Crucial)
For security purposes, the database credentials have been hidden from GitHub. The game will not connect to the database without them.
1. Obtain the `google-services.json` file from the project lead or group administrator.
2. Drag and drop the `google-services.json` file directly into your local Unity `Assets/` folder. *(Note: Do not commit this file; it is safely ignored via our `.gitignore`).*

### 4. Launching the Game
1. In Unity, navigate to your Scenes folder.
2. Open the **Menu Scene** (the starting point for the application).
3. Press **Play** in the Unity Editor to begin testing.
