// Track player states for First Contact
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

# speaker: Lola Carmen # portrait_right: carmen_angry # portrait_left: clear
"I don't know why my daughter forced me to come here. I just have a headache! I'm not taking any more of those expensive pills!"

# speaker: Player # portrait_left: doctor_neutral

// The player must choose between an Empathy-First or Symptoms-First approach
* [Focus on feelings: Validate her frustration]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "It sounds like you're really frustrated with your medications, Lola Carmen. It must be hard having to take so many pills."
    -> empathy_path
    
* [Focus on symptoms: Ask about the headache]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Lola Carmen, a severe headache can be a sign of high blood pressure. Have you been skipping your medication?"
    -> clinical_path

== empathy_path ==
# speaker: Lola Carmen # portrait_right: carmen_relieved
"Yes, Doc... they are so expensive, and they make me dizzy. I'm just scared because my sister had a stroke last year."
# speaker: Player
"I understand completely. Let's figure out a safe plan that works for your budget and keeps you healthy."
// Reward the player with good secondary scores for choosing empathy
~ clinical_score = 5
~ info_score = 4
~ safety_score = 5
-> END

== clinical_path ==
# speaker: Lola Carmen # portrait_right: carmen_angry
"I already told you, I stopped taking them! You doctors only care about pushing pills. I'm going home."
# speaker: Player
"Wait, we need to check your blood pressure before you leave..."
// Penalize the player for making the patient withdraw
~ clinical_score = 3
~ info_score = 2
~ safety_score = 2
-> END