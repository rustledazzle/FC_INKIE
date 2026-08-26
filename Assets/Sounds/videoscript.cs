using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class PanelVideoBackground : MonoBehaviour
{
    public RawImage rawImage;        // UI element to show video
    public VideoPlayer videoPlayer;  // VideoPlayer component
    public RenderTexture renderTexture;

    void Start()
    {
        // Assign the RenderTexture to both VideoPlayer and RawImage
        videoPlayer.targetTexture = renderTexture;
        rawImage.texture = renderTexture;

        // Loop and play automatically
        videoPlayer.isLooping = true;
        videoPlayer.Play();
    }
}
