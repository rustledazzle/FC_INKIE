// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Andrei (Patient) Sprites:
//   ANXIOUS/AGITATED = Andrei_r_0
//   HYDROPHOBIA = Andrei_r_1
//   WEAK/DISTRESSED = Andrei_r_2
//   SAD/DEFEATED = Andrei_r_3
//
// Aling Mila (Mother) Sprites:
//   ANXIOUS = Alingmila_0
//   CRYING = Alingmila_1
//   DESPERATE = Alingmila_2
//   RELIEVED = Alingmila_3
//
// Close-Up Images:
//   Dog Bite Wound = Dog Bite Wound_0
//   Hydrophobia = Hydrophobia_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The Animal Bite Treatment Center is busy. Andrei, a 19-year-old man, enters with his mother, Aling Mila. Andrei looks agitated, sweating, and his eyes are darting around nervously. He is holding his throat. Aling Mila looks exhausted and worried.

# closeup: Dog Bite Wound_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice a healed wound on Andrei's lower leg—a small scar from a dog bite.

# speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
"Doc, salamat po sa pagtanggap sa amin. Si Andrei po, nakagat siya ng aso tatlong linggo na ang nakalipas. Ngayon, sobrang hindi siya mapakali. Ayaw niyang uminom ng tubig. Natatakot siya."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Andrei closely. He is clearly agitated. When you offer him a glass of water, he recoils in terror—a classic sign of hydrophobia.

# closeup: Hydrophobia_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
He refuses to drink, pushing the glass away with trembling hands. His face shows intense fear.

# speaker: Andrei # portrait_left: Clear # portrait_right: Andrei_r_1
"Doc... ang sakit ng lalamunan ko... parang... may naninikip... at natatakot ako... sa tubig..."

# speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
"Doc, noong nakagat siya, dinala muna namin siya sa albularyo. Naglagay ng gamot. Pero hindi gumaling. Ngayon, lumalala na siya. Natatakot na ako baka... baka rabies na ito."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Andrei has a history of dog bite, no PEP, and now has neurological symptoms. His mother is terrified. Your approach will determine whether she trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Mila, let's start with the bite. When exactly did it happen? Where was the dog? Did you wash the wound?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Mila answers your questions, but she seems rushed and panicked. Andrei is growing more agitated.

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Tatlong linggo na po. Stray dog po. Pinahid ko lang ng langis at tubig. Hindi naman namin alam na kailangan pala magpabakuna agad."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Aling Mila feels like she's being interrogated while her son is suffering.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Mila, I can see how scared you are. Andrei, you mentioned you were bitten. Can you tell me what happened that day? And what did you do after?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Mila relaxes slightly. Andrei tries to speak, but he is in distress.

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_1
    "Doc, nagtatrabaho si Andrei sa bukid. May asong gala na lumapit sa kanya. Bigla siyang nakagat sa paa. Hindi namin alam na dapat pala agad magpabakuna. Dinala namin siya sa albularyo kasi walang pambayad sa clinic."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Aling Mila and Andrei feel heard and understood.
    -> information_gathering

* [Choice C: Focus on Danger Signs (Hydrophobia)]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Aling Mila, you mentioned he's afraid of water. This is a very serious sign. We need to check him immediately for rabies. Why didn't you bring him earlier?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Mila becomes defensive and starts crying.

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_1
    "Doc, wala po kaming pera! Kaya dinala namin siya sa albularyo. Hindi naman namin alam na ganito kalala!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Aling Mila has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about the dog and its status]
    ~ info_score += 2
    "Aling Mila, can you tell me more about the dog? Was it a stray? Is it still alive? Did it show any signs of illness?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Stray dog po. Hindi na po namin nakita ulit. Hindi ko po alam kung buhay pa."

    -> information_gathering_2

* [Ask about wound care and PEP]
    ~ info_score += 2
    "Aling Mila, did you wash the wound immediately? Did you go to a clinic for post-exposure prophylaxis (PEP) or vaccines?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Hinugasan ko lang po ng tubig at sabon. Hindi po kami nakapunta sa clinic. Wala pong pera."

    -> information_gathering_2

