using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class OptionsManager : MonoBehaviour
{
    [Header("UI Controls")]
    public Slider volumeSlider;
    public Button backButton;

    void Start()
    {
        if (volumeSlider != null)
        {
            volumeSlider.value = PlayerPrefs.GetFloat("MasterVolume", 1f);
            volumeSlider.onValueChanged.AddListener(OnVolumeChanged);
        }

        // UPDATED: Play the click sound, then load the Menu Scene
        if (backButton != null)
        {
            backButton.onClick.AddListener(() => {
                if (AudioManager.Instance != null)
                {
                    AudioManager.Instance.PlayClick();
                }
                SceneManager.LoadScene("MenuScene");
            });
        }
    }

    private void OnVolumeChanged(float value)
    {
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.SetVolume(value);
        }
    }
}