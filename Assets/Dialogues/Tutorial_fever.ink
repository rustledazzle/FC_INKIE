// Track player states for First Contact
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0
VAR questions_asked = 0

# speaker: Mang Jose # portrait_right: jose_neutral # portrait_left: clear
"Good morning, Doc. I've been having this really bad fever for a few days now."

# speaker: Player # portrait_left: doctor_neutral
-> question_hub

== question_hub ==
// If the player asks 3 questions, the story moves on automatically.
{ questions_asked == 3:
    -> conclusion
}

+ [Ask about onset and duration]
    ~ info_score += 2
    ~ questions_asked += 1
    "When exactly did the fever start, and is it continuous?"
    # speaker: Mang Jose
    "It started three days ago. It goes away when I take medicine but comes right back."
    # speaker: Player
    -> question_hub

+ [Ask about associated symptoms]
    ~ info_score += 2
    ~ questions_asked += 1
    "Do you have any other symptoms like a cough, cold, or body aches?"
    # speaker: Mang Jose
    "No cough, but my joints ache a lot, and my eyes hurt when I look around."
    # speaker: Player
    -> question_hub

+ [Ask about environment / social context]
    ~ info_score += 1
    ~ questions_asked += 1
    "Does anyone else in your house have a fever, or are there mosquitoes around?"
    # speaker: Mang Jose
    "My neighbor was just hospitalized for Dengue actually, which got me worried."
    # speaker: Player
    -> question_hub

* [I have enough information to proceed.]
    -> conclusion

== conclusion ==
# speaker: Player
"Thank you for sharing that, Mang Jose. Let's get you tested for Dengue."
// Auto-fill the other scores so the tutorial focuses just on the Info score
~ clinical_score = 5
~ empathy_score = 4
~ safety_score = 5
-> END