* [Ask about progression of symptoms]
    ~ info_score += 2
    "Aling Mila, when did Andrei start showing these symptoms? Has he had fever, difficulty swallowing, or changes in behavior?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Mga isang linggo na po. Nagsimula sa lagnat. Tapos, ayaw na niyang uminom. Tapos, naging agitated na siya. Hindi na po siya mapakali."

    -> information_gathering_2

* [Ask about social context and access to care]
    ~ info_score += 1
    "Aling Mila, tell me more about your situation at home. Do you have access to healthcare? Any support?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Mahirap po kami. Walang trabaho ang asawa ko. Ako lang po ang nag-aalaga kay Andrei. Wala pong pambayad sa ospital."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about urgent danger signs today]
    ~ info_score += 2
    "Aling Mila, I need to check for warning signs. Is Andrei having difficulty breathing? Seizures? Confusion? Severe spasms?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_2
    "Mahirap po siyang huminga minsan. At may mga panahon na nanginginig siya nang malakas. Natatakot ako."

    -> diagnosis_phase

* [Ask about functional impact]
    ~ info_score += 1
    "Aling Mila, how has this affected Andrei's daily life? Is he able to eat, drink, or sleep?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_1
    "Hindi na po siya nakakakain nang maayos. Ayaw niyang uminom. Hindi rin po siya makatulog. Sobrang nahihirapan na po siya."

    -> diagnosis_phase

* [Ask about health literacy and understanding of rabies]
    ~ info_score += 1
    "Aling Mila, what do you know about rabies? What have you heard about how it's treated?"

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Ang alam ko po, nakakamatay ang rabies. Sabi ng iba, wala nang gamot kapag lumabas na ang sintomas. Natatakot ako, Doc."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Andrei has:
- Dog bite 3 weeks ago, no PEP
- Agitation, hydrophobia, difficulty swallowing
- Muscle spasms, anxiety
- No fever currently, but progressive neurological symptoms
- Low-income family, went to traditional healer first

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Rabies]
    ~ clinical_score = 5
    "Aling Mila, I am very concerned. Andrei may have Rabies. The dog bite three weeks ago, the refusal to drink water, the agitation—these are classic signs of rabies. Rabies is 100% fatal if not treated early, but it is also 100% preventable. Unfortunately, because he did not receive the vaccine right after the bite, the virus has already reached his brain."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Mila breaks down crying.

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_2
    "Doc... wala na bang pag-asa? Hindi na ba siya pwedeng gamutin?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "We can provide supportive care—medications to help with the symptoms. But once rabies symptoms appear, the disease is almost always fatal. The most important thing now is to make sure no one else gets exposed. We will also need to do contact tracing for family members who may have been exposed to his saliva."

    -> management_phase

* [Choice B: Tetanus]
    ~ clinical_score = 2
    "The difficulty swallowing and muscle spasms could be Tetanus. We should give tetanus toxoid and antibiotics."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Doc... pero takot siya sa tubig. Hindi naman po takot sa tubig ang tetanus."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key symptom: hydrophobia is a classic sign of rabies, not tetanus.
    -> management_phase

* [Choice C: Viral Encephalitis]
    ~ clinical_score = 2
    "This could be a viral infection of the brain. We should do a spinal tap and MRI."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Doc... pero yung aso? Yung kagat? Baka naman may kinalaman yun?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the connection between the dog bite and the neurological symptoms. The exposure history is critical.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Admit for Supportive Care + Contact Tracing + Public Health Referral]
    ~ safety_score = 4
    "Aling Mila, I am going to admit Andrei to the hospital for supportive care. We will give him medications to help with the symptoms. We also need to do contact tracing—any family members who may have been exposed to his saliva through close contact need to be assessed and given PEP if needed. The local health office will also investigate the dog and the area for other rabies cases."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_2
    "Doc... kailangan ko bang magpa-bakuna? Yung pamilya namin?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Yes, anyone who has had close contact with Andrei, especially with his saliva, should be assessed and may need PEP. The Municipal Health Office will conduct contact tracing. Please cooperate with them. And make sure the dog that bit Andrei is reported to the authorities for observation and testing."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_3
    "Doc... salamat sa pagiging totoo sa amin. Dapat pala dinala ko siya agad."

    -> education_phase

