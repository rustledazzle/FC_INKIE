using UnityEngine;

public class AdminBadgeTester : MonoBehaviour
{
    [Header("Badge Keys")]
    public string[] badgeKeys = new string[]
    {
        "Badge_Tutorial",
        "Badge_ChiefResident",
        "Badge_PerfectStage1",
        "Badge_NoCaseFile",
        "Badge_PerfectEmpathy",
        "Badge_PerfectSafety",
        "Badge_SpecialCases",
        "Badge_OutstandingGrade"
    };

    [Header("UI Reference")]
    public BadgesManager badgeManager;

    private bool areBadgesUnlocked = false;

    // Fixed: Made this public so a UI Button can click it!
    public void ToggleAllBadges()
    {
        areBadgesUnlocked = !areBadgesUnlocked;
        int statusValue = areBadgesUnlocked ? 1 : 0;

        // Apply the lock/unlock state to the specific badge keys only
        foreach (string key in badgeKeys)
        {
            PlayerPrefs.SetInt(key, statusValue);
        }

        PlayerPrefs.Save();

        // Instantly update the visuals on screen
        if (badgeManager != null)
        {
            badgeManager.RefreshBadges();
        }

        Debug.Log($"Admin: All badges set to {(areBadgesUnlocked ? "UNLOCKED" : "LOCKED")}");
    }
}