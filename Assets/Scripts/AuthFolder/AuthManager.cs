using System.Collections.Generic;
using UnityEngine;
using Firebase;
using Firebase.Auth;
using Firebase.Firestore;
using TMPro;
using UnityEngine.SceneManagement;
using Firebase.Extensions;

public class AuthManager : MonoBehaviour
{
    private FirebaseAuth auth;

    [Header("Main Login UI References")]
    public TMP_InputField emailInput;
    public TMP_InputField passwordInput;
    public TMP_Text feedbackText;
    public Color errorColor = Color.red;

    [Header("Guest Popup Panel UI References")]
    public GameObject guestPanel;
    public TMP_InputField usernameInput;
    public TMP_Text guestFeedbackText;

    private Color defaultFeedbackColor = Color.white;
    private Color defaultGuestFeedbackColor = Color.white;

    // All badge keys used in your game so we can reset/sync them cleanly per account
    private readonly string[] allBadgeKeys = new string[]
    {
        "Badge_Tutorial",
        "Badge_PerfectStage1",
        "Badge_PerfectEmpathy",
        "Badge_PerfectSafety",
        "Badge_OutstandingGrade",
        "Badge_NoCaseFile",
        "Badge_ChiefResident",
        "Badge_SpecialCases"
    };

    // Updated to match your exact Firestore stage prefixes!
    private readonly string[] allStagePrefixes = new string[]
    {
        "Stage1_Morning",
        "Stage1_Afternoon",
        "SpecialCases",
        "Stage4"
    };

    void Start()
    {
        if (feedbackText != null)
        {
            defaultFeedbackColor = feedbackText.color;
        }
        if (guestFeedbackText != null)
        {
            defaultGuestFeedbackColor = guestFeedbackText.color;
        }

        if (guestPanel != null)
        {
            guestPanel.SetActive(false);
        }

        FirebaseApp.CheckAndFixDependenciesAsync().ContinueWithOnMainThread(task => {
            var dependencyStatus = task.Result;
            if (dependencyStatus == DependencyStatus.Available)
            {
                InitializeFirebase();
            }
            else
            {
                Debug.LogError("Could not resolve all Firebase dependencies: " + dependencyStatus);
                ShowFeedback("System Error: Could not connect to services.", true);
            }
        });
    }

    private void InitializeFirebase()
    {
        auth = FirebaseAuth.DefaultInstance;
        Debug.Log("Firebase Auth is initialized and ready!");
    }

    private void ShowFeedback(string message, bool isError = false)
    {
        if (feedbackText != null)
        {
            feedbackText.text = message;
            feedbackText.color = isError ? errorColor : defaultFeedbackColor;
        }

        if (guestFeedbackText != null)
        {
            guestFeedbackText.text = message;
            guestFeedbackText.color = isError ? errorColor : defaultGuestFeedbackColor;
        }
    }

    // =========================================================================
    // GUEST PANEL OPEN / CLOSE BUTTONS
    // =========================================================================
    public void OpenGuestPanel()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        ShowFeedback("", false);

