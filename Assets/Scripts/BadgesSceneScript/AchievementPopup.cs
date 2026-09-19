using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class AchievementPopup : MonoBehaviour
{
    [Header("UI Elements")]
    public CanvasGroup canvasGroup;
    public Image badgeIcon;
    public TextMeshProUGUI titleText;
    public TextMeshProUGUI descriptionText;

    [Header("Animation Settings")]
    public float displayTime = 3f;  // How many seconds it stays fully visible
    public float fadeInTime = 0.5f; // Seconds it takes to appear
    public float fadeOutTime = 1f;  // Seconds it takes to disappear

    public void SetupAndShow(string title, string desc, Sprite icon)
    {
        if (titleText) titleText.text = title;
        if (descriptionText) descriptionText.text = desc;
        if (badgeIcon && icon != null) badgeIcon.sprite = icon;

        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        StartCoroutine(FadeRoutine());
    }

    private IEnumerator FadeRoutine()
    {
        // 1. Start completely invisible
        canvasGroup.alpha = 0f;

        // 2. Fade IN smoothly using fadeInTime
        float inTimer = 0f;
        while (inTimer < fadeInTime)
        {
            inTimer += Time.deltaTime;
            canvasGroup.alpha = Mathf.Lerp(0f, 1f, inTimer / fadeInTime);
            yield return null;
        }
        canvasGroup.alpha = 1f;

        // 3. Wait on screen
        yield return new WaitForSeconds(displayTime);

        // 4. Fade OUT smoothly using fadeOutTime
        float outTimer = 0f;
        while (outTimer < fadeOutTime)
        {
            outTimer += Time.deltaTime;
            canvasGroup.alpha = Mathf.Lerp(1f, 0f, outTimer / fadeOutTime);
            yield return null;
        }
        canvasGroup.alpha = 0f;

        // 5. Remove it from the game
        Destroy(gameObject);
    }
}