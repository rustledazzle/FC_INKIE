using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;
using TMPro;
using Ink.Runtime;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance { get; private set; }

    [Header("UI Panels")]
    [SerializeField] private GameObject dialoguePanel;

    [Header("Case File UI")]
    [SerializeField] private GameObject caseFilePanel;
    [SerializeField] private TextMeshProUGUI caseFileBodyText;

    [Header("UI Text Components")]
    [SerializeField] private TextMeshProUGUI dialogueText;
    [SerializeField] private TextMeshProUGUI speakerNameText;

    [Header("UI Portrait Components")]
    [SerializeField] private Image leftPortraitImage;
    [SerializeField] private Image rightPortraitImage;
    [SerializeField] private List<Sprite> portraitSprites;

    [Header("Choice Mechanics")]
    [SerializeField] private Transform choiceButtonContainer;
    [SerializeField] private GameObject choiceButtonPrefab;

    [Header("Optional UI Prompts & Panels")]
    [SerializeField] private GameObject continuePrompt;
    [SerializeField] private GameObject feedbackSummaryPanel;
    [SerializeField] private TextMeshProUGUI totalScoreText;
    [SerializeField] private TextMeshProUGUI gradeText;

    private Story currentStory;
    private Dictionary<string, Sprite> portraitDictionary;

    public bool isDialogueActive { get; private set; } = false;
    private bool isWaitingForChoice = false;

    private void Awake()
    {
        if (Instance != null) Debug.LogWarning("Found more than one Dialogue Manager in the scene");
        Instance = this;

        portraitDictionary = new Dictionary<string, Sprite>();
        if (portraitSprites != null)
        {
            foreach (Sprite sprite in portraitSprites)
            {
                if (sprite != null && !portraitDictionary.ContainsKey(sprite.name.ToLower()))
                {
                    portraitDictionary.Add(sprite.name.ToLower(), sprite);
                }
            }
        }
    }

    void Start()
    {
        isDialogueActive = false;
        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false);
    }

    void Update()
    {
        if (!isDialogueActive) return;

        // Don't advance dialogue if the case file is currently open
        if (caseFilePanel != null && caseFilePanel.activeInHierarchy) return;

        if (!isWaitingForChoice && currentStory != null)
        {
            bool spacePressed = Keyboard.current != null && Keyboard.current.spaceKey.wasPressedThisFrame;
            bool enterPressed = Keyboard.current != null && (Keyboard.current.enterKey.wasPressedThisFrame || Keyboard.current.numpadEnterKey.wasPressedThisFrame);
            bool mouseClicked = Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame;

            if (spacePressed || enterPressed || mouseClicked)
            {
                OnContinueClicked();
            }
        }
    }

    // Updated to receive the unique patient notes from the NPC!
    public void EnterDialogueMode(TextAsset inkAsset, string patientNotes)
    {
        currentStory = new Story(inkAsset.text);
        isDialogueActive = true;

        if (dialoguePanel != null) dialoguePanel.SetActive(true);
        if (caseFileBodyText != null) caseFileBodyText.text = patientNotes; // Load the notes

        ContinueStory();
    }

    private void ExitDialogueMode()
    {
        isDialogueActive = false;
        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false); // Close case file if left open
        if (dialogueText != null) dialogueText.text = "";
        if (speakerNameText != null) speakerNameText.text = "";
        UpdatePortrait(leftPortraitImage, "clear");
        UpdatePortrait(rightPortraitImage, "clear");
    }

    // --- NEW CASE FILE FUNCTIONS ---
    public void OpenCaseFile()
    {
        if (caseFilePanel != null) caseFilePanel.SetActive(true);
    }

    public void CloseCaseFile()
    {
        if (caseFilePanel != null) caseFilePanel.SetActive(false);
    }
    // -------------------------------

    public void OnContinueClicked()
    {
        if (!isWaitingForChoice) ContinueStory();
    }

    public void ContinueStory()
    {
        if (currentStory == null) return;

        if (currentStory.canContinue)
        {
            if (dialogueText != null) dialogueText.text = currentStory.Continue();
            HandleTags(currentStory.currentTags);

            if (currentStory.currentChoices.Count > 0)
            {
                DisplayChoices();
            }
            else
            {
                ClearChoices();
                SetWaitingForChoice(false);
            }
        }
        else if (currentStory.currentChoices.Count > 0)
        {
            DisplayChoices();
        }
        else
        {
            ClearChoices();
            SetWaitingForChoice(false);
            EvaluateAndPushScores();
            ExitDialogueMode();
        }
    }

    private void HandleTags(List<string> currentTags)
    {
        if (currentTags == null) return;

        foreach (string tag in currentTags)
        {
            string[] splitTag = tag.Split(':');
            if (splitTag.Length != 2) continue;

            string key = splitTag[0].Trim().ToLower();
            string value = splitTag[1].Trim().ToLower();

            switch (key)
            {
                case "speaker":
                    if (speakerNameText != null) speakerNameText.text = splitTag[1].Trim();
                    break;
                case "portrait_left":
                    UpdatePortrait(leftPortraitImage, value);
                    break;
                case "portrait_right":
                    UpdatePortrait(rightPortraitImage, value);
                    break;
            }
        }
    }

    private void UpdatePortrait(Image portraitSlot, string spriteName)
    {
        if (portraitSlot == null) return;
        if (spriteName == "clear" || spriteName == "none")
        {
            portraitSlot.gameObject.SetActive(false);
            return;
        }
        if (portraitDictionary.ContainsKey(spriteName))
        {
            portraitSlot.sprite = portraitDictionary[spriteName];
            portraitSlot.gameObject.SetActive(true);
        }
    }

    private void DisplayChoices()
    {
        ClearChoices();
        SetWaitingForChoice(true);

        foreach (Choice choice in currentStory.currentChoices)
        {
            GameObject buttonObj = Instantiate(choiceButtonPrefab, choiceButtonContainer);
            TextMeshProUGUI btnText = buttonObj.GetComponentInChildren<TextMeshProUGUI>();
            if (btnText != null) btnText.text = choice.text;

            int choiceIndex = choice.index;
            buttonObj.GetComponent<Button>().onClick.AddListener(() => OnChoiceSelected(choiceIndex));
        }
    }

    private void OnChoiceSelected(int choiceIndex)
    {
        currentStory.ChooseChoiceIndex(choiceIndex);
        SetWaitingForChoice(false);
        ContinueStory();
    }

    private void ClearChoices()
    {
        if (choiceButtonContainer == null) return;
        foreach (Transform child in choiceButtonContainer) Destroy(child.gameObject);
    }

    private void SetWaitingForChoice(bool state)
    {
        isWaitingForChoice = state;
        if (continuePrompt != null) continuePrompt.SetActive(!state && currentStory.canContinue);
    }

    private void EvaluateAndPushScores()
    {
        int clinical = GetInkVariableInt("clinical_score");
        int info = GetInkVariableInt("info_score");
        int empathy = GetInkVariableInt("empathy_score");
        int safety = GetInkVariableInt("safety_score");
        string trust = GetInkVariableString("trust_level");

        if (GameManager.Instance != null) GameManager.Instance.UpdateMetrics(clinical, info, empathy, safety, trust);
        ShowEndScenarioScreen();
    }

    private int GetInkVariableInt(string varName)
    {
        if (currentStory != null && currentStory.variablesState[varName] != null)
        {
            return System.Convert.ToInt32(currentStory.variablesState[varName]);
        }
        return 0;
    }

    private string GetInkVariableString(string varName)
    {
        if (currentStory != null && currentStory.variablesState[varName] != null)
        {
            return currentStory.variablesState[varName].ToString();
        }
        return "NEUTRAL";
    }

    private void ShowEndScenarioScreen()
    {
        if (feedbackSummaryPanel != null)
        {
            int totalScore = 0;
            if (GameManager.Instance != null)
            {
                totalScore = GameManager.Instance.clinicalReasoningScore +
                             GameManager.Instance.informationGatheringScore +
                             GameManager.Instance.empathyTrustScore +
                             GameManager.Instance.patientSafetyScore;
            }

            if (totalScoreText != null) totalScoreText.text = $"FINAL SCORE: {totalScore} / 20";
            if (gradeText != null) gradeText.text = $"GRADE: {GetGradeScale(totalScore)}";

            feedbackSummaryPanel.SetActive(true);
        }
    }

    private string GetGradeScale(int score)
    {
        if (score >= 18) return "Exemplary";
        if (score >= 15) return "Proficient";
        if (score >= 12) return "Developing";
        if (score >= 9) return "Beginning";
        return "Unsatisfactory";
    }
}