        if (guestPanel != null)
        {
            guestPanel.SetActive(true);
        }
    }

    public void CloseGuestPanel()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();
        ShowFeedback("", false);

        if (guestPanel != null)
        {
            guestPanel.SetActive(false);
        }
    }

    // =========================================================================
    // 1. GUEST PROCEED BUTTON (Inside the Guest Popup Panel)
    // =========================================================================
    public void GuestLoginButton()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        string guestName = usernameInput != null ? usernameInput.text.Trim() : "";

        if (string.IsNullOrEmpty(guestName))
        {
            ShowFeedback("Please enter your name to proceed.", true);
            return;
        }

        ShowFeedback($"Welcome, {guestName}! Loading profile...", false);

        string guestDocId = "Guest_" + guestName.ToLower();
        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;

        // 1. Check if this name belongs to a password-protected Registered user
        db.Collection("Users")
          .WhereEqualTo("UsernameLower", guestName.ToLower())
          .WhereEqualTo("IsGuest", false)
          .Limit(1)
          .GetSnapshotAsync()
          .ContinueWithOnMainThread(checkTask => {
              if (checkTask.IsCompleted && !checkTask.IsFaulted && checkTask.Result.Count > 0)
              {
                  ShowFeedback("This name belongs to a registered account. Please log in with your password.", true);
                  return;
              }

              // 2. Proceed with Guest Document check/creation
              auth.SignInAnonymouslyAsync().ContinueWithOnMainThread(authTask => {
                  CheckOrCreateGuestDocument(db, guestDocId, guestName);
              });
          });
    }

    private void CheckOrCreateGuestDocument(FirebaseFirestore db, string guestDocId, string guestName)
    {
        db.Collection("Users").Document(guestDocId).GetSnapshotAsync().ContinueWithOnMainThread(docTask => {
            if (docTask.IsCompleted && !docTask.IsFaulted && docTask.Result.Exists)
            {
                ShowFeedback($"Welcome back, {guestName}! Syncing saved progress...", false);
                SyncUserDataFromCloud(guestDocId, guestName, "", true);
            }
            else
            {
                ResetLocalGameplayProgress();
                PlayerPrefs.SetString("PlayerName", guestName);
                PlayerPrefs.SetString("ActiveDocumentId", guestDocId);
                PlayerPrefs.Save();

                Dictionary<string, object> guestData = new Dictionary<string, object>
                {
                    { "Username", guestName },
                    { "UsernameLower", guestName.ToLower() },
                    { "IsGuest", true },
                    { "HighestUnlockedLevel", 0 },
                    { "LastActive", FieldValue.ServerTimestamp }
                };

                db.Collection("Users").Document(guestDocId).SetAsync(guestData, SetOptions.MergeAll)
                  .ContinueWithOnMainThread(saveTask => {
                      SceneManager.LoadScene("MenuScene");
                  });
            }
        });
    }

    // =========================================================================
    // 2. REGISTER NEW ACCOUNT (Main Login Screen)
    // =========================================================================
    public void RegisterButton()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        string email = emailInput != null ? emailInput.text.Trim() : "";
        string password = passwordInput != null ? passwordInput.text : "";

        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            ShowFeedback("Please enter both an email and password.", true);
            return;
        }

        string username = email.Contains("@") ? email.Split('@')[0] : email;

        ShowFeedback("Creating account...", false);

        auth.CreateUserWithEmailAndPasswordAsync(email, password).ContinueWithOnMainThread(task => {
            if (task.IsFaulted)
            {
                Debug.LogError("Registration failed: " + task.Exception.GetBaseException().Message);
                ShowFeedback("Registration failed. Check email or password length (6+ chars).", true);
                return;
            }

            AuthResult result = task.Result;
            ShowFeedback("Account created successfully!", false);

            ResetLocalGameplayProgress();
            PlayerPrefs.SetString("PlayerName", username);
            PlayerPrefs.SetString("ActiveDocumentId", result.User.UserId);
            PlayerPrefs.Save();

            FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
            Dictionary<string, object> newUserData = new Dictionary<string, object>
            {
                { "Username", username },
                { "UsernameLower", username.ToLower() },
                { "Email", email },
                { "IsGuest", false },
                { "HighestUnlockedLevel", 0 },
                { "LastActive", FieldValue.ServerTimestamp }
            };

            db.Collection("Users").Document(result.User.UserId)
              .SetAsync(newUserData, SetOptions.MergeAll)
              .ContinueWithOnMainThread(saveTask => {
                  SceneManager.LoadScene("MenuScene");
              });
        });
    }

    // =========================================================================
    // 3. LOGIN (Main Login Screen - Works with Email OR Username + Password)
    // =========================================================================
    public void LoginButton()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        string loginIdentifier = emailInput != null ? emailInput.text.Trim() : "";
        string password = passwordInput != null ? passwordInput.text : "";

        if (string.IsNullOrEmpty(loginIdentifier) || string.IsNullOrEmpty(password))
        {
            ShowFeedback("Please enter your Email/Username and Password.", true);
            return;
        }

        ShowFeedback("Logging in...", false);

        if (loginIdentifier.Contains("@"))
        {
            SignInWithEmail(loginIdentifier, password);
        }
        else
        {
            FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
            db.Collection("Users")
              .WhereEqualTo("UsernameLower", loginIdentifier.ToLower())
              .WhereEqualTo("IsGuest", false)
              .Limit(1)
              .GetSnapshotAsync()
              .ContinueWithOnMainThread(queryTask => {
                  if (queryTask.IsFaulted || queryTask.IsCanceled)
                  {
                      ShowFeedback("Could not verify username. Try logging in with your email.", true);
                      return;
                  }

                  foreach (DocumentSnapshot doc in queryTask.Result.Documents)
                  {
                      if (doc.ContainsField("Email"))
                      {
                          string foundEmail = doc.GetValue<string>("Email");
                          SignInWithEmail(foundEmail, password);
                          return;
                      }
                  }

                  ShowFeedback("Account not found. Please log in with your email once first, or use Guest Login.", true);
              });
        }
    }

    private void SignInWithEmail(string email, string password)
    {
        auth.SignInWithEmailAndPasswordAsync(email, password).ContinueWithOnMainThread(task => {
            if (task.IsFaulted)
            {
                Debug.LogError("Login failed: " + task.Exception.GetBaseException().Message);
                ShowFeedback("Login failed. Invalid email or password.", true);
                return;
            }

            AuthResult result = task.Result;
            ShowFeedback("Logged in! Syncing cloud data...", false);

            string emailPrefix = email.Contains("@") ? email.Split('@')[0] : email;
            SyncUserDataFromCloud(result.User.UserId, emailPrefix, email, false);
        });
    }

    private void ResetLocalGameplayProgress()
    {
        PlayerPrefs.DeleteKey("PlayerName");
        PlayerPrefs.SetInt("UnlockedStageLevel", 0);

        foreach (string badgeKey in allBadgeKeys)
        {
            PlayerPrefs.SetInt(badgeKey, 0);
        }

        foreach (string prefix in allStagePrefixes)
        {
            PlayerPrefs.DeleteKey(prefix + "_Clinical");
            PlayerPrefs.DeleteKey(prefix + "_Info");
            PlayerPrefs.DeleteKey(prefix + "_Empathy");
            PlayerPrefs.DeleteKey(prefix + "_Safety");
        }

        if (GameManager.Instance != null)
        {
            GameManager.Instance.hasCompletedTutorial = false;
        }

        PlayerPrefs.Save();
    }

    private void SyncUserDataFromCloud(string documentId, string fallbackName = "", string userEmail = "", bool isGuest = false)
    {
        ResetLocalGameplayProgress();

        PlayerPrefs.SetString("ActiveDocumentId", documentId);
        if (!string.IsNullOrEmpty(fallbackName))
        {
            PlayerPrefs.SetString("PlayerName", fallbackName);
        }
        PlayerPrefs.Save();

        FirebaseFirestore db = FirebaseFirestore.DefaultInstance;
        db.Collection("Users").Document(documentId).GetSnapshotAsync().ContinueWithOnMainThread(task =>
        {
            if (task.IsCompleted && !task.IsFaulted)
            {
                DocumentSnapshot snapshot = task.Result;
                string finalUsername = fallbackName;

                if (snapshot.Exists)
                {
                    int cloudLevel = 0;

                    if (snapshot.ContainsField("Username"))
                    {
                        finalUsername = snapshot.GetValue<string>("Username");
                        PlayerPrefs.SetString("PlayerName", finalUsername);
                    }

                    if (snapshot.ContainsField("HighestUnlockedLevel"))
                    {
                        cloudLevel = snapshot.GetValue<int>("HighestUnlockedLevel");
                        PlayerPrefs.SetInt("UnlockedStageLevel", cloudLevel);
                    }

                    bool tutorialDone = cloudLevel > 0 ||
                                        (snapshot.ContainsField("TutorialCompleted") && snapshot.GetValue<bool>("TutorialCompleted"));

                    if (snapshot.ContainsField("Badges"))
                    {
                        Dictionary<string, object> badgesMap = snapshot.GetValue<Dictionary<string, object>>("Badges");
                        foreach (var kvp in badgesMap)
                        {
                            if (kvp.Value is bool isUnlocked && isUnlocked)
                            {
                                PlayerPrefs.SetInt(kvp.Key, 1);
                                if (kvp.Key == "Badge_Tutorial") tutorialDone = true;
                            }
                        }
                    }

                    if (tutorialDone)
                    {
                        PlayerPrefs.SetInt("Badge_Tutorial", 1);
                        if (GameManager.Instance != null) GameManager.Instance.hasCompletedTutorial = true;
                    }
                    if (cloudLevel >= 4)
                    {
                        PlayerPrefs.SetInt("Badge_ChiefResident", 1);
                    }

                    foreach (string prefix in allStagePrefixes)
                    {
                        if (snapshot.ContainsField(prefix))
                        {
                            Dictionary<string, object> stageMap = snapshot.GetValue<Dictionary<string, object>>(prefix);

                            int c = stageMap.ContainsKey("ClinicalReasoning") ? System.Convert.ToInt32(stageMap["ClinicalReasoning"]) : 0;
                            int i = stageMap.ContainsKey("InformationGathering") ? System.Convert.ToInt32(stageMap["InformationGathering"]) : 0;
                            int e = stageMap.ContainsKey("Empathy") ? System.Convert.ToInt32(stageMap["Empathy"]) : 0;
                            int s = stageMap.ContainsKey("PatientSafety") ? System.Convert.ToInt32(stageMap["PatientSafety"]) : 0;

                            PlayerPrefs.SetInt(prefix + "_Clinical", c);
                            PlayerPrefs.SetInt(prefix + "_Info", i);
                            PlayerPrefs.SetInt(prefix + "_Empathy", e);
                            PlayerPrefs.SetInt(prefix + "_Safety", s);

                            int total = c + i + e + s;

                            PlayerPrefs.SetInt("Badge_Tutorial", 1);

                            if (e >= 5) PlayerPrefs.SetInt("Badge_PerfectEmpathy", 1);
                            if (s >= 5) PlayerPrefs.SetInt("Badge_PerfectSafety", 1);
                            if (total >= 18) PlayerPrefs.SetInt("Badge_OutstandingGrade", 1);

                            if (prefix == "Stage1_Morning" && total >= 20)
                            {
                                PlayerPrefs.SetInt("Badge_PerfectStage1", 1);
                            }

                            if (prefix == "SpecialCases" || prefix == "SpecialCase")
                            {
                                PlayerPrefs.SetInt("Badge_SpecialCases", 1);
                            }
                        }
                    }

                    PlayerPrefs.Save();
                }

                Dictionary<string, object> profileAndBadgesUpdate = new Dictionary<string, object>
                {
                    { "LastActive", FieldValue.ServerTimestamp }
                };

                if (!string.IsNullOrEmpty(finalUsername))
                {
                    profileAndBadgesUpdate["Username"] = finalUsername;
                    profileAndBadgesUpdate["UsernameLower"] = finalUsername.ToLower();
                }
                if (!string.IsNullOrEmpty(userEmail))
                {
                    profileAndBadgesUpdate["Email"] = userEmail;
                    profileAndBadgesUpdate["IsGuest"] = false;
                }

                Dictionary<string, object> syncedBadges = new Dictionary<string, object>();
                foreach (string key in allBadgeKeys)
                {
                    if (PlayerPrefs.GetInt(key, 0) == 1)
                    {
                        syncedBadges[key] = true;
                    }
                }
                if (syncedBadges.Count > 0)
                {
                    profileAndBadgesUpdate["Badges"] = syncedBadges;
                }

                db.Collection("Users").Document(documentId).SetAsync(profileAndBadgesUpdate, SetOptions.MergeAll)
                  .ContinueWithOnMainThread(saveTask => {
                      SceneManager.LoadScene("MenuScene");
                  });
            }
            else
            {
                SceneManager.LoadScene("MenuScene");
            }
        });
    }

    public void ShowPassword()
    {
        if (passwordInput != null)
        {
            passwordInput.contentType = TMP_InputField.ContentType.Standard;
            passwordInput.ForceLabelUpdate();
        }
    }

    public void HidePassword()
    {
        if (passwordInput != null)
        {
            passwordInput.contentType = TMP_InputField.ContentType.Password;
            passwordInput.ForceLabelUpdate();
        }
    }

    public void ForgotPasswordButton()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        string email = emailInput != null ? emailInput.text.Trim() : "";

        if (string.IsNullOrEmpty(email) || !email.Contains("@"))
        {
            ShowFeedback("Please enter your valid email address first to reset your password.", true);
            return;
        }

        ShowFeedback("Sending password reset email...", false);

        auth.SendPasswordResetEmailAsync(email).ContinueWithOnMainThread(task => {
            if (task.IsCanceled || task.IsFaulted)
            {
                Debug.LogError("Password reset failed: " + task.Exception?.GetBaseException().Message);
                ShowFeedback("Could not send reset email. Please check if the email is valid.", true);
                return;
            }

            ShowFeedback("Password reset link sent! Please check your email (and Spam folder).", false);
        });
    }

    // =========================================================================
    // 4. QUIT / EXIT GAME (Safe UI Hook)
    // =========================================================================
    public object QuitGame { get; private set; }

    public void QuitGameAction()
    {
        if (AudioManager.Instance != null) AudioManager.Instance.PlayClick();

        Debug.Log("Exiting application...");

        // Closes the application on Android, PC, etc.
        Application.Quit();

        // Stops Play Mode when testing inside the Unity Editor
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }
}