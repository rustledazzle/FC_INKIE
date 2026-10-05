using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using Firebase.Auth;
using Firebase.Firestore;
using Firebase.Extensions;

public class LibraryManager : MonoBehaviour
{
    [Header("UI Image Reference")]
    public Image caseImageDisplay1;
    public Image caseImageDisplay2;

    [Header("UI Text References")]
    public TextMeshProUGUI titleText;
    public TextMeshProUGUI detailsText;
    public TextMeshProUGUI caseCounterText;
    public Slider progressSlider;

    [Header("Database (Drag ScriptableObjects Here)")]
    public List<MedicalCase> allCases;
    private List<MedicalCase> unlockedCases = new List<MedicalCase>();

    [Header("Navigation")]
    public Button backButton;
    public Button nextCaseButton;
    public Button prevCaseButton;

    private int currentCaseIndex = 0;

    void Start()
    {
        // 1. Navigation Listeners
        if (backButton != null)
        {
            backButton.onClick.AddListener(() => {
                PlayClickSound();
                SceneManager.LoadScene("MenuScene");
            });
        }

        if (nextCaseButton != null)
        {
            nextCaseButton.onClick.AddListener(() => {
                PlayClickSound();
                if (unlockedCases.Count > 0)
                {
                    currentCaseIndex = (currentCaseIndex + 1) % unlockedCases.Count;
                    ShowDisease(unlockedCases[currentCaseIndex]);
                }
            });
        }

        if (prevCaseButton != null)
        {
            prevCaseButton.onClick.AddListener(() => {
                PlayClickSound();
                if (unlockedCases.Count > 0)
                {
                    currentCaseIndex = (currentCaseIndex - 1 + unlockedCases.Count) % unlockedCases.Count;
                    ShowDisease(unlockedCases[currentCaseIndex]);
                }
            });
        }

        // 2. Load unlocked cases immediately from local PlayerPrefs
        RefreshUnlockedCases(PlayerPrefs.GetInt("UnlockedStageLevel", 0));

        // 3. Verify with Firebase Cloud (works for both Guest and Registered users)
        SyncLibraryLevelFromCloud();
    }

    private void RefreshUnlockedCases(int unlockedLevel)
    {
        unlockedCases.Clear();

        foreach (MedicalCase medCase in allCases)
        {
            if (medCase != null && medCase.requiredStageLevel <= unlockedLevel)
            {
                unlockedCases.Add(medCase);
            }
        }

        if (unlockedCases.Count > 0)
        {
            if (currentCaseIndex >= unlockedCases.Count) currentCaseIndex = 0;
            if (nextCaseButton != null) nextCaseButton.interactable = true;
            if (prevCaseButton != null) prevCaseButton.interactable = true;

            ShowDisease(unlockedCases[currentCaseIndex]);
        }
        else
        {
            UpdateReadingPanel("📚 Diagnostic Dossier", "Welcome to the Clinical Reference Library.\n\nYou have not unlocked any cases yet. Complete shifts to unlock medical files.");
            if (caseCounterText != null) caseCounterText.text = "0 Cases Unlocked";
            if (progressSlider != null) progressSlider.value = 0;

            if (caseImageDisplay1 != null) caseImageDisplay1.gameObject.SetActive(false);
            if (caseImageDisplay2 != null) caseImageDisplay2.gameObject.SetActive(false);

            if (nextCaseButton != null) nextCaseButton.interactable = false;
            if (prevCaseButton != null) prevCaseButton.interactable = false;
        }
    }

    private void SyncLibraryLevelFromCloud()
    {
        string docId = PlayerPrefs.GetString("ActiveDocumentId", "");
        if (string.IsNullOrEmpty(docId) && FirebaseAuth.DefaultInstance != null && FirebaseAuth.DefaultInstance.CurrentUser != null)
        {
            docId = FirebaseAuth.DefaultInstance.CurrentUser.UserId;
        }

        if (string.IsNullOrEmpty(docId)) return;

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        db.Collection("Users").Document(docId).GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsCompleted && !task.IsFaulted)
            {
                DocumentSnapshot snapshot = task.Result;
                if (snapshot.Exists && snapshot.ContainsField("HighestUnlockedLevel"))
                {
                    int cloudLevel = snapshot.GetValue<int>("HighestUnlockedLevel");
                    if (cloudLevel != PlayerPrefs.GetInt("UnlockedStageLevel", 0))
                    {
                        PlayerPrefs.SetInt("UnlockedStageLevel", cloudLevel);
                        PlayerPrefs.Save();
                        RefreshUnlockedCases(cloudLevel);
                    }
                }
            }
        });
    }

    private void ShowDisease(MedicalCase disease)
    {
        string displayText = $"<b>Type:</b> {disease.type}\n" +
                             $"<b>Category:</b> {disease.category}\n\n" +
                             $"<b>Description:</b>\n{disease.description}\n\n" +
                             $"<b>Symptoms:</b>\n{disease.symptoms}\n\n" +
                             $"<b>Pathology:</b>\n{disease.pathology}\n\n" +
                             $"<b>Treatment:</b>\n{disease.treatment}\n\n" +
                             $"{disease.keyFeatures}";

        UpdateReadingPanel(disease.title, displayText);
        UpdateCaseCounter();

        // Handle Image 1
        if (caseImageDisplay1 != null)
        {
            if (disease.caseImage1 != null)
            {
                caseImageDisplay1.sprite = disease.caseImage1;
                caseImageDisplay1.gameObject.SetActive(true);
            }
            else
            {
                caseImageDisplay1.gameObject.SetActive(false);
            }
        }

        // Handle Image 2
        if (caseImageDisplay2 != null)
        {
            if (disease.caseImage2 != null)
            {
                caseImageDisplay2.sprite = disease.caseImage2;
                caseImageDisplay2.gameObject.SetActive(true);
            }
            else
            {
                caseImageDisplay2.gameObject.SetActive(false);
            }
        }
    }

    private void UpdateReadingPanel(string newTitle, string newDetails)
    {
        if (titleText != null) titleText.text = newTitle;
        if (detailsText != null) detailsText.text = newDetails;
    }

    private void UpdateCaseCounter()
    {
        if (caseCounterText != null && unlockedCases.Count > 0)
        {
            caseCounterText.text = $"Disease {currentCaseIndex + 1} of {unlockedCases.Count}";
        }
        if (progressSlider != null && unlockedCases.Count > 0)
        {
            progressSlider.value = (float)(currentCaseIndex + 1) / unlockedCases.Count;
        }
    }

    private void PlayClickSound()
    {
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayClick();
        }
    }
}