// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Juan (Patient) Sprites:
//   WEAK/TIRED = JUAN_Lepton_0
//   PAIN = JUAN_Lepton_1
//   RELIEVED = JUAN_Lepton_2
//   HOPEFUL = JUAN_Lepton_3
//
// Aling Nena (Mother) Sprites:
//   ANXIOUS = AlingNena1_0
//   CRYING = AlingNena1_1
//   DEFENSIVE = AlingNena1_2
//   RELIEVED = AlingNena1_3
//
// Close-Up Images:
//   Face (Conjunctival Suffusion) = JUAN_Lepto_face_0
//   Foot (Wound) = JUAN_Lepto_foot_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The emergency room is busy. A 21-year-old man, Juan, lies on the examination bed. He looks pale and weak. His mother, Aling Nena, sits beside him, her hands trembling as she wipes his forehead with a damp cloth. The room smells of disinfectant and sweat.

# closeup: JUAN_Lepto_face_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Juan's eyes are bloodshot—a classic sign called conjunctival suffusion. His skin has a yellowish tint, suggesting jaundice. He is weak and barely responsive.

# speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
"Doc, salamat po sa pagtanggap sa amin. Si Juan po, tatlong araw na siyang nilalagnat. Sobrang sakit ng katawan niya, lalo na sa binti at likod. Hindi na siya makakain. Namumula rin ang mata niya."

# speaker: Juan # portrait_left: Clear # portrait_right: JUAN_Lepton_1
"Doc... ang sakit... ng ulo ko... at parang... namamaga ang tiyan ko..."

# speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
"Doc, nagtatrabaho si Juan sa palengke. Pero last week, lumusong siya sa baha kasi inabutan siya ng ulan. Sabi niya, may maliit daw siyang sugat sa paa."

# closeup: JUAN_Lepto_foot_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
This is a critical detail. Juan waded in floodwater with an open wound. This is a classic risk factor for Leptospirosis. The bacteria Leptospira enters through cuts and wounds in contaminated water.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Juan has been sick for three days. His mother is worried. Your approach will determine whether she trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Nena, let's start with Juan's symptoms. When exactly did the fever start? Has he had any vomiting or diarrhea? Any blood in his urine?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena answers your questions efficiently. But she seems rushed, like she is being interrogated. Juan looks uncomfortable.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Opo, may pagsusuka siya. At ang ihi niya, parang konti na lang. Medyo madilaw rin ang kulay."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Juan and his mother feel like they are being processed.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Nena, I can see how worried you are. Juan, you mentioned wading through floodwater. Can you tell me more about that? What happened that day?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena relaxes slightly. Juan tries to speak, but he is weak. His mother speaks for him.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_1
    "Doc, inabutan siya ng baha pauwi galing trabaho. Wala siyang choice kundi lumusong. Ngayon, nakikita ko siyang nahihirapan. Natatakot ako. Ang kapitbahay namin, namatay sa leptospirosis dati."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Juan and his mother feel heard and understood.
    -> information_gathering

* [Choice C: Focus on Risk Factors and Exposure]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Aling Nena, given the flood exposure, I need to ask—did Juan have any wounds when he waded through the water? How long was he exposed?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena looks defensive.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_2
    "May sugat po siya sa paa. Pero hindi naman niya ginusto na lumusong. Kailangan niyang umuwi!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Focus on Functional Impact]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Nena, how has this affected Juan's ability to work and daily life? Is he able to function?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena sighs.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Hindi na po siya makapagtrabaho. Dalawang araw na siyang hindi pumapasok sa palengke. Natatakot ako na baka lumala pa."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Aling Nena has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about red flags: bleeding, difficulty breathing, decreased urine]
    ~ info_score += 2
    "Aling Nena, I need to check for warning signs. Any bleeding from his gums or nose? Difficulty breathing? Is he still urinating?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Wala naman pong dugo. Pero nahihirapan po siyang huminga. At kaninang umaga, hindi na po siya umiihi."

    -> information_gathering_2

* [Ask about associated symptoms: headache, muscle pain, abdominal pain]
    ~ info_score += 2
    "Aling Nena, besides the fever and body aches, does Juan have any headache, muscle pain, or abdominal pain?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "May sakit po ang ulo niya. At yung binti at likod niya, sobrang sakit. Sabi niya, parang namamaga ang tiyan niya."

    -> information_gathering_2

