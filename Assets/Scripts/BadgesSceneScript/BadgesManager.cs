using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;

[System.Serializable]
public class BadgeUI
{
    [Tooltip("The exact PlayerPrefs key used to save this badge")]
    public string badgeKey;
    public string badgeTitle;

    [TextArea(2, 3)]
    public string unlockedDescription;
    [TextArea(2, 3)]
    public string lockedDescription = "???";

    [Header("UI Elements")]
    public Image badgeIcon;
    public TextMeshProUGUI titleText;
    public TextMeshProUGUI descriptionText;
}

public class BadgesManager : MonoBehaviour
{
    public Button backButton;
    public BadgeUI[] badges;

    void Start()
    {
        if (backButton != null)
        {
            backButton.onClick.AddListener(() =>
            {
                if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
                SceneManager.LoadScene("MenuScene");
            });
        }

        // 1. Immediately display current local state
        RefreshBadges();

        // 2. Verify with Firebase Cloud for the logged-in user and refresh UI
        SyncBadgesFromCloud();
    }

    private void SyncBadgesFromCloud()
    {
        if (FirebaseAuth.DefaultInstance == null) return;

        FirebaseUser currentUser = FirebaseAuth.DefaultInstance.CurrentUser;
        if (currentUser == null) return;

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        db.Collection("Users").Document(currentUser.UserId).GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsCompleted && !task.IsFaulted)
            {
                DocumentSnapshot snapshot = task.Result;
                if (snapshot.Exists && snapshot.ContainsField("Badges"))
                {
                    Dictionary<string, object> cloudBadges = snapshot.GetValue<Dictionary<string, object>>("Badges");

                    foreach (BadgeUI badge in badges)
                    {
                        if (string.IsNullOrEmpty(badge.badgeKey)) continue;
                        string cleanKey = badge.badgeKey.Trim();

                        if (cloudBadges.ContainsKey(cleanKey) && cloudBadges[cleanKey] is bool unlocked && unlocked)
                        {
                            PlayerPrefs.SetInt(cleanKey, 1);
                        }
                        else
                        {
                            PlayerPrefs.SetInt(cleanKey, 0);
                        }
                    }

                    PlayerPrefs.Save();
                    RefreshBadges();
                }
            }
        });
    }

    public void RefreshBadges()
    {
        foreach (BadgeUI badge in badges)
        {
            if (string.IsNullOrEmpty(badge.badgeKey)) continue;

            string cleanKey = badge.badgeKey.Trim();

            // Check if the badge is unlocked (1 = unlocked, 0 = locked)
            bool isUnlocked = PlayerPrefs.GetInt(cleanKey, 0) == 1;

            if (badge.titleText) badge.titleText.text = badge.badgeTitle;

            if (isUnlocked)
            {
                if (badge.badgeIcon) badge.badgeIcon.color = Color.white; // Full color
                if (badge.descriptionText) badge.descriptionText.text = badge.unlockedDescription;
            }
            else
            {
                if (badge.badgeIcon) badge.badgeIcon.color = new Color(0.2f, 0.2f, 0.2f, 1f); // Dark gray
                if (badge.descriptionText) badge.descriptionText.text = badge.lockedDescription;
            }
        }
    }
}