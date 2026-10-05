using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [Header("Audio Sources")]
    public AudioSource bgmSource;
    public AudioSource sfxSource;

    [Header("Audio Clips & Base Volumes")]
    public AudioClip buttonClickSound;
    public AudioClip defaultMenuBGM; // Plays in Menu, Options, Library, Stage Select, etc.
    [Range(0f, 1f)] public float bgmBaseVolume = 0.08f; // Caps max BGM loudness in Inspector
    [Range(0f, 1f)] public float sfxBaseVolume = 0.35f; // Caps max SFX/Click loudness in Inspector
    [Range(0f, 1f)] public float dialogueDuckingMultiplier = 0.25f; // NEW: 0 = Mute BGM in dialogue, 0.25 = 25% volume
    public float bgmFadeInDuration = 2.0f; // Gently fades music in over 2 seconds

    [System.Serializable]
    public class SceneMusic
    {
        public string sceneName; // Exact name of your scene (e.g., "Stage1_Morning")
        public AudioClip musicClip;
        [Range(0f, 1f)] public float trackVolume = 1f;
    }

    [Header("Custom Stage / Scene BGM")]
    public List<SceneMusic> customSceneMusic = new List<SceneMusic>();

    private float currentSliderMusicVolume = 1f;
    private float currentSliderSFXVolume = 1f;
    private float currentTrackMultiplier = 1f;
    private Coroutine fadeCoroutine;
    private bool isDialogueDucking = false;

    private void Awake()
    {
        if (Instance != null)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject);

        // Immediately silence bgmSource on frame 0 so it never blasts before fading in
        if (bgmSource != null)
        {
            if (defaultMenuBGM == null) defaultMenuBGM = bgmSource.clip;
            bgmSource.volume = 0f;
        }

        // Load all saved player slider volumes
        float savedMasterVolume = PlayerPrefs.GetFloat("MasterVolume", 1f);
        float savedMusicVolume = PlayerPrefs.GetFloat("MusicVolume", 1f);
        float savedSFXVolume = PlayerPrefs.GetFloat("SFXVolume", 1f);

        SetMasterVolume(savedMasterVolume);
        currentSliderMusicVolume = savedMusicVolume;
        SetSFXVolume(savedSFXVolume);
    }

    // Allows you to drag Base Volume & Ducking sliders in the Inspector during Play Mode and test them live!
    private void OnValidate()
    {
        if (Application.isPlaying)
        {
            if (bgmSource != null && fadeCoroutine == null)
            {
                ApplyFinalBGMVolume();
            }
            if (sfxSource != null)
            {
                ApplyFinalSFXVolume();
            }
        }
    }

    private void OnEnable()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        // Always reset dialogue ducking when switching scenes
        isDialogueDucking = false;

        // 1. Check if the newly loaded scene has a unique BGM in our list
        foreach (SceneMusic item in customSceneMusic)
        {
            if (item.sceneName == scene.name && item.musicClip != null)
            {
                currentTrackMultiplier = item.trackVolume;
                PlayBGM(item.musicClip);
                return;
            }
        }

        // 2. Otherwise, play the default Menu BGM
        if (defaultMenuBGM != null)
        {
            currentTrackMultiplier = 1f;
            PlayBGM(defaultMenuBGM);
        }
    }

    public void PlayBGM(AudioClip newClip)
    {
        if (bgmSource == null || newClip == null) return;

        // If this exact song is already playing, just make sure its volume is right and don't restart it!
        if (bgmSource.clip == newClip && bgmSource.isPlaying)
        {
            ApplyFinalBGMVolume();
            return;
        }

        bgmSource.clip = newClip;
        bgmSource.loop = true;
        bgmSource.volume = 0f; // Start silent
        bgmSource.Play();

        // Gently fade in to the target volume
        if (fadeCoroutine != null) StopCoroutine(fadeCoroutine);
        fadeCoroutine = StartCoroutine(FadeInBGM());
    }

    private IEnumerator FadeInBGM()
    {
        float targetVolume = GetTargetBGMVolume();
        float timer = 0f;

        while (timer < bgmFadeInDuration)
        {
            timer += Time.unscaledDeltaTime;
            targetVolume = GetTargetBGMVolume();
            if (bgmSource != null)
            {
                bgmSource.volume = Mathf.Lerp(0f, targetVolume, timer / bgmFadeInDuration);
            }
            yield return null;
        }

        ApplyFinalBGMVolume();
        fadeCoroutine = null;
    }

    private float GetTargetBGMVolume()
    {
        float baseTarget = currentSliderMusicVolume * bgmBaseVolume * currentTrackMultiplier;
        return isDialogueDucking ? baseTarget * dialogueDuckingMultiplier : baseTarget;
    }

    // --- Dialogue Audio Ducking / Mute Control ---
    public void SetDialogueDucking(bool duckingActive)
    {
        isDialogueDucking = duckingActive;

        if (fadeCoroutine == null)
        {
            ApplyFinalBGMVolume();
        }
    }

    // --- Master Volume (Controls the global output) ---
    public void SetMasterVolume(float volume)
    {
        AudioListener.volume = volume;
        PlayerPrefs.SetFloat("MasterVolume", volume);
        PlayerPrefs.Save();
    }

    // --- Independent Volume Controls ---
    public void SetMusicVolume(float sliderVolume)
    {
        currentSliderMusicVolume = sliderVolume;
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
            fadeCoroutine = null;
        }
        ApplyFinalBGMVolume();
        PlayerPrefs.SetFloat("MusicVolume", sliderVolume);
        PlayerPrefs.Save();
    }

    private void ApplyFinalBGMVolume()
    {
        if (bgmSource != null)
        {
            bgmSource.volume = GetTargetBGMVolume();
        }
    }

    public void SetSFXVolume(float sliderVolume)
    {
        currentSliderSFXVolume = sliderVolume;
        ApplyFinalSFXVolume();
        PlayerPrefs.SetFloat("SFXVolume", sliderVolume);
        PlayerPrefs.Save();
    }

    private void ApplyFinalSFXVolume()
    {
        if (sfxSource != null)
        {
            // Multiplies the player's SFX Slider by your Inspector SFX Base Volume!
            sfxSource.volume = currentSliderSFXVolume * sfxBaseVolume;
        }
    }

    public void PlaySFX(AudioClip clip)
    {
        if (sfxSource != null && clip != null) sfxSource.PlayOneShot(clip);
    }

    public void PlayClick()
    {
        if (sfxSource != null && buttonClickSound != null) sfxSource.PlayOneShot(buttonClickSound);
    }
}