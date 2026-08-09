using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [Header("Audio Sources")]
    public AudioSource bgmSource; // For Background Music
    public AudioSource sfxSource; // For Sound Effects like button clicks

    private void Awake()
    {
        // If an AudioManager already exists, destroy this duplicate
        if (Instance != null)
        {
            Destroy(gameObject);
            return;
        }

        // Make this the official AudioManager and keep it alive across all scenes
        Instance = this;
        DontDestroyOnLoad(gameObject);

        // Load the saved volume (or default to 1.0 which is 100%)
        float savedVolume = PlayerPrefs.GetFloat("MasterVolume", 1f);
        SetVolume(savedVolume);
    }

    // This scales the global volume of the entire game
    public void SetVolume(float volume)
    {
        AudioListener.volume = volume;
        PlayerPrefs.SetFloat("MasterVolume", volume); // Save it to the device!
        PlayerPrefs.Save();
    }

    public void PlaySFX(AudioClip clip)
    {
        if (sfxSource != null && clip != null)
        {
            sfxSource.PlayOneShot(clip);
        }
    }
}