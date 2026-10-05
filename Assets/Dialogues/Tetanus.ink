// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Mang Ben (Patient) Sprites:
//   TRISMUS/RIGID = MangBen_0
//   SPASM/PAIN = MangBen_1
//   WEAK/DISTRESSED = MangBen_2
//   RELIEVED = MangBen_3
//
// Aling Nelia (Wife) Sprites:
//   ANXIOUS = AlingNelia_0
//   CRYING = AlingNelia_1
//   DESPERATE = AlingNelia_2
//   RELIEVED = AlingNelia_3
//
// Close-Up Images:
//   Trismus (Lockjaw) = Trismus_Lockjaw_0
//   Rusty Nail Wound = Rustynailwound_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The emergency room is busy. Mang Ben, a 58-year-old farmer, is brought in by his wife, Aling Nelia. He is sitting upright, rigid, unable to relax. His jaw is clenched tightly—he cannot open his mouth. His back is arched uncomfortably. Aling Nelia looks terrified.

# closeup: Trismus_Lockjaw_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Mang Ben closely. His facial muscles are locked in a grimace—a classic sign called risus sardonicus. His neck and back muscles are rigid.

# speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
"Doc, tulungan niyo po ang asawa ko! Tatlong araw na siyang hindi makakain. Hindi niya mabuksan ang bibig niya. Sumasakit ang likod niya. Hindi siya makatulog."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
When a door slams nearby, Mang Ben suddenly jerks violently, his whole body spasming.

# speaker: Mang Ben # portrait_left: Clear # portrait_right: MangBen_1
"Doc... ang sakit... kahit konting galaw... nagse-spasm..."

# speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
"Doc, sampung araw na ang nakalipas, natapakan niya ang kalawang na pako sa bukid. Hindi naman siya nagpabakuna. Hindi namin alam na kailangan pala."

# closeup: Rustynailwound_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
This is critical information. Mang Ben stepped on a rusty nail 10 days ago. He has not received a tetanus vaccine. Now he has trismus (lockjaw), muscle rigidity, and spasms triggered by minor stimuli—classic signs of generalized tetanus.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Mang Ben has classic tetanus symptoms following a puncture wound. His wife is terrified. Your approach will determine whether she trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Nelia, let's start with his symptoms. When did the jaw stiffness start? Has he had any difficulty breathing? Any fever?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia answers your questions, but she seems frantic. Mang Ben is in obvious distress.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Yung panga niya... dalawang araw na. Hindi siya makalunok. Mahirap huminga. Namumutla siya."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Aling Nelia feels like she's being interrogated while her husband suffers.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Nelia, I can see how scared you are. Mang Ben, you mentioned you stepped on a nail. Can you tell me what happened? And what did you do after?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia relaxes slightly. Mang Ben tries to speak, but his jaw is locked.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_1
    "Doc, nagtatrabaho siya sa bukid. May kalawang na pako sa lupa. Natapakan niya. Naghilamos lang siya ng tubig. Hindi namin alam na kailangan pala magpabakuna. Mahirap lang po kami. Hindi namin alam ang gagawin."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Aling Nelia and Mang Ben feel heard and understood.
    -> information_gathering

* [Choice C: Focus on Vaccination History]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Aling Nelia, has Mang Ben ever received a tetanus vaccine? The symptoms he's showing are very serious. Why wasn't he vaccinated?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia becomes defensive and starts crying.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_1
    "Doc, wala po kaming pera! Hindi namin alam! Ngayon lang namin nalaman na kailangan pala! Huwag niyo po kaming sisihin!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about previous medical history]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Nelia, does Mang Ben have any other medical conditions? Is he taking any medications? Any allergies?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia thinks for a moment.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Wala naman po siyang ibang sakit. Wala ring gamot. Malusog naman siya dati."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Aling Nelia has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about wound details and timing]
    ~ info_score += 2
    "Aling Nelia, can you tell me more about the wound? When exactly did he step on the nail? Was it deep? Did he clean it?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Mga sampung araw na po. Malalim po ang sugat. Naghugas lang po siya ng tubig. Hindi po nalinis nang maayos."

    -> information_gathering_2

* [Ask about progression of symptoms]
    ~ info_score += 2
    "Aling Nelia, when did the jaw stiffness start? Has it gotten worse? Any difficulty swallowing or breathing?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_1
    "Mga dalawang araw na po. Lumalala po. Hindi na po siya makalunok. Mahirap na po siyang huminga."

    -> information_gathering_2

