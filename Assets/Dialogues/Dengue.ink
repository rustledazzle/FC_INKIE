// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Alex (Patient) Sprites:
//   Tired/Flushed = Alex_Dengue_0
//   Lethargic = Alex_Dengue_1
//   Relieved = Alex_Dengue_2
//   Hopeful = Alex_Dengue_3
//
// Marlie (Mother) Sprites:
//   Anxious = Marlie_Dengue_0
//   Defensive = Marlie_Dengue_1
//   Relieved = Marlie_Dengue_2
//   Crying/Desperate = Marlie_Dengue_3
//
// Close-Up Images:
//   Flushed Face = Alex_Dengue_Closeup_0
//   Skin Rash = Alex_Dengue_Closeup2_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic room is warm. It has been raining for weeks. Alex, a 7-year-old boy, enters with his mother, Marlie. Alex looks flushed and tired. He is holding his head. Marlie looks anxious, holding a small bag of medical records.

# closeup: Alex_Dengue_Closeup_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Alex closely. His face is flushed. He has a rash—infrequent bumps scattered on his body. He looks lethargic.

# closeup: Alex_Dengue_Closeup2_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You examine the rash more closely. Small, red, blanching maculopapular lesions are visible on his arm and torso.

# speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
"Good day, Doc. Alex has been having a high fever for days now. It hasn't gone down since it started. I'm getting worried."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You take Alex's temperature. It is 39.5°C. You note the fever has been ongoing for 3 days. Marlie mentions that Alex has been lethargic and not eating well. She reports no vomiting, but Alex has been complaining of body aches. She mentions that there are dengue cases in their community.

# speaker: Alex # portrait_left: Clear # portrait_right: Alex_Dengue_0
"Doc... masakit ang ulo ko... at ang katawan ko... parang ayaw kong gumalaw..."

# speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
"Doc, natatakot ako. Marami kasing bata sa amin ang may dengue. Yung kapitbahay namin, na-confine. Ayokong mangyari iyon kay Alex."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Alex is febrile and lethargic. Marlie is anxious. Your approach will determine whether she trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Marlie, let's focus on Alex's symptoms. When exactly did the fever start? Is it continuous? Has Alex had any vomiting or nosebleeds? Any difficulty breathing?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marlie answers your questions, but she seems rushed. She provides clinical facts but does not elaborate. Alex lies quietly on the examination bed.

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Yung lagnat, tatlong araw na. Hindi bumababa kahit bigyan ko ng gamot. Wala namang pagsusuka. Wala ring nosebleed. Pero sobrang lalata niya. Ayaw kumain."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Marlie feels like she's being processed.
    -> information_gathering

* [Choice B: Focus on Marlie's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Marlie, I can see how worried you are. You mentioned there are dengue cases in your community. That must be very scary. Can you tell me more about what's been happening at home? How are you coping?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marlie's shoulders relax slightly. Her eyes well up. She looks relieved that someone is listening.

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Doc, natatakot ako. Marami kasing bata sa amin ang may dengue. Yung kapitbahay namin, na-confine. Ayokong mangyari iyon kay Alex. Wala akong tulong sa bahay. Ako lang ang nag-aalaga sa kanya."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Marlie feels heard and understood.
    -> information_gathering

* [Choice C: Focus on Warning Signs Immediately]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Marlie, I need to check for danger signs. Has Alex had any severe stomach pain? Persistent vomiting? Bleeding from his gums or nose? Any blood in his stool?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marlie becomes anxious and defensive.

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_3
    "Doc! Bakit niyo po tinatanong iyan? Hindi naman siya nagdurugo! Yung lagnat lang po ang problema niya!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but mother feels alarmed. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Alex has been febrile for 3 days with body aches, lethargy, and poor appetite. Marlie has provided initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about warning signs: severe abdominal pain, persistent vomiting, bleeding]
    ~ info_score += 2
    "Marlie, I need to check for specific warning signs. Has Alex had any severe stomach pain? Persistent vomiting? Any bleeding from his gums or nose? Blood in his vomit or stool?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Wala naman pong matinding sakit ng tiyan. Hindi naman siya nagsusuka. Wala ring dugo. Pero yung lagnat, hindi talaga bumababa."

    -> information_gathering_2

* [Ask about rash characteristics and appearance]
    ~ info_score += 2
    "Marlie, can you tell me about the rash on Alex's body? When did it appear? Is it flat or raised? Does it blanch when you press on it?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Kagabi lang po lumabas. Parang maliliit na butlig. Namumula ang balat niya. Hindi ko alam kung namumutla kapag pinindot."

    -> information_gathering_2

* [Ask about fluid intake and urine output]
    ~ info_score += 2
    "Marlie, how much has Alex been drinking? When was the last time he urinated? Is he able to keep fluids down?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Mahirap po siyang painumin. Konti lang ang iniinom niya. Kaninang umaga pa siya hindi umiihi. Natatakot ako."

    -> information_gathering_2

* [Ask about community context and mosquito exposure]
    ~ info_score += 1
    "Marlie, you mentioned there are dengue cases in your community. Can you tell me more about that? Are there mosquitoes around your home?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Marami pong lamok sa amin. Yung tubig sa mga paso at lalagyan, hindi namin natatakpan. Yung kapitbahay namin, dalawang bata ang na-dengue."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about activity level and responsiveness]
    ~ info_score += 1
    "Marlie, how is Alex's activity level? Is he responsive? Is he able to walk or play?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Sobrang lalata po niya. Kanina, hinihila ko siya para umupo, pero ayaw niyang gumalaw. Parang walang lakas."

    -> diagnosis_phase

