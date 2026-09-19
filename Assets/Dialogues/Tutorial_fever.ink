// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- SCENE 1: INTRODUCTION ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic room is warm. Mang Jose, a 45-year-old farmer, enters slowly. He looks tired and flushed. He sits down heavily, wiping sweat from his forehead.

# speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
"Good morning, Doc. I've been having this really bad fever for a few days now. Hindi ako makapagtrabaho. Ang sakit ng katawan ko."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Mang Jose is sweating despite the air conditioning. His face is flushed. He looks exhausted.

# speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
"Doc, yung kapitbahay ko, na-dengue daw. Natatakot ako baka ganun din ako."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Mang Jose is worried about Dengue because his neighbor was recently hospitalized. Your approach will determine whether he trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Mang Jose, let's start with your symptoms. When exactly did the fever start? Have you taken your temperature? Do you have any cough or colds?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose answers your questions, but he seems rushed, like he is being interrogated.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Yung lagnat... tatlong araw na. Hindi ko nasukat pero mainit talaga. Walang ubo, pero sumasakit ang katawan ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Mang Jose feels like just another case.
    -> information_gathering

* [Choice B: Focus on Patient's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Mang Jose, I can see you're worried. You mentioned your neighbor had Dengue. Tell me more about that—what happened to your neighbor? And how are you feeling about all this?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose relaxes slightly. He looks relieved that someone is listening.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Doc, yung kapitbahay ko, na-confine sa hospital. Natatakot ako baka ganun din ako. Ako lang kasi ang nagtatrabaho sa pamilya. Pag nagkasakit ako, walang kumakain."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Mang Jose feels heard and understood.
    -> information_gathering

* [Choice C: Focus on Environment and Exposure]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Mang Jose, given your neighbor's Dengue, I need to ask—have you been around areas with stagnant water? Any mosquito bites?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose looks defensive.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Nakatira ako sa probinsya, Doc. Syempre may lamok. Pero hindi ibig sabihin na may Dengue na ako!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. You examine Mang Jose and gather his history:

You note that his fever has been ongoing for three days, with body aches and joint pain. He has no cough or colds. He is worried about Dengue because of his neighbor's case.

~ info_score = 5
-> diagnosis_phase


// --- SCENE 4: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Based on the fever, body aches, and possible exposure to mosquitoes, what is your leading diagnosis?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Diagnose: Dengue Fever]
    ~ clinical_score = 5
    "Mang Jose, I believe you may have Dengue Fever. The fever, body aches, and joint pain are classic symptoms. We need to do a complete blood count to check your platelet count. If caught early, we can monitor you closely and prevent complications."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... kailangan ko bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Not necessarily. If your platelet count is still normal, we can manage you at home with plenty of fluids, rest, and monitoring. But we need to do the blood test first."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose nods, looking relieved.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. Akala ko kailangan ko na agad ma-confine."
    -> management_phase

* [Diagnose: Influenza (Flu)]
    ~ clinical_score = 3
    "Mang Jose, this could be Influenza. The fever and body aches are common with the flu."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung kapitbahay ko, Dengue daw. Baka ganun din ako?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the patient's concern about Dengue exposure. While the flu is possible, Dengue is also a serious possibility given the neighbor's case.
    -> management_phase

* [Diagnose: Bacterial Infection]
    ~ clinical_score = 2
    "Mang Jose, this could be a bacterial infection. We should start you on antibiotics."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero wala naman akong ubo o sipon. Bakit antibiotics?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have suggested antibiotics without clear evidence of bacterial infection. Viral fevers like Dengue or Flu do not respond to antibiotics.
    -> management_phase


// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Order CBC + Home Monitoring + Fluids]
    ~ safety_score = 5
    "Mang Jose, I'm going to order a complete blood count to check your platelets. In the meantime, drink plenty of fluids, water, juice, or oral rehydration solution. Take paracetamol for the fever. Monitor your temperature and watch for warning signs: severe abdominal pain, vomiting, bleeding, or difficulty breathing. If you experience any of these, come back immediately."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. Ano po ang mga warning signs na dapat kong bantayan?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "If you develop severe stomach pain, vomiting, bleeding gums, or difficulty breathing, these are danger signs. Come back to the clinic or go to the ER immediately."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose nods, understanding the plan.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. May gagawin na ako."
    -> ending

* [Admit to Hospital + IV Fluids]
    ~ safety_score = 3
    "Mang Jose, I'm going to admit you to the hospital for IV fluids and monitoring. This is the safest option."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! Hindi ko po kaya. Ako lang ang nagtatrabaho sa pamilya. Kung ma-confine ako, walang kumakain sa mga anak ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated too quickly without considering Mang Jose's social context. He is the sole breadwinner and cannot afford to be hospitalized without clear need.
    -> ending

* [Send Home with Paracetamol Only]
    ~ safety_score = 1
    "Mang Jose, just take paracetamol for the fever and rest at home. Come back if it gets worse."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero paano kung Dengue nga ito? Paano kung bumaba ang platelets ko?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed the patient's concern about Dengue. Without a blood test, you cannot rule out Dengue. This is unsafe.
    -> ending


// --- SCENE 6: ENDING & FEEDBACK ---
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
        "Excellent work! You recognized the possibility of Dengue, built trust with Mang Jose by listening to his concerns, and made a safe plan with lab work and home monitoring. This is the GOLDEN PATH."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and a safe plan, but Mang Jose left feeling unheard. Remember to build trust through empathy, especially when patients are scared."
    - clinical_score == 5 and safety_score < 5:
        "You correctly suspected Dengue but failed to act appropriately. Always consider the patient's social context and provide a clear, actionable plan."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and made a safe plan, but you missed the diagnosis. Remember: fever + body aches + joint pain + possible mosquito exposure = suspect Dengue."
    - clinical_score < 5:
        "You misdiagnosed Mang Jose's condition. Dengue is a serious illness that requires early recognition. Remember the classic symptoms: fever, body aches, joint pain, and possible exposure to mosquitoes."
    - else:
        "Keep practicing! Focus on listening to your patients' concerns and making safe, actionable plans."
}

-> END