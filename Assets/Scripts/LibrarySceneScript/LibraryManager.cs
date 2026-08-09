using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class LibraryManager : MonoBehaviour
{
    [Header("UI Text References")]
    public TextMeshProUGUI titleText;
    public TextMeshProUGUI detailsText;

    [Header("Buttons")]
    public Button ktsCaseButton;
    public Button feverCaseButton;
    public Button backButton;

    void Start()
    {
        // 1. Set the default welcome message when the scene loads
        UpdateReadingPanel(
            "Select a Medical Case",
            "Welcome to the Clinical Reference Library.\n\nPlease click on a case on the left to review symptoms, clinical guidelines, and expected rubrics before starting your shift."
        );

        // 2. Tell the KTS button what text to display
        ktsCaseButton.onClick.AddListener(() => UpdateReadingPanel(
            "Klippel-Trenaunay Syndrome (KTS)",
            "<b>Patient:</b> Baby Maya (7 months)\n\n<b>Common Symptoms:</b>\n- Fever\n- Restlessness\n- Enlarging warm birthmark (Port-wine stain) on leg\n- Limb overgrowth\n\n<b>Clinical Focus:</b>\nKTS is a rare congenital vascular disorder. Focus on identifying the triad of symptoms, showing empathy to the overwhelmed mother, and ensuring a safe referral to a vascular specialist."
        ));

        // 3. Tell the Fever button what text to display
        feverCaseButton.onClick.AddListener(() => UpdateReadingPanel(
            "Standard Fever / Suspected Dengue",
            "<b>Patient:</b> Mang Jose\n\n<b>Common Symptoms:</b>\n- 3-day continuous fever\n- Severe joint pain\n- Pain behind the eyes\n\n<b>Clinical Focus:</b>\nFocus on thorough Information Gathering. Ask about the timeline of the fever and environmental factors (e.g., mosquitoes, sick neighbors) to rule out other infections."
        ));

        // 4. Hook up the back button to return to the Main Menu
        backButton.onClick.AddListener(() => SceneManager.LoadScene("MenuScene"));
    }

    // This function simply swaps out the text!
    private void UpdateReadingPanel(string newTitle, string newDetails)
    {
        if (titleText != null) titleText.text = newTitle;
        if (detailsText != null) detailsText.text = newDetails;
    }
}