* [Ask about previous medical history and medications]
    ~ info_score += 1
    "Marlie, does Alex have any other medical conditions? Has he been taking any medications for the fever?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Wala naman pong ibang sakit si Alex. Nagbibigay ako ng paracetamol, pero hindi bumababa ang lagnat."

    -> diagnosis_phase

* [Ask about health literacy and understanding of dengue]
    ~ info_score += 1
    "Marlie, what do you know about dengue? What have you heard about how it's treated?"

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Ang alam ko po, galing sa lamok. Nakakamatay daw. Pero hindi ko alam kung paano gamutin. Sabi ng iba, painumin daw ng maraming tubig."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Alex has:
- Fever for 3 days, temperature 39.5°C
- Flushed face, maculopapular rash
- Body aches, lethargy, poor appetite
- No vomiting, no bleeding, no severe abdominal pain
- Decreased urine output, poor fluid intake
- Lives in a community with known dengue cases

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Dengue Fever (Without Warning Signs)]
    ~ clinical_score = 5
    "Marlie, I believe Alex has Dengue Fever. The high fever for 3 days, the rash, the body aches, and the lethargy are all classic signs. He does not have any warning signs right now, which is good. But we need to do a complete blood count to check his platelet count and monitor him closely."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Doc... kailangan po bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Not necessarily. If his platelet count is stable and he has no warning signs, we can manage him at home with plenty of fluids and close monitoring. But we need to do the blood test first to be sure."

    -> management_phase

* [Choice B: Severe Dengue]
    ~ clinical_score = 2
    "Marlie, this could be severe dengue. Alex needs to be admitted immediately for IV fluids and close monitoring."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Doc... ganun ba kalala? Wala naman siyang bleeding o matinding sakit ng tiyan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have over-diagnosed. Alex has no warning signs or severe features. He has dengue without warning signs, which can be managed as an outpatient.
    -> management_phase

* [Choice C: Simple Viral Fever]
    ~ clinical_score = 1
    "This is likely just a simple viral fever. Give him paracetamol and fluids. Come back if it gets worse."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_0
    "Doc... pero may dengue po sa amin. At may rash siya. Hindi ba dapat i-test?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key clues: the rash, the community context, and the ongoing high fever. This is dengue until proven otherwise.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Order CBC + Home Monitoring + Fluids + Follow-up]
    ~ safety_score = 5
    "Marlie, I'm going to order a complete blood count to check Alex's platelet count. In the meantime, give him plenty of fluids—water, juice, or oral rehydration solution. Give paracetamol for the fever. Do not give aspirin or ibuprofen. Monitor his temperature and watch for warning signs: severe stomach pain, persistent vomiting, bleeding gums or nose, blood in his stool, or if he stops urinating for 6 hours. If any of these happen, bring him back immediately or go to the ER."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_2
    "Salamat, Doc. Ano po ang mga warning signs na dapat kong bantayan?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Severe stomach pain, persistent vomiting, bleeding gums or nose, blood in his vomit or stool, or if he doesn't urinate for 6 hours. These are danger signs. Also, bring him back in 2 days for a follow-up blood test."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marlie nods, understanding the plan.

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_2
    "Salamat, Doc. May gagawin na ako."
    -> ending

* [Choice B: Admit to Hospital Immediately]
    ~ safety_score = 3
    "Marlie, I'm going to admit Alex to the hospital for IV fluids and monitoring. This is the safest option."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_3
    "Doc! Hindi ko po kaya. Wala akong kasama sa bahay. At wala naman siyang bleeding o matinding sakit ng tiyan!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated without clear indication. Alex has dengue without warning signs. He can be managed as an outpatient with close follow-up.
    -> ending

* [Choice C: Send Home with Paracetamol Only]
    ~ safety_score = 1
    "Just give him paracetamol and fluids. Come back if it gets worse."

    # speaker: Marlie # portrait_left: Clear # portrait_right: Marlie_Dengue_3
    "Doc! Hindi po bumababa ang lagnat niya! At may dengue sa amin! Paano kung lumala siya?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed the possibility of dengue. Without a CBC and clear follow-up instructions, you cannot monitor for warning signs. This is unsafe.
    -> ending


// --- SCENE 7: ENDING & FEEDBACK ---
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
    - clinical_score == 5 and empathy_score == 5 and safety_score == 5:
        "Excellent work! You recognized Dengue Fever without warning signs, addressed Marlie's fears with empathy, ordered the appropriate test (CBC), and provided clear home monitoring instructions. Children aged 14 and below account for 56% of dengue cases in the Philippines—your prompt recognition and safe management will prevent complications."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and safe management plan, but Marlie left feeling rushed. Remember to listen to the mother's concerns—she is the best observer of her child's condition."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Dengue Fever but failed to provide comprehensive care. CBC, home monitoring instructions, and clear warning signs are essential for safe outpatient management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: high fever for 2-7 days plus rash plus body aches plus community context equals suspect Dengue."
    - clinical_score < 5:
        "You misdiagnosed Alex's condition. Dengue is endemic in the Philippines. Always consider dengue in a child with high fever, rash, and body aches, especially during the rainy season."
    - else:
        "Keep practicing! Dengue requires early recognition and close monitoring. Remember the warning signs: severe abdominal pain, persistent vomiting, bleeding, and decreased urine output."
}

-> END