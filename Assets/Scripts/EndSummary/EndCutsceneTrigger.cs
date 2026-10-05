using UnityEngine;
using UnityEngine.UI;

public class EndCutsceneTrigger : MonoBehaviour
{
    [Header("Ink Stories")]
    public TextAsset passedStory;
    public TextAsset failedStory;

    [Header("Passing Threshold")]
    [Tooltip("0.60 equals a 60% passing grade")]
    public float passingPercentage = 0.60f;

    [Header("UI to Hide")]
    [Tooltip("Drag your End Summary UI Panel (or Canvas) here to hide it during the cutscene.")]
    public GameObject summaryUIToHide;

    public void PlayCutscene()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        // 1. Get the final percentage saved by EndSummaryManager
        float finalScore = PlayerPrefs.GetFloat("FinalCampaignPercentage", 0f);

        // 2. Decide which story to play based on the threshold
        TextAsset storyToPlay = finalScore >= passingPercentage ? passedStory : failedStory;

        // 3. Trigger the existing Dialogue Manager
        if (DialogueManager.Instance != null && storyToPlay != null)
        {
            DialogueManager.Instance.EnterDialogueMode(storyToPlay, "FINAL EVALUATION");

            // 4. Safely hide the summary UI screen so the dialogue box is clearly visible
            if (summaryUIToHide != null)
            {
                summaryUIToHide.SetActive(false);
            }
        }
        else
        {
            Debug.LogError("DialogueManager Instance not found, or Ink stories are missing!");
        }
    }
}