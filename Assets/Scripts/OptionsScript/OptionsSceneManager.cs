using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class OptionsManager : MonoBehaviour
{
    [Header("Volume Controls")]
    public Slider musicSlider;
    public Slider sfxSlider;
    public Slider masterSlider; // NEW: Controls everything

    [Header("Screen Controls")]
    public Button windowedButton;   // NEW: The "X" button
    public Button fullscreenButton; // NEW: The "Check" button

    [Header("Navigation")]
    public Button backButton;

    void Start()
    {
        // 1. Initialize Volumes
        if (musicSlider != null)
        {
            musicSlider.value = PlayerPrefs.GetFloat("MusicVolume", 1f);
            musicSlider.onValueChanged.AddListener(OnMusicVolumeChanged);
        }

        if (sfxSlider != null)
        {
            sfxSlider.value = PlayerPrefs.GetFloat("SFXVolume", 1f);
            sfxSlider.onValueChanged.AddListener(OnSFXVolumeChanged);
        }

        if (masterSlider != null)
        {
            masterSlider.value = PlayerPrefs.GetFloat("MasterVolume", 1f);
            masterSlider.onValueChanged.AddListener(OnMasterVolumeChanged);
        }

        // 2. Initialize Screen Buttons
        if (windowedButton != null)
        {
            windowedButton.onClick.AddListener(() => SetFullscreenMode(false));
        }

        if (fullscreenButton != null)
        {
            fullscreenButton.onClick.AddListener(() => SetFullscreenMode(true));
        }

        // 3. Initialize Back Button
        if (backButton != null)
        {
            backButton.onClick.AddListener(() => {
                if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
                SceneManager.LoadScene("MenuScene");
            });
        }
    }

    private void OnMusicVolumeChanged(float value)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.SetMusicVolume(value);
        PlayerPrefs.SetFloat("MusicVolume", value);
        PlayerPrefs.Save();
    }

    private void OnSFXVolumeChanged(float value)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.SetSFXVolume(value);
        PlayerPrefs.SetFloat("SFXVolume", value);
        PlayerPrefs.Save();
    }

    private void OnMasterVolumeChanged(float value)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.SetMasterVolume(value);
    }

    private void SetFullscreenMode(bool isFullscreen)
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (isFullscreen)
        {
            // Detects the player's monitor size and goes Fullscreen natively
            Resolution[] allRes = Screen.resolutions;
            Resolution maxRes = allRes[allRes.Length - 1];
            Screen.SetResolution(maxRes.width, maxRes.height, FullScreenMode.FullScreenWindow);
        }
        else
        {
            // Snaps to a clean, standard 16:9 Windowed mode
            Screen.SetResolution(1280, 720, FullScreenMode.Windowed);
        }
    }
}