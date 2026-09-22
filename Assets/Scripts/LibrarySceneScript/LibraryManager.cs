using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

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
    private List<MedicalCase> unlockedCases = new List<MedicalCase>(); // The filtered list

    [Header("Navigation")]
    public Button backButton;
    public Button nextCaseButton;
    public Button prevCaseButton;

    private int currentCaseIndex = 0;

    void Start()
    {
        // 1. Check player progress (0 = Tutorial, 1 = Stage 1, etc.)
        int currentUnlockedLevel = PlayerPrefs.GetInt("UnlockedStageLevel", 0);

        // 2. Filter the database so players only see what they have unlocked
        foreach (MedicalCase medCase in allCases)
        {
            if (medCase.requiredStageLevel <= currentUnlockedLevel)
            {
                unlockedCases.Add(medCase);
            }
        }

        // 3. Navigation Listeners
        backButton.onClick.AddListener(() => {
            PlayClickSound();
            SceneManager.LoadScene("MenuScene");
        });

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

        // 4. Initial Display
        if (unlockedCases.Count > 0)
        {
            currentCaseIndex = 0;
            ShowDisease(unlockedCases[0]); // Show first unlocked case
        }
        else
        {
            // If they haven't unlocked anything yet
            UpdateReadingPanel("📚 Diagnostic Dossier", "Welcome to the Clinical Reference Library.\n\nYou have not unlocked any cases yet. Complete shifts to unlock medical files.");
            if (caseCounterText != null) caseCounterText.text = "0 Cases Unlocked";
            if (progressSlider != null) progressSlider.value = 0;

            // Disable buttons so they don't break the UI
            if (nextCaseButton != null) nextCaseButton.interactable = false;
            if (prevCaseButton != null) prevCaseButton.interactable = false;
        }
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

        // --- ADD THIS NEW IMAGE LOGIC ---
        if (caseImageDisplay1 != null)
        {
            if (disease.caseImage1 != null)
            {
                caseImageDisplay1.sprite = disease.caseImage1;
                caseImageDisplay1.gameObject.SetActive(true); // Turn it ON
            }
            else
            {
                caseImageDisplay1.gameObject.SetActive(false); // Turn it OFF if empty
            }
        }

        // Handle Image 2
        if (caseImageDisplay2 != null)
        {
            if (disease.caseImage2 != null)
            {
                caseImageDisplay2.sprite = disease.caseImage2;
                caseImageDisplay2.gameObject.SetActive(true); // Turn it ON
            }
            else
            {
                caseImageDisplay2.gameObject.SetActive(false); // Turn it OFF if empty
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