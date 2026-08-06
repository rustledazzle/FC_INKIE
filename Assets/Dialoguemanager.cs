using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;
using TMPro;
using Ink.Runtime;

public class DialogueManager : MonoBehaviour
{
    [Header("Ink JSON Asset")]
    [SerializeField] private TextAsset inkJsonAsset;

    [Header("UI Text Components")]
    [SerializeField] private TextMeshProUGUI dialogueText;
    [SerializeField] private TextMeshProUGUI speakerNameText;

    [Header("UI Portrait Components")]
    [SerializeField] private Image leftPortraitImage;  // Slot for the Player
    [SerializeField] private Image rightPortraitImage; // Slot for the NPC
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
    private bool isWaitingForChoice = false;
    private Dictionary<string, Sprite> portraitDictionary;

    private void Awake()
    {
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
        if (inkJsonAsset != null)
        {
            StartStory();
        }
        else
        {
            Debug.LogError("DialogueManager: Missing Ink JSON Asset!");
        }
    }

    void Update()
    {
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

    public void StartStory()
    {
        currentStory = new Story(inkJsonAsset.text);
        ContinueStory();
    }

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

            // Parse Ink tags
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
            string value = splitTag[1].Trim().ToLower(); // Lowercase for sprite matching

            switch (key)
            {
                case "speaker":
                    // Use the original case for displaying the name (splitTag[1])
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

    // Helper method to change or hide portraits
    private void UpdatePortrait(Image portraitSlot, string spriteName)
    {
        if (portraitSlot == null) return;

        // Hide the portrait if the tag says "clear" or "none"
        if (spriteName == "clear" || spriteName == "none")
        {
            portraitSlot.gameObject.SetActive(false);
            return;
        }

        // Show the portrait if the sprite exists in our list
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