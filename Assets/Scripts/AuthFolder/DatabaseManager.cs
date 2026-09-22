using Firebase.Firestore;
using Firebase.Extensions;
using System.Collections.Generic;
using UnityEngine;
using Firebase.Auth;

public class DatabaseManager : MonoBehaviour
{
    public void SaveTestScore()
    {
        // 1. Verify a user is currently logged in
        FirebaseUser currentUser = FirebaseAuth.DefaultInstance.CurrentUser;
        if (currentUser == null)
        {
            Debug.LogError("No user logged in! Please login first.");
            return;
        }

        // 2. Get the Firestore database instance
        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;

        // 3. Package the clinical score data into a dictionary
        Dictionary<string, object> scoreData = new Dictionary<string, object>
        {
            { "ClinicalReasoning", 85 },
            { "Empathy", 92 },
            { "LastShiftDate", FieldValue.ServerTimestamp }
        };

        // 4. Send to Firestore under a "Users" collection, using their specific User ID
        db.Collection("Users").Document(currentUser.UserId).SetAsync(scoreData).ContinueWithOnMainThread(task => {
            if (task.IsFaulted)
            {
                Debug.LogError("Failed to save scores: " + task.Exception);
            }
            else if (task.IsCompleted)
            {
                Debug.Log("Successfully saved test scores to the cloud!");
            }
        });
    }
}