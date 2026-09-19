using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

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
                // if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
                SceneManager.LoadScene("MainMenu");
            });
        }

        RefreshBadges();
    }

    public void RefreshBadges()
    {
        foreach (BadgeUI badge in badges)
        {
            // Check if the badge is unlocked (1 = unlocked, 0 = locked)
            bool isUnlocked = PlayerPrefs.GetInt(badge.badgeKey, 0) == 1;

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