* [Ask about triggers and spasms]
    ~ info_score += 2
    "Aling Nelia, have you noticed any spasms? What triggers them? Does even a small noise or touch cause his body to jerk?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_1
    "Opo, Doc. Kahit maliit na ingay, bigla na lang siyang nanginginig. Kahit hawakan ko siya, nagse-spasm siya."

    -> information_gathering_2

* [Ask about social context and access to care]
    ~ info_score += 1
    "Aling Nelia, tell me more about your situation at home. Do you have access to healthcare? Any support?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Mahirap po kami. Walang trabaho ang mga anak namin. Ako lang po ang nag-aalaga sa kanya. Wala pong pambayad sa ospital."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about urgent danger signs today]
    ~ info_score += 2
    "Aling Nelia, I need to check for warning signs. Is he having difficulty breathing? Any episodes where he stops breathing? Any seizures?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_2
    "Mahirap po siyang huminga. Minsan, parang humihinto ang paghinga niya. Natatakot ako."

    -> diagnosis_phase

* [Ask about functional impact]
    ~ info_score += 1
    "Aling Nelia, how has this affected his daily life? Is he able to eat, drink, or sleep?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_1
    "Hindi na po siya nakakakain. Hindi na po siya makainom. Hindi rin po siya makatulog. Sobrang nahihirapan na po siya."

    -> diagnosis_phase

* [Ask about health literacy and understanding]
    ~ info_score += 1
    "Aling Nelia, what do you know about tetanus? What have you heard about how it's treated?"

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Ang alam ko po, nakakamatay ang tetanus. Sabi ng iba, wala nang gamot kapag lumabas na ang sintomas. Natatakot ako, Doc."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Mang Ben has:
- Rusty nail injury 10 days ago, no tetanus vaccine
- Trismus (lockjaw), risus sardonicus
- Muscle rigidity, spasms triggered by minor stimuli
- Difficulty swallowing, respiratory distress
- No fever
- Low-income family, limited healthcare access

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Generalized Tetanus]
    ~ clinical_score = 5
    "Aling Nelia, I am very concerned. Mang Ben has Generalized Tetanus. The bacteria from the rusty nail entered his body through the wound. Because he was not vaccinated, the bacteria produced a toxin that is now affecting his nerves, causing the muscle spasms and lockjaw. This is a life-threatening medical emergency that requires immediate hospitalization and aggressive treatment."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia breaks down crying.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_2
    "Doc... may pag-asa pa ba siya? Hindi ba siya mamamatay?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Tetanus is very serious, but we can treat it. We will admit him to the ICU, give him medications to neutralize the toxin, control the muscle spasms, and support his breathing. The treatment can take weeks to months, and complete recovery is possible. We will do everything we can, but we need to start immediately."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia nods, gripping her husband's hand.

    -> management_phase

* [Choice B: Meningitis]
    ~ clinical_score = 2
    "The neck stiffness and muscle rigidity could be Meningitis. We should do a lumbar puncture."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... pero yung pako? Yung sugat sa paa niya? At hindi niya mabuksan ang bibig—ang sabi ng kapitbahay namin, baka tetanus daw."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key clue: the puncture wound followed by trismus. Meningitis typically presents with fever and headache, not trismus after a wound.
    -> management_phase

* [Choice C: Stroke]
    ~ clinical_score = 1
    "The muscle stiffness could be a stroke. We should do a CT scan of the head."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... pero yung pako? Yung sugat? At bakit bigla siyang nangalay? Bakit hindi siya makakain?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored the wound history. Stroke does not cause trismus or risus sardonicus.
    -> management_phase

* [Choice D: Simple Muscle Strain]
    ~ clinical_score = 2
    "This could be a simple muscle strain. Let's give him muscle relaxants and observe."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_2
    "Doc! Hindi nga siya makabukas ng bibig! Hindi siya makalunok! Paano po muscle strain lang?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have dismissed a life-threatening condition. Tetanus requires immediate hospitalization and ICU-level care.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Admit to ICU + TIG + Wound Care + Antibiotics]
    ~ safety_score = 4
    "Aling Nelia, I am admitting Mang Ben to the ICU immediately. We will give him Tetanus Immune Globulin to neutralize the toxin, antibiotics to kill the bacteria, and muscle relaxants to control the spasms. We will also clean and debride the wound on his foot. He may need a breathing tube if his respiratory muscles are affected. This is going to be a long recovery—weeks to months—but we will do everything we can."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... magkano po ang magagastos? Mahirap lang po kami."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "We can apply for assistance through PhilHealth and the Malasakit Center. The most important thing right now is to save his life. Let's focus on that first, and we'll figure out the finances together. We also need to ensure that once he recovers, he gets vaccinated—tetanus does not provide immunity, so he will need the vaccine once he is stable."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nelia reaches for your hand, crying.

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_3
    "Doc... salamat sa pagiging totoo sa amin. Huwag niyo po siyang pabayaan."

    -> education_phase

