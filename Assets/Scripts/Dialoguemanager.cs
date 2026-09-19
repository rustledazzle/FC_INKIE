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

    [Header("Achievement Settings")]
    public GameObject achievementPrefab;
    public Transform mainCanvas;
    public Sprite tutorialBadgeIcon;
    public Sprite perfectStage1Icon;
    public Sprite perfectEmpathyIcon;
    public Sprite perfectSafetyIcon;
    public Sprite outstandingGradeIcon;
    public Sprite noCaseFileIcon;
    public Sprite chiefResidentIcon;
    public Sprite diagnosticDetectiveIcon;

    private bool openedCaseFileThisShift = false;

    private class BadgeData
    {
        public string title;
        public string desc;
        public Sprite icon;
    }
    private Queue<BadgeData> popupQueue = new Queue<BadgeData>();
    private bool isPopupPlaying = false;

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

    [Header("Tutorial Completion UI")]
    public GameObject tutorialCompletePanel;

    [Header("Level Progression")]
    public int requiredPatientsToPass = 3;

    [Header("Background Components")]
    [SerializeField] private Image backgroundImage;
    [SerializeField] private List<Sprite> backgroundSprites;

    [Header("Close-Up Evidence UI")]
    [SerializeField] private GameObject closeUpPanel;
    [SerializeField] private Image closeUpImage;
    [SerializeField] private List<Sprite> closeUpSprites;

    [Header("Save Data Settings")]
    public bool isTutorialScene = false;
    public bool isSpecialCaseScene = false;
    public string stagePrefix;
    public string nextSceneName = "StagesScene";

    private Dictionary<string, Sprite> closeUpDictionary;
    private Dictionary<string, Sprite> backgroundDictionary;
    private Story currentStory;
    private Dictionary<string, Sprite> portraitDictionary;

    public bool isDialogueActive { get; private set; } = false;
    public bool isShiftComplete { get; private set; } = false; // NEW: Stage lock
    private bool isWaitingForChoice = false;

    public int unlocksLevelIndex = 0;

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

        backgroundDictionary = new Dictionary<string, Sprite>();
        if (backgroundSprites != null)
        {
            foreach (Sprite sprite in backgroundSprites)
            {
                if (sprite != null && !backgroundDictionary.ContainsKey(sprite.name.ToLower()))
                {
                    backgroundDictionary.Add(sprite.name.ToLower(), sprite);
                }
            }
        }

        closeUpDictionary = new Dictionary<string, Sprite>();
        if (closeUpSprites != null)
        {
            foreach (Sprite sprite in closeUpSprites)
            {
                if (sprite != null && !closeUpDictionary.ContainsKey(sprite.name.ToLower()))
                {
                    closeUpDictionary.Add(sprite.name.ToLower(), sprite);
                }
            }
        }
    }

    void Start()
    {
        isDialogueActive = false;
        isShiftComplete = false; // Reset lock
        openedCaseFileThisShift = false;

        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false);

        // NEW: Force GameManager wipe on restart
        if (GameManager.Instance != null)
        {
            GameManager.Instance.clinicalReasoningScore = 0;
            GameManager.Instance.informationGatheringScore = 0;
            GameManager.Instance.empathyTrustScore = 0;
            GameManager.Instance.patientSafetyScore = 0;
            GameManager.Instance.patientsDiagnosed = 0;
        }
    }

    void Update()
    {
        if (!isDialogueActive) return;
        if (caseFilePanel != null && caseFilePanel.activeInHierarchy) return;

        if (!isWaitingForChoice && currentStory != null)
        {
            bool spacePressed = Keyboard.current != null && Keyboard.current.spaceKey.wasPressedThisFrame;
            bool enterPressed = Keyboard.current != null && (Keyboard.current.enterKey.wasPressedThisFrame || Keyboard.current.numpadEnterKey.wasPressedThisFrame);
            bool mouseClicked = Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame;

            if (mouseClicked && EventSystem.current != null && EventSystem.current.IsPointerOverGameObject())
            {
                mouseClicked = false;
            }

            if (spacePressed || enterPressed || mouseClicked)
            {
                OnContinueClicked();
            }
        }
    }

    public void EnterDialogueMode(TextAsset inkAsset, string patientNotes)
    {
        currentStory = new Story(inkAsset.text);
        isDialogueActive = true;

        if (dialoguePanel != null) dialoguePanel.SetActive(true);
        if (caseFileBodyText != null) caseFileBodyText.text = patientNotes;

        ContinueStory();
    }

    private void ExitDialogueMode()
    {
        isDialogueActive = false;
        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false);
        if (dialogueText != null) dialogueText.text = "";
        if (speakerNameText != null) speakerNameText.text = "";
        UpdatePortrait(leftPortraitImage, "clear");
        UpdatePortrait(rightPortraitImage, "clear");
    }

    public void OpenCaseFile()
    {
        if (caseFilePanel != null)
        {
            caseFilePanel.SetActive(true);
            openedCaseFileThisShift = true;
        }
    }

    public void CloseCaseFile()
    {
        if (caseFilePanel != null) caseFilePanel.SetActive(false);
    }

    public void CloseFeedbackSummary()
    {
        if (isShiftComplete) return; // NEW: Block closing if shift is complete!

        if (feedbackSummaryPanel != null) feedbackSummaryPanel.SetActive(false);
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
            UpdateCloseUp("clear");

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
                case "bg":
                case "background":
                    UpdateBackground(value);
                    break;
                case "closeup":
                case "evidence":
                    UpdateCloseUp(value);
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

    private void UpdateBackground(string spriteName)
    {
        if (backgroundImage == null) return;
        if (spriteName == "clear" || spriteName == "none")
        {
            backgroundImage.gameObject.SetActive(false);
            return;
        }
        if (backgroundDictionary.ContainsKey(spriteName))
        {
            backgroundImage.sprite = backgroundDictionary[spriteName];
            backgroundImage.gameObject.SetActive(true);
        }
    }

    private void UpdateCloseUp(string spriteName)
    {
        if (closeUpPanel == null || closeUpImage == null) return;
        if (spriteName == "clear" || spriteName == "none")
        {
            closeUpPanel.SetActive(false);
            return;
        }
        if (closeUpDictionary.ContainsKey(spriteName))
        {
            closeUpImage.sprite = closeUpDictionary[spriteName];
            closeUpPanel.SetActive(true);
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
                totalScore = GameManager.Instance.clinicalReasoningScore +
                             GameManager.Instance.informationGatheringScore +
                             GameManager.Instance.empathyTrustScore +
                             GameManager.Instance.patientSafetyScore;

                patientsDone = Mathf.Max(1, GameManager.Instance.patientsDiagnosed);
                maxScore = patientsDone * 20;
            }

            if (totalScoreText != null)
            {
                totalScoreText.text = $"FINAL SCORE: {totalScore} / {maxScore}";
            }

            if (gradeText != null)
            {
                int averageScore = Mathf.RoundToInt((float)totalScore / patientsDone);
                gradeText.text = $"GRADE: {GetGradeScale(averageScore)}";

                if (GameManager.Instance != null && GameManager.Instance.patientsDiagnosed >= requiredPatientsToPass)
                {
                    isShiftComplete = true; // NEW: Lock the stage
                    gradeText.text += "\n\n<color=#00FF00>SHIFT COMPLETE!</color>";
                    if (proceedToStagesButton != null) proceedToStagesButton.SetActive(true);

                    // Achievements block...
                    if (!isTutorialScene)
                    {
                        if (GameManager.Instance.empathyTrustScore >= (patientsDone * 5))
                            UnlockBadge("Badge_PerfectEmpathy", "Impeccable Bedside Manner", "Perfect Empathy score.", perfectEmpathyIcon);

                        if (GameManager.Instance.patientSafetyScore >= (patientsDone * 5))
                            UnlockBadge("Badge_PerfectSafety", "Primum Non Nocere", "Perfect Safety score.", perfectSafetyIcon);

                        if ((float)totalScore / maxScore >= 0.90f)
                            UnlockBadge("Badge_OutstandingGrade", "The Attending Physician", "Achieved an Outstanding grade.", outstandingGradeIcon);

                        if (stagePrefix == "Stage1_Morning" && totalScore == maxScore)
                            UnlockBadge("Badge_PerfectStage1", "Textbook Case", "Perfect score in Stage 1.", perfectStage1Icon);

                        if (!openedCaseFileThisShift)
                            UnlockBadge("Badge_NoCaseFile", "Photographic Memory", "Completed a shift without opening the case file.", noCaseFileIcon);

                        if (unlocksLevelIndex >= 4)
                            UnlockBadge("Badge_ChiefResident", "Chief Resident", "Completed all main shifts.", chiefResidentIcon);

                        if (isSpecialCaseScene)
                            UnlockBadge("Badge_SpecialCases", "Diagnostic Detective", "Successfully diagnosed a Special Case.", diagnosticDetectiveIcon);
                    }
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

    public void CompleteShiftAndSave()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (GameManager.Instance != null) GameManager.Instance.hasCompletedTutorial = true;

        int currentUnlockedLevel = PlayerPrefs.GetInt("UnlockedStageLevel", 0);
        if (unlocksLevelIndex > currentUnlockedLevel)
        {
            PlayerPrefs.SetInt("UnlockedStageLevel", unlocksLevelIndex);
        }

        if (!isTutorialScene)
        {
            int finalClinical = GameManager.Instance.clinicalReasoningScore;
            int finalInfo = GameManager.Instance.informationGatheringScore;
            int finalEmpathy = GameManager.Instance.empathyTrustScore;
            int finalSafety = GameManager.Instance.patientSafetyScore;

            PlayerPrefs.SetInt(stagePrefix + "_Clinical", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Clinical", 0), finalClinical));
            PlayerPrefs.SetInt(stagePrefix + "_Info", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Info", 0), finalInfo));
            PlayerPrefs.SetInt(stagePrefix + "_Empathy", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Empathy", 0), finalEmpathy));
            PlayerPrefs.SetInt(stagePrefix + "_Safety", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Safety", 0), finalSafety));
            PlayerPrefs.Save();
        }

        if (GameManager.Instance != null)
        {
            GameManager.Instance.clinicalReasoningScore = 0;
            GameManager.Instance.informationGatheringScore = 0;
            GameManager.Instance.empathyTrustScore = 0;
            GameManager.Instance.patientSafetyScore = 0;
            GameManager.Instance.patientsDiagnosed = 0;
        }

        UnityEngine.SceneManagement.SceneManager.LoadScene(nextSceneName);
    }

    public void SetDialogueActiveState(bool state)
    {
        isDialogueActive = state;
    }

    public void OpenTutorialCompletePanel()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        if (feedbackSummaryPanel != null) feedbackSummaryPanel.SetActive(false);
        if (tutorialCompletePanel != null) tutorialCompletePanel.SetActive(true);

        if (isTutorialScene)
        {
            UnlockBadge("Badge_Tutorial", "First Day of Clinic", "Completed the Tutorial.", tutorialBadgeIcon);
        }
    }

    public bool IsFeedbackPanelActive()
    {
        return feedbackSummaryPanel != null && feedbackSummaryPanel.activeInHierarchy;
    }

    public void UnlockBadge(string badgeKey, string title, string desc, Sprite icon)
    {
        if (PlayerPrefs.GetInt(badgeKey, 0) == 0)
        {
            PlayerPrefs.SetInt(badgeKey, 1);
            PlayerPrefs.Save();

            BadgeData newBadge = new BadgeData { title = title, desc = desc, icon = icon };
            popupQueue.Enqueue(newBadge);

            if (!isPopupPlaying)
            {
                StartCoroutine(ProcessPopupQueue());
            }
        }
    }

    private IEnumerator ProcessPopupQueue()
    {
        isPopupPlaying = true;

        while (popupQueue.Count > 0)
        {
            BadgeData currentBadge = popupQueue.Dequeue();

            if (achievementPrefab != null && mainCanvas != null)
            {
                GameObject popup = Instantiate(achievementPrefab, mainCanvas);
                AchievementPopup script = popup.GetComponent<AchievementPopup>();

                if (script != null)
                {
                    script.SetupAndShow(currentBadge.title, currentBadge.desc, currentBadge.icon);
                    float totalAnimationTime = script.fadeInTime + script.displayTime + script.fadeOutTime;
                    yield return new WaitForSeconds(totalAnimationTime + 0.5f);
                }
            }
        }

        isPopupPlaying = false;
    }
}