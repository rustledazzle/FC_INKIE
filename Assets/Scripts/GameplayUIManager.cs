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
    public int startHour = 8;

    private int lastDiagnosedCount = 0;

    [Header("Objectives Settings")]
    [Tooltip("Type the names of your tasks here. The list size determines the number of patients!")]
    public string[] objectiveList;

    void Start()
    {
        // NEW: We force these back to 0 on load so the checklist always starts clean!
        timeElapsed = 0f;
        lastDiagnosedCount = 0;
    }

    void Update()
    {
        UpdateClock();
        UpdateObjectives();
    }

    void UpdateClock()
    {
        if (clockText == null) return;

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

        int diagnosed = GameManager.Instance != null ? GameManager.Instance.patientsDiagnosed : 0;

        if (diagnosed > lastDiagnosedCount)
        {
            timeElapsed += 30f;
            lastDiagnosedCount = diagnosed;
        }

        string finalObjectives = "<b>To-Do List:</b>\n";

        for (int i = 0; i < objectiveList.Length; i++)
        {
            if (diagnosed > i)
            {
                finalObjectives += $"<s>[X] {objectiveList[i]}</s>\n";
            }
            else
            {
                finalObjectives += $"[ ] {objectiveList[i]}\n";
            }
        }

        objectiveText.text = finalObjectives;
    }
}