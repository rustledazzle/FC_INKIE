using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    [Header("First Contact Metrics")]
    public int clinicalReasoningScore = 0;
    public int informationGatheringScore = 0;
    public int empathyTrustScore = 0;
    public int patientSafetyScore = 0;
    public string trustLevel = "NEUTRAL";

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // Persist across scene transitions
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void UpdateMetrics(int clinical, int info, int empathy, int safety, string trust)
    {
        clinicalReasoningScore = clinical;
        informationGatheringScore = info;
        empathyTrustScore = empathy;
        patientSafetyScore = safety;
        trustLevel = trust;

        Debug.Log($"[Metrics Updated] Trust: {trustLevel} | Empathy: {empathyTrustScore}/5 | Safety: {patientSafetyScore}/5");
    }
}