* [Choice B: Admit to Regular Ward + TIG]
    ~ safety_score = 3
    "I will admit Mang Ben to the ward. We'll give him TIG and antibiotics, and monitor him."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... pero mahirap siyang huminga. Baka kailangan niya ng ICU?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have underestimated the severity of tetanus. Patients with respiratory distress or autonomic dysfunction require ICU-level care. Tetanus is a medical emergency requiring intensive monitoring.
    -> education_phase

* [Choice C: Send Home with Antibiotics + Painkillers]
    ~ safety_score = 1
    "I'll prescribe some antibiotics and painkillers. Come back if it gets worse."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_2
    "Doc! Hindi siya makakain! Hindi niya mabuksan ang bibig! Hindi niya mahinga nang maayos! Paano siya gagaling sa bahay?!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made a critical mistake. Tetanus has a 29% mortality rate in the Philippines. Sending a patient with trismus and respiratory distress home without treatment is a complete failure of patient safety.
    -> education_phase

* [Choice D: Refer to Specialist Without Immediate Treatment]
    ~ safety_score = 2
    "I'm going to refer Mang Ben to a specialist. They can decide on the best treatment."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... kailan po kami makakakita ng specialist? Baka hindi na umabot si Mang Ben."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed life-saving treatment by referring to a specialist unnecessarily. Tetanus requires immediate ICU admission.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Mang Ben is transferred to the ICU, you have an opportunity to educate Aling Nelia about prevention. Good patient education is part of patient safety.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain tetanus prevention and vaccination]
    ~ safety_score += 1
    "Aling Nelia, tetanus is 100% preventable through vaccination. Anyone who steps on a rusty nail or gets a deep wound should go to the health center immediately. They will clean the wound and give a tetanus vaccine. And make sure your family's tetanus vaccines are up to date. This simple step can save lives."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_3
    "Doc, naiintindihan ko na. Salamat sa pagpapaliwanag. Hindi ko na ito ipagsasawalang-bahala."

    -> ending

* [Choice B: Just tell her to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 2 days."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about wound care]
    ~ safety_score += 1
    "Aling Nelia, think of a wound like a door. If a rusty nail opens that door, bacteria can get in. The tetanus vaccine is like a lock on that door. That's why we get vaccinated—to keep the bacteria out."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_3
    "Ah, ganun pala iyon, Doc. Parang kandado lang. Salamat, naiintindihan ko na."

    -> ending

* [Choice D: Give her a pamphlet about tetanus]
    ~ safety_score += 0
    "Here's a pamphlet about tetanus. Read it when you get home."

    # speaker: Aling Nelia # portrait_left: Clear # portrait_right: AlingNelia_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At malabo po ang mata ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Safety score unchanged.
    -> ending


// --- SCENE 8: ENDING & FEEDBACK ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. Mang Ben is transferred to the ICU for further management.

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
        "Excellent work! You recognized the classic presentation of Tetanus: puncture wound + no vaccination + trismus + muscle rigidity. You handled the case with empathy, honesty, and appropriate escalation to ICU-level care. Tetanus remains a significant public health problem in the Philippines with a 29% mortality rate—your prompt recognition and action may have saved this patient's life."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and took appropriate action, but Mang Ben and his wife left feeling judged. Remember to approach families with empathy—they often have limited resources and may not understand the urgency of tetanus prevention."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Tetanus but failed to escalate appropriately. Tetanus is a medical emergency requiring ICU-level care for respiratory support. Underestimation of severity can be fatal."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and took appropriate action, but you missed the diagnosis. Remember: puncture wound + no vaccination + trismus = Tetanus until proven otherwise."
    - clinical_score < 5:
        "You misdiagnosed a life-threatening condition. Tetanus remains endemic in the Philippines with significant mortality. Always consider tetanus in patients with wounds presenting with trismus, muscle rigidity, or spasms."
    - else:
        "Keep practicing! Tetanus is 100% preventable through vaccination, but it remains a reality in resource-limited settings. Early recognition and aggressive treatment save lives."
}

-> END