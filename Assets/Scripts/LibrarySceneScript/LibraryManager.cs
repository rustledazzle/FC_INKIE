using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class LibraryManager : MonoBehaviour
{
    [Header("UI Text References")]
    public TextMeshProUGUI titleText;
    public TextMeshProUGUI detailsText;
    public TextMeshProUGUI caseCounterText;
    public Slider progressSlider;

    [Header("Common Case Buttons")]
    public Button ktsCaseButton;
    public Button feverCaseButton;

    [Header("Uncommon Case Buttons")]
    public Button hSyndromeButton;
    public Button sca15Button;
    public Button wolframButton;
    public Button schistosomiasisButton;

    [Header("Navigation")]
    public Button backButton;
    public Button nextCaseButton;
    public Button prevCaseButton;

    private int currentCaseIndex = 0;

    [System.Serializable]
    public class DiseaseEntry
    {
        public string title;
        public string type;          // Common or Uncommon
        public string category;      // Genetic, Vascular, Infectious, etc.
        public string description;
        public string symptoms;
        public string pathology;
        public string treatment;
        public string keyFeatures;
    }

    private DiseaseEntry[] diseaseLibrary = new DiseaseEntry[7];

    void Start()
    {
        InitializeDiseaseLibrary();

        // Welcome message
        UpdateReadingPanel(
            "📚 Diagnostic Dossier",
            "Welcome to the Clinical Reference Library.\n\n" +
            "Select a disease from the buttons below to review its:\n" +
            "• Description\n" +
            "• Symptoms\n" +
            "• Pathology\n" +
            "• Treatment\n\n" +
            "🟢 Common Diseases\n" +
            "🟣 Uncommon Diseases"
        );

        // --- COMMON CASES ---
        ktsCaseButton.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 0;
            ShowDisease(diseaseLibrary[0]);
        });

        feverCaseButton.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 1;
            ShowDisease(diseaseLibrary[1]);
        });

        // --- UNCOMMON CASES ---
        hSyndromeButton.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 2;
            ShowDisease(diseaseLibrary[2]);
        });

        sca15Button.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 3;
            ShowDisease(diseaseLibrary[3]);
        });

        wolframButton.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 4;
            ShowDisease(diseaseLibrary[4]);
        });

        schistosomiasisButton.onClick.AddListener(() => {
            PlayClickSound();
            currentCaseIndex = 5;
            ShowDisease(diseaseLibrary[5]);
        });

        // --- NAVIGATION ---
        backButton.onClick.AddListener(() => {
            PlayClickSound();
            SceneManager.LoadScene("MenuScene");
        });

        if (nextCaseButton != null)
        {
            nextCaseButton.onClick.AddListener(() => {
                PlayClickSound();
                currentCaseIndex = (currentCaseIndex + 1) % diseaseLibrary.Length;
                ShowDisease(diseaseLibrary[currentCaseIndex]);
            });
        }

        if (prevCaseButton != null)
        {
            prevCaseButton.onClick.AddListener(() => {
                PlayClickSound();
                currentCaseIndex = (currentCaseIndex - 1 + diseaseLibrary.Length) % diseaseLibrary.Length;
                ShowDisease(diseaseLibrary[currentCaseIndex]);
            });
        }

        UpdateCaseCounter();
    }

    private void InitializeDiseaseLibrary()
    {
        // --- COMMON DISEASES ---

        diseaseLibrary[0] = new DiseaseEntry
        {
            title = "Klippel-Trenaunay Syndrome",
            type = "Common",
            category = "Vascular Disorder",
            description = "A rare congenital vascular disorder characterized by a triad of capillary malformations, venous/lymphatic malformations, and soft tissue/bone hypertrophy.",
            symptoms = "• Port-wine stain (capillary malformation)\n" +
                       "• Limb overgrowth (length and girth)\n" +
                       "• Venous varicosities\n" +
                       "• Skin warmth over affected areas\n" +
                       "• May present with fever if inflamed",
            pathology = "Genetic mutations (RAD50, POLE, PIK3CA) lead to dysregulation of vascular development. This results in abnormal blood vessel formation and tissue overgrowth.",
            treatment = "• Sirolimus (targeted therapy) - significant improvement shown\n" +
                        "• Compression garments\n" +
                        "• Orthopedic management for limb length discrepancy\n" +
                        "• Multidisciplinary care: Dermatology, Vascular Surgery, Orthopedics",
            keyFeatures = "🔬 Classic Triad:\n" +
                          "1. Capillary malformation (port-wine stain)\n" +
                          "2. Venous/lymphatic malformations\n" +
                          "3. Soft tissue and bone hypertrophy"
        };

        diseaseLibrary[1] = new DiseaseEntry
        {
            title = "Dengue Fever",
            type = "Common",
            category = "Infectious - Viral",
            description = "A mosquito-borne viral infection caused by the dengue virus. Endemic in tropical regions including the Philippines. Can range from mild febrile illness to severe hemorrhagic fever.",
            symptoms = "• High fever (40°C/104°F)\n" +
                       "• Severe headache\n" +
                       "• Pain behind the eyes\n" +
                       "• Severe joint and muscle pain (breakbone fever)\n" +
                       "• Nausea and vomiting\n" +
                       "• Skin rash\n" +
                       "• Warning signs: abdominal pain, persistent vomiting, bleeding, lethargy",
            pathology = "Four serotypes (DENV-1 to 4) transmitted by Aedes mosquitoes. The virus infects and replicates in immune cells, triggering a systemic inflammatory response. Antibody-dependent enhancement can cause severe disease on secondary infection.",
            treatment = "• Supportive care: hydration, paracetamol for fever\n" +
                        "• Avoid NSAIDs (risk of bleeding)\n" +
                        "• Monitor for warning signs\n" +
                        "• Hospitalization if severe dengue develops",
            keyFeatures = "⚠️ Warning Signs (Require Urgent Care):\n" +
                          "• Abdominal pain/tenderness\n" +
                          "• Persistent vomiting\n" +
                          "• Clinical fluid accumulation\n" +
                          "• Mucosal bleeding\n" +
                          "• Lethargy or restlessness\n" +
                          "• Liver enlargement >2cm"
        };

        // --- UNCOMMON DISEASES ---

        diseaseLibrary[2] = new DiseaseEntry
        {
            title = "H Syndrome",
            type = "Uncommon",
            category = "Genetic - Autosomal Recessive",
            description = "An ultra-rare genodermatosis caused by mutations in the SLC29A3 gene. The name derives from the characteristic features that all start with the letter 'H'. Fewer than 200 cases reported worldwide.",
            symptoms = "• Hyperpigmentation (dark skin patches)\n" +
                       "• Hypertrichosis (excessive hair growth)\n" +
                       "• Hepatosplenomegaly (liver/spleen enlargement)\n" +
                       "• Hypogonadism\n" +
                       "• Hearing loss\n" +
                       "• Heart abnormalities\n" +
                       "• Short stature\n" +
                       "• Bilateral cheek enlargement",
            pathology = "Mutations in the SLC29A3 gene encoding hENT3 (human equilibrative nucleoside transporter 3). Dysfunction leads to inflammation and histiocyte proliferation in various tissues.",
            treatment = "• Anti-inflammatory medications (NSAIDs, naproxen)\n" +
                        "• Targeted therapies (tocilizumab, methotrexate)\n" +
                        "• Trametinib (shows promise)\n" +
                        "• Laser hair removal for hypertrichosis\n" +
                        "• Genetic counseling for family\n" +
                        "• Multidisciplinary care",
            keyFeatures = "🔬 The 'H' Features:\n" +
                          "1. H yperpigmentation\n" +
                          "2. H ypertrichosis\n" +
                          "3. H epatosplenomegaly\n" +
                          "4. H ypogonadism\n" +
                          "5. H earing loss\n" +
                          "6. H eart abnormalities\n" +
                          "7. Genetic: SLC29A3 mutation"
        };

        diseaseLibrary[3] = new DiseaseEntry
        {
            title = "Spinocerebellar Ataxia Type 15",
            type = "Uncommon",
            category = "Genetic - Autosomal Dominant",
            description = "A rare hereditary neurodegenerative disorder affecting the cerebellum. First reported case in Asia (Philippines). Characterized by progressive ataxia and cerebellar atrophy.",
            symptoms = "• Progressive gait ataxia (difficulty walking)\n" +
                       "• Dysarthria (slurred speech)\n" +
                       "• Intention tremors\n" +
                       "• Dysmetria on finger-to-nose testing\n" +
                       "• Saccadic eye movements\n" +
                       "• Age of onset: 20-40 years\n" +
                       "• Slowly progressive course",
            pathology = "Mutations in the ITPR1 gene (inositol 1,4,5-trisphosphate receptor type 1). This gene plays a critical role in calcium signaling in Purkinje cells of the cerebellum. Dysfunction leads to progressive cerebellar degeneration.",
            treatment = "• No curative treatment available\n" +
                        "• Physical therapy for gait and balance\n" +
                        "• Occupational therapy for activities of daily living\n" +
                        "• Speech therapy for dysarthria\n" +
                        "• Genetic counseling for family members\n" +
                        "• Multidisciplinary supportive care",
            keyFeatures = "🔬 Diagnostic Clues:\n" +
                          "• Autosomal dominant inheritance pattern\n" +
                          "• Bilateral cerebellar atrophy on MRI\n" +
                          "• ITPR1 gene mutation\n" +
                          "• Normal life expectancy (slowly progressive)"
        };

        diseaseLibrary[4] = new DiseaseEntry
        {
            title = "Wolfram Syndrome",
            type = "Uncommon",
            category = "Genetic - Autosomal Recessive",
            description = "A rare genetic disorder also known as DIDMOAD. Characterized by the combination of diabetes mellitus and optic atrophy. First confirmed case in the Philippines.",
            symptoms = "• Type 1 Diabetes Mellitus (juvenile-onset)\n" +
                       "• Bilateral Optic Atrophy (progressive vision loss)\n" +
                       "• Diabetes Insipidus (excessive thirst and urination)\n" +
                       "• Sensorineural Hearing Loss\n" +
                       "• Neurological symptoms (ataxia, nystagmus)\n" +
                       "• Urinary tract abnormalities",
            pathology = "Mutations in the WFS1 gene encoding wolframin, a protein involved in endoplasmic reticulum function. ER dysfunction leads to apoptosis of pancreatic beta cells and optic nerve degeneration.",
            treatment = "• Insulin for Diabetes Mellitus\n" +
                        "• Desmopressin for Diabetes Insipidus\n" +
                        "• Vision support and low-vision services\n" +
                        "• Hearing assessment and aids\n" +
                        "• Genetic counseling for family\n" +
                        "• Multidisciplinary care: Endocrinology, Ophthalmology, ENT",
            keyFeatures = "🔬 DIDMOAD Acronym:\n" +
                          "• D iabetes Insipidus\n" +
                          "• D iabetes Mellitus\n" +
                          "• O ptic Atrophy\n" +
                          "• A uditory (Deafness)\n" +
                          "• Genetic: WFS1 gene\n" +
                          "• Autosomal recessive inheritance"
        };

        diseaseLibrary[5] = new DiseaseEntry
        {
            title = "Schistosomiasis Japonica",
            type = "Uncommon",
            category = "Infectious - Parasitic",
            description = "A parasitic infection caused by Schistosoma japonicum, endemic in the Philippines. Acquired through skin contact with freshwater containing infective cercariae. An ongoing public health concern in selected communities.",
            symptoms = "• Chronic abdominal pain (months to years)\n" +
                       "• Blood in stool (intermittent)\n" +
                       "• Fatigue and weakness\n" +
                       "• Weight loss\n" +
                       "• Hepatosplenomegaly\n" +
                       "• Portal hypertension (advanced disease)\n" +
                       "• Fever and rash (acute phase)",
            pathology = "Cercariae penetrate intact skin, transform into schistosomulae, and migrate through the circulatory system to the portal venous system. Adults mate and produce eggs, which can cause granulomatous inflammation in the liver and intestines.",
            treatment = "• Praziquantel (specific anti-parasitic therapy)\n" +
                        "• Stool examination for diagnosis\n" +
                        "• Household screening and treatment\n" +
                        "• Community-based control programs\n" +
                        "• Prevention: avoid unprotected freshwater contact\n" +
                        "• Public health referral and surveillance",
            keyFeatures = "🔬 Endemic Philippines:\n" +
                          "• Acquired through freshwater exposure\n" +
                          "• Human and animal reservoirs\n" +
                          "• Chronic infection → liver fibrosis\n" +
                          "• Active DOH surveillance (2020-2024)\n" +
                          "• Community health programs available"
        };

        // Add a 6th uncommon case if you have one
        // (Currently you have 5 uncommon + 2 common = 7 total)
        // If you need exactly 5 total, remove one common case
    }

    private void ShowDisease(DiseaseEntry disease)
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
    }

    private void UpdateReadingPanel(string newTitle, string newDetails)
    {
        if (titleText != null) titleText.text = newTitle;
        if (detailsText != null) detailsText.text = newDetails;
    }

    private void UpdateCaseCounter()
    {
        if (caseCounterText != null)
        {
            caseCounterText.text = $"Disease {currentCaseIndex + 1} of {diseaseLibrary.Length}";
        }
        if (progressSlider != null)
        {
            progressSlider.value = (float)(currentCaseIndex + 1) / diseaseLibrary.Length;
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