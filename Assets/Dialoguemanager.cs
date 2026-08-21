using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;
using TMPro;
using Ink.Runtime;
using UnityEngine.EventSystems;

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
    [SerializeField] private GameObject proceedToStagesButton;

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

            // Check if the mouse was clicked
            bool mouseClicked = Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame;

            // NEW: If the mouse was clicked, check if it was hovering over a UI button!
            if (mouseClicked && EventSystem.current != null && EventSystem.current.IsPointerOverGameObject())
            {
                mouseClicked = false; // Ignore this click so the dialogue doesn't advance!
            }

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

    // --- NEW FEEDBACK PANEL FUNCTION ---
    public void CloseFeedbackSummary()
    {
        if (feedbackSummaryPanel != null)
        {
            feedbackSummaryPanel.SetActive(false);
        }
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

        if (GameManager.Instance != null)
        {
            GameManager.Instance.UpdateMetrics(clinical, info, empathy, safety, trust);
            // NEW: Add 1 to our patient counter!
            GameManager.Instance.patientsDiagnosed++;
        }

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
            int maxScore = 20;
            int patientsDone = 1;

            if (GameManager.Instance != null)
            {
                // Grab the stacked total score
                totalScore = GameManager.Instance.clinicalReasoningScore +
                             GameManager.Instance.informationGatheringScore +
                             GameManager.Instance.empathyTrustScore +
                             GameManager.Instance.patientSafetyScore;

                // Calculate the max possible score (20 for 1st patient, 40 for 2nd, 60 for 3rd)
                patientsDone = Mathf.Max(1, GameManager.Instance.patientsDiagnosed);
                maxScore = patientsDone * 20;
            }

            // Update the UI text to show the stacked score (e.g., 55 / 60)
            if (totalScoreText != null)
            {
                totalScoreText.text = $"FINAL SCORE: {totalScore} / {maxScore}";
            }

            if (gradeText != null)
            {
                // To get the correct Grade (Exemplary, etc.), we find the average score out of 20
                int averageScore = Mathf.RoundToInt((float)totalScore / patientsDone);
                gradeText.text = $"GRADE: {GetGradeScale(averageScore)}";

                // Check if 3 patients are diagnosed
                if (GameManager.Instance != null && GameManager.Instance.patientsDiagnosed >= 3)
                {
                    gradeText.text += "\n\n<color=#00FF00>TUTORIAL COMPLETE!</color>";
                    if (proceedToStagesButton != null) proceedToStagesButton.SetActive(true);
                }
                else
                {
                    if (proceedToStagesButton != null) proceedToStagesButton.SetActive(false);
                }
            }

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
    public void ProceedToStagesScene()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        if (GameManager.Instance != null) GameManager.Instance.hasCompletedTutorial = true; // Unlock the menu!

        // Reset the patient counter so Stage 1 starts fresh
        if (GameManager.Instance != null) GameManager.Instance.patientsDiagnosed = 0;

        UnityEngine.SceneManagement.SceneManager.LoadScene("StagesScene");
    }
    // --- NEW TUTORIAL STATE FUNCTION ---
    public void SetDialogueActiveState(bool state)
    {
        isDialogueActive = state;
    }
}