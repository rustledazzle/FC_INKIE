using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;
using TMPro;
using Ink.Runtime;
using UnityEngine.EventSystems;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;
using System.Collections;
using System.Collections.Generic;

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
    [SerializeField] private float typingSpeed = 0.025f;

    [Header("Typewriter Audio")]
    [SerializeField] private AudioSource typingAudioSource;
    [SerializeField] private AudioClip typingSoundClip;
    [SerializeField] private int soundFrequency = 3;
    [SerializeField][Range(0f, 1f)] private float typingVolume = 0.4f;

    private Coroutine typingCoroutine;
    private bool isTyping = false;

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
    public GameObject endOfStoryPanel;

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
    public bool isShiftComplete { get; private set; } = false;
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
        isShiftComplete = false;
        openedCaseFileThisShift = false;

        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false);

        UpdateBackground("clear");
        UpdateCloseUp("clear");
        UpdatePortrait(leftPortraitImage, "clear");
        UpdatePortrait(rightPortraitImage, "clear");

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
        if (Time.timeScale == 0f) return;
        if (!isDialogueActive) return;
        if (caseFilePanel != null && caseFilePanel.activeInHierarchy) return;

        if ((!isWaitingForChoice || isTyping) && currentStory != null)
        {
            bool spacePressed = Keyboard.current != null && Keyboard.current.spaceKey.wasPressedThisFrame;
            bool enterPressed = Keyboard.current != null && (Keyboard.current.enterKey.wasPressedThisFrame || Keyboard.current.numpadEnterKey.wasPressedThisFrame);

            // PC Mouse Click
            bool mouseClicked = Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame;

            // --- ANDROID TOUCH SUPPORT: Detect primary finger tap ---
            bool screenTapped = Touchscreen.current != null && Touchscreen.current.primaryTouch.press.wasPressedThisFrame;

            // --- CROSS-PLATFORM UI OVER HANG / BUTTON CLICK CHECK ---
            if ((mouseClicked || screenTapped) && IsPointerOverButton())
            {
                mouseClicked = false;
                screenTapped = false;
            }

            if (spacePressed || enterPressed || mouseClicked || screenTapped)
            {
                OnContinueClicked();
            }
        }
    }

    // --- Checks if the pointer/touch is interacting with a UI Button (Case File, Choices, etc.) ---
    private bool IsPointerOverButton()
    {
        if (EventSystem.current == null) return false;

        PointerEventData eventData = new PointerEventData(EventSystem.current);

        // Handle both Mouse position and Touch position for UI Raycasting
        if (Touchscreen.current != null && Touchscreen.current.primaryTouch.press.isPressed)
        {
            eventData.position = Touchscreen.current.primaryTouch.position.ReadValue();
        }
        else if (Mouse.current != null)
        {
            eventData.position = Mouse.current.position.ReadValue();
        }
        else
        {
            return false;
        }

        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, results);

        foreach (RaycastResult result in results)
        {
            if (result.gameObject.GetComponentInParent<Button>() != null)
            {
                return true;
            }
        }
        return false;
    }

    private string GetActiveUserDocumentId()
    {
        string activeDocId = PlayerPrefs.GetString("ActiveDocumentId", "");
        if (!string.IsNullOrEmpty(activeDocId))
        {
            return activeDocId;
        }

        FirebaseUser currentUser = FirebaseAuth.DefaultInstance != null ? FirebaseAuth.DefaultInstance.CurrentUser : null;
        return currentUser != null ? currentUser.UserId : "";
    }

    public void EnterDialogueMode(TextAsset inkAsset, string patientNotes)
    {
        currentStory = new Story(inkAsset.text);
        isDialogueActive = true;

        if (dialoguePanel != null) dialoguePanel.SetActive(true);
        if (caseFileBodyText != null) caseFileBodyText.text = patientNotes;

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.SetDialogueDucking(true);
        }

        ContinueStory();
    }

    private void ExitDialogueMode()
    {
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.SetDialogueDucking(false);
        }

        if (typingCoroutine != null) StopCoroutine(typingCoroutine);
        isTyping = false;

        isDialogueActive = false;
        if (dialoguePanel != null) dialoguePanel.SetActive(false);
        if (caseFilePanel != null) caseFilePanel.SetActive(false);
        if (dialogueText != null)
        {
            dialogueText.text = "";
            dialogueText.maxVisibleCharacters = 99999;
        }
        if (speakerNameText != null) speakerNameText.text = "";
        UpdatePortrait(leftPortraitImage, "clear");
        UpdatePortrait(rightPortraitImage, "clear");
        UpdateBackground("clear");
        UpdateCloseUp("clear");

        if (endOfStoryPanel != null)
        {
            endOfStoryPanel.SetActive(true);
        }
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
        if (isShiftComplete) return;

        if (feedbackSummaryPanel != null) feedbackSummaryPanel.SetActive(false);
    }

    public void OnContinueClicked()
    {
        if (isTyping)
        {
            CompleteTypingImmediately();
            return;
        }

        if (!isWaitingForChoice) ContinueStory();
    }

    public void ContinueStory()
    {
        if (currentStory == null) return;

        if (currentStory.canContinue)
        {
            UpdateCloseUp("clear");

            string nextLine = currentStory.Continue();
            HandleTags(currentStory.currentTags);

            ClearChoices();
            SetWaitingForChoice(false);

            if (typingCoroutine != null) StopCoroutine(typingCoroutine);
            typingCoroutine = StartCoroutine(TypeDialogueText(nextLine));
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

    private IEnumerator TypeDialogueText(string line)
    {
        isTyping = true;
        if (continuePrompt != null) continuePrompt.SetActive(false);

        if (dialogueText != null)
        {
            dialogueText.text = line;
            dialogueText.ForceMeshUpdate();
            int totalVisibleCharacters = dialogueText.textInfo.characterCount;
            dialogueText.maxVisibleCharacters = 0;

            for (int i = 0; i <= totalVisibleCharacters; i++)
            {
                dialogueText.maxVisibleCharacters = i;

                if (typingAudioSource != null && typingSoundClip != null && i > 0 && i < line.Length)
                {
                    if (i % soundFrequency == 0 && !char.IsWhiteSpace(line[i]))
                    {
                        float globalSFX = (AudioManager.Instance != null && AudioManager.Instance.sfxSource != null)
                            ? AudioManager.Instance.sfxSource.volume
                            : PlayerPrefs.GetFloat("SFXVolume", 1f);

                        typingAudioSource.pitch = Random.Range(0.95f, 1.05f);
                        typingAudioSource.PlayOneShot(typingSoundClip, typingVolume * globalSFX);
                    }
                }

                yield return new WaitForSeconds(typingSpeed);
            }
        }

        FinishLineAndCheckChoices();
    }

    private void CompleteTypingImmediately()
    {
        if (typingCoroutine != null) StopCoroutine(typingCoroutine);

        if (dialogueText != null)
        {
            dialogueText.maxVisibleCharacters = 99999;
        }

        FinishLineAndCheckChoices();
    }

    private void FinishLineAndCheckChoices()
    {
        isTyping = false;

        if (currentStory != null && currentStory.currentChoices.Count > 0)
        {
            DisplayChoices();
        }
        else
        {
            SetWaitingForChoice(false);
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
        if (continuePrompt != null) continuePrompt.SetActive(!state && !isTyping && currentStory != null && currentStory.canContinue);
    }

    private void EvaluateAndPushScores()
    {
        int clinical = Mathf.Clamp(GetInkVariableInt("clinical_score"), 0, 5);
        int info = Mathf.Clamp(GetInkVariableInt("info_score"), 0, 5);
        int empathy = Mathf.Clamp(GetInkVariableInt("empathy_score"), 0, 5);
        int safety = Mathf.Clamp(GetInkVariableInt("safety_score"), 0, 5);
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
                    isShiftComplete = true;
                    gradeText.text += "\n\n<color=#00FF00>SHIFT COMPLETE!</color>";
                    if (proceedToStagesButton != null) proceedToStagesButton.SetActive(true);

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
        PlayerPrefs.SetInt("Badge_Tutorial", 1);

        int currentUnlockedLevel = PlayerPrefs.GetInt("UnlockedStageLevel", 0);
        if (unlocksLevelIndex > currentUnlockedLevel)
        {
            PlayerPrefs.SetInt("UnlockedStageLevel", unlocksLevelIndex);
        }
        PlayerPrefs.Save();

        string docId = GetActiveUserDocumentId();

        if (!isTutorialScene)
        {
            int finalClinical = GameManager.Instance != null ? GameManager.Instance.clinicalReasoningScore : 0;
            int finalInfo = GameManager.Instance != null ? GameManager.Instance.informationGatheringScore : 0;
            int finalEmpathy = GameManager.Instance != null ? GameManager.Instance.empathyTrustScore : 0;
            int finalSafety = GameManager.Instance != null ? GameManager.Instance.patientSafetyScore : 0;

            PlayerPrefs.SetInt(stagePrefix + "_Clinical", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Clinical", 0), finalClinical));
            PlayerPrefs.SetInt(stagePrefix + "_Info", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Info", 0), finalInfo));
            PlayerPrefs.SetInt(stagePrefix + "_Empathy", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Empathy", 0), finalEmpathy));
            PlayerPrefs.SetInt(stagePrefix + "_Safety", Mathf.Max(PlayerPrefs.GetInt(stagePrefix + "_Safety", 0), finalSafety));
            PlayerPrefs.Save();

            if (!string.IsNullOrEmpty(docId))
            {
                FirebaseFirestore db = FirebaseFirestore.DefaultInstance;

                Dictionary<string, object> currentStageData = new Dictionary<string, object>
                {
                    { "ClinicalReasoning", finalClinical },
                    { "InformationGathering", finalInfo },
                    { "Empathy", finalEmpathy },
                    { "PatientSafety", finalSafety },
                    { "CompletedAt", FieldValue.ServerTimestamp }
                };

                Dictionary<string, object> userUpdate = new Dictionary<string, object>
                {
                    { stagePrefix, currentStageData },
                    { "TutorialCompleted", true },
                    { "HighestUnlockedLevel", PlayerPrefs.GetInt("UnlockedStageLevel", 0) },
                    { "LastActive", FieldValue.ServerTimestamp }
                };

                db.Collection("Users").Document(docId)
                  .SetAsync(userUpdate, SetOptions.MergeAll)
                  .ContinueWithOnMainThread(task =>
                  {
                      if (task.IsFaulted) Debug.LogError("Cloud Save Failed: " + task.Exception);
                      else if (task.IsCompleted) Debug.Log($"Successfully backed up {stagePrefix} to the cloud for {docId}!");
                  });
            }
        }
        else if (!string.IsNullOrEmpty(docId))
        {
            FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
            Dictionary<string, object> tutorialUpdate = new Dictionary<string, object>
            {
                { "TutorialCompleted", true },
                { "HighestUnlockedLevel", PlayerPrefs.GetInt("UnlockedStageLevel", 0) },
                { "LastActive", FieldValue.ServerTimestamp }
            };

            db.Collection("Users").Document(docId).SetAsync(tutorialUpdate, SetOptions.MergeAll);
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

    public void LoadNextSceneOnly()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        UnityEngine.SceneManagement.SceneManager.LoadScene("MenuScene");
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

            string docId = GetActiveUserDocumentId();
            if (!string.IsNullOrEmpty(docId))
            {
                FirebaseFirestore db = FirebaseFirestore.DefaultInstance;

                Dictionary<string, object> badgeUpdate = new Dictionary<string, object>
                {
                    { badgeKey, true }
                };

                Dictionary<string, object> userUpdate = new Dictionary<string, object>
                {
                    { "Badges", badgeUpdate },
                    { "LastActive", FieldValue.ServerTimestamp }
                };

                db.Collection("Users").Document(docId)
                  .SetAsync(userUpdate, SetOptions.MergeAll)
                  .ContinueWithOnMainThread(task =>
                  {
                      if (task.IsFaulted) Debug.LogError("Failed to save badge to cloud: " + task.Exception);
                      else Debug.Log($"Badge '{badgeKey}' saved to Firebase for {docId}!");
                  });
            }

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