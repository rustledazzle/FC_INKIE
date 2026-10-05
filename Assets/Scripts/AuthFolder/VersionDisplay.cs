using UnityEngine;
using TMPro;

public class VersionDisplay : MonoBehaviour
{
    void Start()
    {
        // Grabs the text component and sets it to the project's current version
        GetComponent<TextMeshProUGUI>().text = "v" + Application.version;
    }
}