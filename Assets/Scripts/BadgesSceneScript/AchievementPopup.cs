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

    [Header("Badge Audio")]
    public AudioSource badgeAudioSource;
    public AudioClip badgeUnlockClip;
    [Range(0f, 1f)] public float badgeVolume = 0.5f;

    public void SetupAndShow(string title, string desc, Sprite icon)
    {
        if (titleText) titleText.text = title;
        if (descriptionText) descriptionText.text = desc;
        if (badgeIcon && icon != null) badgeIcon.sprite = icon;

        PlayBadgeSound();

        StartCoroutine(FadeRoutine());
    }

    private void PlayBadgeSound()
    {
        // Get the current SFX slider volume (works even if testing a scene directly)
        float globalSFX = (AudioManager.Instance != null && AudioManager.Instance.sfxSource != null)
            ? AudioManager.Instance.sfxSource.volume
            : PlayerPrefs.GetFloat("SFXVolume", 1f);

        if (badgeUnlockClip != null)
        {
            // Automatically grab the AudioSource on the prefab if not manually dragged in
            if (badgeAudioSource == null) badgeAudioSource = GetComponent<AudioSource>();

            if (badgeAudioSource != null)
            {
                badgeAudioSource.PlayOneShot(badgeUnlockClip, badgeVolume * globalSFX);
            }
            else if (AudioManager.Instance != null && AudioManager.Instance.sfxSource != null)
            {
                // Plays through AudioManager if no AudioSource is attached to the prefab
                AudioManager.Instance.sfxSource.PlayOneShot(badgeUnlockClip, badgeVolume);
            }
        }
        else if (AudioManager.Instance != null)
        {
            // Fallback to button click if no badge sound clip is assigned
            AudioManager.Instance.PlayClick();
        }
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