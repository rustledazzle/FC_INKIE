using UnityEngine;
using TMPro;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions; // Required for running on the main thread
using UnityEngine.SceneManagement;

public class MainMenuManager : MonoBehaviour
{
    [Header("UI References")]
    public TMP_Text welcomeText;
    public TMP_Text statsText;

    void Start()
    {
        // When the menu loads, immediately fetch the user's data
        FetchPlayerData();
    }

    public void FetchPlayerData()
    {
        FirebaseUser currentUser = FirebaseAuth.DefaultInstance.CurrentUser;

        if (currentUser == null)
        {
            Debug.LogWarning("No user logged in, returning to login screen.");
            SceneManager.LoadScene("LoginScene");
            return;
        }

        // Display the user's email
        welcomeText.text = "Logged in as: " + currentUser.Email;
        statsText.text = "Loading past shift data...";

        // Fetch their specific document from Firestore
        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        DocumentReference docRef = db.Collection("Users").Document(currentUser.UserId);

        docRef.GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsFaulted)
            {
                Debug.LogError("Error fetching data: " + task.Exception);
                statsText.text = "Failed to load cloud data.";
                return;
            }

            DocumentSnapshot snapshot = task.Result;

            // Check if they have saved data before
            if (snapshot.Exists)
            {
                // Extract the variables using the exact same text keys we used when saving
                int clinicalScore = snapshot.GetValue<int>("ClinicalReasoning");
                int empathyScore = snapshot.GetValue<int>("Empathy");

                statsText.text = $"Last Clinical Score: {clinicalScore}\nLast Empathy Score: {empathyScore}";
            }
            else
            {
                statsText.text = "Welcome to your first shift! No past records found.";
            }
        });
    }

    public void SignOut()
    {
        FirebaseAuth.DefaultInstance.SignOut();
        SceneManager.LoadScene("LoginScene");
    }
}