* [Ask about medical history and medications]
    ~ info_score += 1
    "Aling Nena, does Juan have any other medical conditions? Is he taking any medications?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Wala naman po akong alam na ibang sakit niya. Malusog naman siya dati."

    -> information_gathering_2

* [Ask about social context and access to care]
    ~ info_score += 2
    "Aling Nena, tell me more about your home. Do you have access to clean water? How are you managing?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Wala po kaming gripo. Yung balon, malayo. At mahirap po ang buhay. Natatakot ako sa gastos."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about exposure duration and wound care]
    ~ info_score += 2
    "Aling Nena, how long was Juan exposed to the floodwater? Did he clean the wound afterward?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Mga isang oras po siyang lumusong. Naghugas naman po siya ng tubig, pero hindi po nalinis nang maayos."

    -> diagnosis_phase

* [Ask about health literacy and understanding of leptospirosis]
    ~ info_score += 1
    "Aling Nena, what do you know about leptospirosis? What have you heard about how it's treated?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Ang alam ko po, galing sa baha. Nakakamatay daw. Pero hindi ko po alam kung paano gamutin."

    -> diagnosis_phase

* [Ask about other family members and community context]
    ~ info_score += 1
    "Aling Nena, are there other people in your community who waded through the flood? Anyone else sick?"

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Marami pong lumusong sa baha. Yung ibang kapitbahay namin, may sakit din. Natatakot ako baka ganun din sila."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Juan has:
- Fever for 3 days, temperature 39.5°C
- Severe myalgia (muscle aches) especially in calves and back
- Conjunctival suffusion (red eyes)
- Jaundice (yellow skin and eyes)
- Oliguria (decreased urine output)
- Mild abdominal pain
- Exposure to floodwater with an open wound

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Leptospirosis (Weil Syndrome)]
    ~ clinical_score = 5
    "Aling Nena, I believe Juan has Leptospirosis. It's a bacterial infection caused by the Leptospira bacteria, which is found in the urine of infected animals—especially rats. The bacteria entered Juan's body through the wound on his foot when he waded through the floodwater. The jaundice and kidney involvement suggest Weil syndrome, the severe form of the disease."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena's face pales.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... totoo po? Ano po ang gagawin namin?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "The good news is we caught it early. We can start him on antibiotics immediately—either Penicillin G or Doxycycline. We also need to monitor his kidneys and liver closely. If treated early, the chances of recovery are very good."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena begins to cry—tears of relief.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_3
    "Doc... salamat. Natatakot ako na baka katulad siya ng kapitbahay namin."

    -> management_phase

* [Choice B: Dengue Hemorrhagic Fever]
    ~ clinical_score = 2
    "Given the fever, body aches, and red eyes, this could be Dengue. We should do a complete blood count to check his platelets."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... pero yung paninilaw po ng mata niya? At yung pagbaha? Sabi ng kapitbahay namin, baka leptospirosis daw."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key clues: jaundice + flood exposure + kidney involvement. Dengue does not typically cause jaundice or kidney failure.
    -> management_phase

* [Choice C: Hepatitis A]
    ~ clinical_score = 2
    "The jaundice and abdominal pain suggest Hepatitis A. We should do liver function tests."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... pero yung lagnat at pamumula ng mata? Yung baha na kanyang nilusungan?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored the flood exposure and muscle pain. Hepatitis A does not cause severe muscle aches or red eyes.
    -> management_phase

* [Choice D: Malaria]
    ~ clinical_score = 2
    "The fever and body aches could be Malaria. We should do a blood smear."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... pero yung baha? Yung sugat sa paa niya? Hindi naman po siya nakagat ng lamok."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the environmental exposure. Malaria is transmitted by mosquitoes, not floodwater.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Admit + Antibiotics + PhilHealth Assistance]
    ~ safety_score = 4
    "Aling Nena, I am admitting Juan to the hospital. He needs IV antibiotics—Penicillin G or Doxycycline—to fight the infection. We also need to monitor his kidney function closely. Leptospirosis can cause kidney failure if not treated early."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... magkano po ang magagastos? Mahirap lang po kami."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "PhilHealth has a package for Leptospirosis. For moderate to severe cases, they cover up to ₱170,000 for cases requiring hemodialysis. We can also apply for assistance through the Malasakit Center. Don't worry about the cost—let's focus on getting Juan better."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Nena reaches for your hand. She is crying.

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_3
    "Doc... maraming salamat. Hindi ko alam kung paano kayo pasasalamatan."

    -> education_phase

