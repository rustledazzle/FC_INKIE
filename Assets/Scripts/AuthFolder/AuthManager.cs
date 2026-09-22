using UnityEngine;
using Firebase;
using Firebase.Auth;
using TMPro;
using UnityEngine.SceneManagement;
using Firebase.Extensions;

public class AuthManager : MonoBehaviour
{
    private FirebaseAuth auth;

    [Header("UI References")]
    public TMP_InputField emailInput;
    public TMP_InputField passwordInput;
    public TMP_Text feedbackText;

    void Start()
    {
        FirebaseApp.CheckAndFixDependenciesAsync().ContinueWithOnMainThread(task => {
            var dependencyStatus = task.Result;
            if (dependencyStatus == DependencyStatus.Available)
            {
                InitializeFirebase();
            }
            else
            {
                Debug.LogError("Could not resolve all Firebase dependencies: " + dependencyStatus);
            }
        });
    }

    private void InitializeFirebase()
    {
        auth = FirebaseAuth.DefaultInstance;
        Debug.Log("Firebase Auth is initialized and ready!");
    }

    // 1. Register a new user account
    public void RegisterButton()
    {
        string email = emailInput.text;
        string password = passwordInput.text;

        auth.CreateUserWithEmailAndPasswordAsync(email, password).ContinueWithOnMainThread(task => {
            if (task.IsFaulted)
            {
                Debug.LogError("Registration failed: " + task.Exception.GetBaseException().Message);
                feedbackText.text = "Registration failed. Check email or password length.";
                return;
            }

            AuthResult result = task.Result;
            Debug.LogFormat("Firebase user created successfully: {0} ({1})", result.User.DisplayName, result.User.UserId);
            feedbackText.text = "Account created successfully!";

            SceneManager.LoadScene("MenuScene");
        });
    }

    // 2. Log in an existing user
    public void LoginButton()
    {
        string email = emailInput.text;
        string password = passwordInput.text;

        auth.SignInWithEmailAndPasswordAsync(email, password).ContinueWithOnMainThread(task => {
            if (task.IsFaulted)
            {
                Debug.LogError("Login failed: " + task.Exception.GetBaseException().Message);
                feedbackText.text = "Login failed. Invalid email or password.";
                return;
            }

            AuthResult result = task.Result;
            Debug.LogFormat("User signed in successfully: {0} ({1})", result.User.Email, result.User.UserId);
            feedbackText.text = "Logged in successfully! Loading game...";

            SceneManager.LoadScene("MenuScene");
        });
    }

    // 3. Show Password
    public void ShowPassword()
    {
        if (passwordInput != null)
        {
            passwordInput.contentType = TMP_InputField.ContentType.Standard;
            passwordInput.ForceLabelUpdate();
        }
    }

    // 4. Hide Password
    public void HidePassword()
    {
        if (passwordInput != null)
        {
            passwordInput.contentType = TMP_InputField.ContentType.Password;
            passwordInput.ForceLabelUpdate();
        }
    }
}