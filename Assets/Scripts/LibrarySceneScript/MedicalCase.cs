using UnityEngine;

[CreateAssetMenu(fileName = "New Medical Case", menuName = "First Contact/Medical Case")]
public class MedicalCase : ScriptableObject
{
    [Header("Visuals")]
    public Sprite caseImage1; 
    public Sprite caseImage2; // Optional second image for the case
    [Header("Basic Info")]
    public string title;
    public string type;          // Common or Uncommon
    public string category;      // Genetic, Vascular, Infectious, etc.

    [Header("Medical Details")]
    [TextArea(3, 5)] public string description;
    [TextArea(3, 5)] public string symptoms;
    [TextArea(3, 5)] public string pathology;
    [TextArea(3, 5)] public string treatment;
    [TextArea(3, 5)] public string keyFeatures;

    [Header("Unlock Condition")]
    [Tooltip("The HighestUnlockedLevel required to view this case.")]
    public int requiredStageLevel = 1;
}