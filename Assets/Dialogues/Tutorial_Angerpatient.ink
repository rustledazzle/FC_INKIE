// --- FILLER CASE: THE ANGRY PATIENT (LOLA CARMEN) ---
// Full 20/20 Scoring Version - 4 Choices

VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Lola Carmen (Patient) Sprites:
//   ANGRY = carmen_angry
//   NEUTRAL = carmen_neutral
//   RELIEVED = carmen_relieved
//   WORRIED = carmen_worried
//   SAD = carmen_sad
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic is busy. Lola Carmen, a 58-year-old retired teacher, enters slowly. She looks tired and is holding her head. She sits down heavily, sighing. She is alone.

# speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_angry
"I don't know why my daughter forced me to come here. I just have a headache! I'm not taking any more of those expensive pills!"

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Lola Carmen looks flushed. She is slightly overweight. You check her vital signs: Blood Pressure is 165/100 mmHg.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear


// --- DECISION POINT: EMPATHY CHECK (4 CHOICES) ---
* [Choice A: Validate her frustration (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    ~ clinical_score = 4
    ~ info_score = 4
    ~ safety_score = 5
    "It sounds like you're really frustrated with your medications, Lola Carmen. It must be hard having to take so many pills."

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_relieved
    "Yes, Doc... they are so expensive, and they make me dizzy. I'm just scared because my sister had a stroke last year."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "I understand completely. Let's figure out a safe plan that works for your budget and keeps you healthy."

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_relieved
    "Salamat, Doc. Akala ko wala nang pag-asa. Ngayon, may ginagawa na ako para sa sarili ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Lesson: When a patient is angry or frustrated, it's usually about fear, cost, or past experiences—not about you. Validating their feelings first opens the door to trust.

    -> ending

* [Choice B: Ask about her daughter (Social Context)]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    ~ clinical_score = 3
    ~ info_score = 4
    ~ safety_score = 3
    "Lola Carmen, you mentioned your daughter forced you to come. Can you tell me more about that? What is she worried about?"

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_worried
    "My daughter... she's worried because her auntie had a stroke. She thinks I'm going to have one too. But I feel fine!"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "It sounds like she cares about you a lot. Let's check your blood pressure and see if we can ease her worries."

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_neutral
    "Sige, Doc. Kung iyon lang naman."

    -> ending

* [Choice C: Focus on symptoms immediately (Symptoms First)]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    ~ clinical_score = 2
    ~ info_score = 2
    ~ safety_score = 2
    "Lola Carmen, a severe headache can be a sign of high blood pressure. Have you been skipping your medication?"

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_angry
    "I already told you, I stopped taking them! You doctors only care about pushing pills. I'm going home."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Wait, we need to check your blood pressure before you leave..."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Lola Carmen stands up and walks out of the clinic. You have lost the opportunity to help her.

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Lesson: Pushing medical advice without first addressing a patient's fears or concerns can damage trust and cause them to withdraw. Always listen first.

    -> ending

* [Choice D: Ask about the cost of her medications (Pragmatic)]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 4
    ~ clinical_score = 4
    ~ info_score = 3
    ~ safety_score = 4
    "Lola Carmen, you mentioned the pills are expensive. Can you tell me more about that? Is cost a barrier for you?"

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_sad
    "Opo, Doc. Mahal ang gamot. Wala akong trabaho ngayon. At hindi ko alam kung saan ako kukuha ng pera. Kaya tumigil na lang ako."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Lola Carmen, mayroon tayong programa sa PhilHealth na tumutulong sa mga pasyenteng may hypertension. Hindi mo kailangang magbayad nang malaki. Pag-usapan natin iyon."

    # speaker: Lola Carmen # portrait_left: Clear # portrait_right: carmen_relieved
    "Talaga, Doc? Salamat. Akala ko wala nang pag-asa."

    -> ending


// --- SCENE 2: ENDING & FEEDBACK ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. The patient leaves the clinic.

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
--------------------------------------------------
PERFORMANCE SUMMARY
--------------------------------------------------
Clinical Reasoning: {clinical_score}/5
Information Gathering: {info_score}/5
Empathy & Trust: {empathy_score}/5
Patient Safety: {safety_score}/5
--------------------------------------------------
TOTAL SCORE: {clinical_score + info_score + empathy_score + safety_score}/20
--------------------------------------------------

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
{
    - clinical_score >= 4 and empathy_score == 5 and safety_score >= 4:
        "Excellent! You validated Lola Carmen's frustration and built trust. She is now more likely to listen to your advice. This is the GOLDEN PATH for difficult patients."
    - empathy_score == 5:
        "You built trust with Lola Carmen by validating her feelings. She felt heard and is open to your advice."
    - empathy_score == 4:
        "You addressed her practical concerns about cost. Lola Carmen appreciated your practical help."
    - empathy_score == 3:
        "You acknowledged her daughter's concern. Lola Carmen felt somewhat heard but remains guarded."
    - empathy_score == 2:
        "Lola Carmen felt judged and walked out. Remember: empathy is the first step to any successful consultation. When a patient is angry, validate their feelings before addressing the medical issue."
    - else:
        "Keep practicing! Empathy is a skill that improves with repetition. Try to see the patient's perspective before offering medical advice."
}

-> END