* [Choice B: Send Home with Antibiotics + Paracetamol]
    ~ safety_score = 1
    "Just give him paracetamol for the fever and some antibiotics. Come back if it gets worse."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_2
    "Doc! Takot siya sa tubig! Hindi siya makainom! Paano siya gagaling? Hindi niyo ba siya papasukin?!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made a critical mistake. Rabies is fatal once symptoms appear. Andrei needs supportive care and isolation. Sending him home without treatment or quarantine puts him and his family at risk.
    -> education_phase

* [Choice C: Refer to Traditional Healer]
    ~ safety_score = 1
    "Since you believe in traditional healing, you can try that again. Let me know if anything changes."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_2
    "Doc! Hindi na gumana ang albularyo! Lumalala siya! Kailangan niya ng totoong gamot!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have dismissed a fatal condition as something that can be managed with traditional medicine. This is a complete failure of patient safety.
    -> education_phase

* [Choice D: Refer to Specialist Without Immediate Action]
    ~ safety_score = 2
    "I'm going to refer Andrei to a specialist. They can manage this better."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Doc... kailan po kami makakakita ng specialist? Baka hindi na umabot si Andrei."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed supportive care and contact tracing by referring to a specialist unnecessarily. Rabies requires immediate isolation and public health action.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Andrei is transferred, you have an opportunity to educate Aling Mila about prevention and public health. Good patient education is part of patient safety.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain rabies prevention and PEP]
    ~ safety_score += 1
    "Aling Mila, rabies is 100% fatal but 100% preventable. If anyone in your family gets bitten by a dog or cat, wash the wound immediately with soap and running water for 15 minutes. Then go to an Animal Bite Treatment Center right away for vaccines. Do not wait. Do not go to a traditional healer first. And make sure your pets are vaccinated against rabies."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_3
    "Doc, naiintindihan ko na. Salamat sa pagpapaliwanag. Hindi ko na ito ipagsasawalang-bahala."

    -> ending

* [Choice B: Just tell her to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 2 days."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention or the importance of PEP. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about rabies prevention]
    ~ safety_score += 1
    "Aling Mila, think of rabies like a fire. If you catch it early, you can put it out with water and vaccines. But if you wait until the fire is big, it's very hard to stop. That's why we go to the clinic immediately after a dog bite—to put out the fire before it spreads."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_3
    "Ah, ganun pala iyon, Doc. Parang sunog lang. Salamat, naiintindihan ko na."

    -> ending

* [Choice D: Give her a pamphlet about rabies]
    ~ safety_score += 0
    "Here's a pamphlet about rabies. Read it when you get home."

    # speaker: Aling Mila # portrait_left: Clear # portrait_right: Alingmila_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At malabo po ang mata ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Safety score unchanged.
    -> ending


// --- SCENE 8: ENDING & FEEDBACK ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. Andrei is transferred for supportive care.

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
        "Excellent work! You recognized the classic presentation of Rabies: dog bite history + no PEP + hydrophobia. You handled the case with empathy, honesty, and appropriate public health action including admission and contact tracing. Rabies is 100% fatal but 100% preventable—and you helped the family understand this difficult reality."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and took appropriate action, but Andrei and his mother left feeling judged. Remember to approach families with empathy—they often have limited resources and may not understand the urgency of rabies prevention."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Rabies but failed to act. Once symptoms appear, rabies is almost always fatal. Patients need supportive care and appropriate isolation to protect the community."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and took appropriate action, but you missed the diagnosis. Remember: dog bite history + no PEP + hydrophobia = Rabies until proven otherwise."
    - clinical_score < 5:
        "You misdiagnosed a fatal condition. Rabies is a medical emergency. If a patient has a history of animal bite and presents with neurological symptoms like hydrophobia, consider Rabies immediately."
    - else:
        "Keep practicing! Rabies is 100% fatal but 100% preventable. The key is early recognition and immediate PEP after animal bites."
}

-> END