* [Choice B: Send Home with Oral Antibiotics + Follow-up]
    ~ safety_score = 3
    "I will prescribe oral Doxycycline for Juan. He can take it at home. Return if his symptoms get worse."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... pero paano kung lumala siya sa bahay? Paano kung magka-kidney failure siya?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have underestimated the severity of Leptospirosis. Juan needs IV antibiotics and close monitoring for kidney failure. Oral antibiotics may not be sufficient for severe cases.
    -> education_phase

* [Choice C: Observation Only with Paracetamol]
    ~ safety_score = 1
    "Let's just give him paracetamol for the fever and observe him. Come back if he doesn't improve."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_1
    "Doc! Hindi niyo po ba siya papasukin? May sugat siya sa paa, lumusong siya sa baha, at ngayon ay naninilaw na siya! Paano kung mamatay siya?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made a critical mistake. Leptospirosis can rapidly progress to multi-organ failure. Delaying treatment can be fatal.
    -> education_phase

* [Choice D: Refer to Specialist Without Treatment]
    ~ safety_score = 2
    "I'm going to refer Juan to a specialist. They can decide on the best treatment."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... kailan po kami makakakita ng specialist? Baka hindi na umabot si Juan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed treatment by referring to a specialist unnecessarily. Leptospirosis with jaundice and kidney involvement requires immediate admission and IV antibiotics.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Juan is transferred, you have an opportunity to educate Aling Nena about prevention and home management.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain prevention and warning signs]
    ~ safety_score += 1
    "Aling Nena, to prevent leptospirosis in the future: avoid wading through floodwater if possible. If you must, wear boots or protective footwear. Cover any wounds with waterproof bandages. Wash thoroughly with clean water and soap after exposure. And if anyone in your family develops fever, muscle pain, or red eyes after wading through floodwater, go to the health center immediately."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_3
    "Doc, naiintindihan ko na. Salamat sa pagpapaliwanag. Hindi ko na ito ipagsasawalang-bahala."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands prevention and warning signs. Safety score increased.
    -> ending

* [Choice B: Just tell her to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 2 days."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention or warning signs. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about floodwater and infection]
    ~ safety_score += 1
    "Aling Nena, think of floodwater like dirty water with tiny invisible germs. If there's a cut on your skin, those germs can get in and make you very sick. That's why we wear boots, cover wounds, and wash thoroughly. It's like keeping a wound clean so it doesn't get infected."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_3
    "Ah, ganun pala iyon, Doc. Parang sugat lang na dapat linisin. Salamat, naiintindihan ko na."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands the connection between floodwater and infection. Safety score increased.
    -> ending

* [Choice D: Give her a pamphlet about leptospirosis]
    ~ safety_score += 0
    "Here's a pamphlet about leptospirosis. Read it when you get home."

    # speaker: Aling Nena # portrait_left: Clear # portrait_right: AlingNena1_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At malabo ang mata ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Safety score unchanged.
    -> ending


// --- SCENE 8: ENDING & FEEDBACK ---
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
        "Excellent work! You recognized the classic presentation of Leptospirosis: fever + jaundice + flood exposure + kidney involvement. You built trust with the mother, diagnosed correctly, and ensured patient safety with appropriate admission and antibiotics. This is the GOLDEN PATH."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and safe admission, but Juan and his mother left feeling unseen. Remember to build trust through empathy, especially when patients are frightened."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Leptospirosis but failed to act. Leptospirosis can rapidly progress to multi-organ failure. Always admit patients with jaundice and kidney involvement for IV antibiotics and monitoring."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and made a safe admission, but you missed the diagnosis. Remember: fever + jaundice + red eyes + flood exposure + open wound = Leptospirosis until proven otherwise."
    - clinical_score < 5:
        "You misdiagnosed Juan's condition. Leptospirosis is a life-threatening infection that requires early recognition and treatment. Remember the classic triad: fever + jaundice + kidney involvement after flood exposure."
    - else:
        "Keep practicing! Focus on recognizing the link between environmental exposure and symptoms. Leptospirosis is common in the Philippines during the rainy season."
}

-> END