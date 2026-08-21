using UnityEngine;
using TMPro;

public class GameplayUIManager : MonoBehaviour
{
    [Header("UI References")]
    public TextMeshProUGUI clockText;
    public TextMeshProUGUI objectiveText;

    [Header("Time Settings")]
    public float timeSpeed = 10f;
    private float timeElapsed = 0f;
    private int startHour = 8;

    void Update()
    {
        UpdateClock();
        UpdateObjectives();
    }

    void UpdateClock()
    {
        if (clockText == null) return;

        // FIXED: Now time passes as long as the player IS NOT talking
        bool isTalking = DialogueManager.Instance != null && DialogueManager.Instance.isDialogueActive;

        if (!isTalking)
        {
            timeElapsed += Time.deltaTime * timeSpeed;
        }

        int minutes = Mathf.FloorToInt(timeElapsed % 60);
        int hours = startHour + Mathf.FloorToInt(timeElapsed / 60);

        string amPm = hours >= 12 ? "PM" : "AM";
        int displayHour = hours > 12 ? hours - 12 : hours;
        if (displayHour == 0) displayHour = 12;

        clockText.text = $"{displayHour:00}:{minutes:00} {amPm}";
    }

    void UpdateObjectives()
    {
        if (objectiveText == null) return;

        // If we don't have a GameManager yet, just default to 0
        int diagnosed = GameManager.Instance != null ? GameManager.Instance.patientsDiagnosed : 0;

        string b1 = diagnosed >= 1 ? "<s>[X] Consult Bed 1</s>" : "[ ] Consult Bed 1";
        string b2 = diagnosed >= 2 ? "<s>[X] Consult Bed 2</s>" : "[ ] Consult Bed 2";
        string b3 = diagnosed >= 3 ? "<s>[X] Consult Bed 3</s>" : "[ ] Consult Bed 3";

        objectiveText.text = $"<b>To-Do List:</b>\n{b1}\n{b2}\n{b3}";
    }
}