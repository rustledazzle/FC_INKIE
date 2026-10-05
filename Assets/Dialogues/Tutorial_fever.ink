// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Mang Jose (Patient) Sprites:
//   TIRED/FLUSHED = Mangjose_0
//   WORRIED/ANXIOUS = Mangjose_1
//   RELIEVED = Mangjose_2
//   GRATEFUL = Mangjose_3
//
// Close-Up Images:
//   Flushed Face = Mangjose_face_0
//   Skin Rash = Mangjose_arm_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic room is warm. Mang Jose, a 45-year-old farmer, enters slowly. He looks tired and flushed. He sits down heavily, wiping sweat from his forehead.

# closeup: Mangjose_face_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Mang Jose is sweating despite the air conditioning. His face is flushed. His eyes look tired.

# speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
"Good morning, Doc. I've been having this really bad fever for a few days now. Hindi ako makapagtrabaho. Ang sakit ng katawan ko. Yung kapitbahay ko, na-dengue daw. Natatakot ako baka ganun din ako."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You take his temperature. It is 39.2°C. You note the fever has been ongoing for 3 days. He has no cough or colds. He reports body aches and joint pain. He is worried about Dengue because his neighbor was recently hospitalized.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Mang Jose is worried about Dengue. Your opening approach will determine whether he trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Mang Jose, let's start with your symptoms. When exactly did the fever start? Have you taken your temperature? Do you have any cough or colds?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose answers your questions, but he seems rushed, like he is being interrogated.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Yung lagnat... tatlong araw na. Hindi ko nasukat pero mainit talaga. Walang ubo, pero sumasakit ang katawan ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL.
    -> information_gathering

* [Choice B: Focus on Patient's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Mang Jose, I can see you're worried. You mentioned your neighbor had Dengue. Tell me more about that—what happened to your neighbor? And how are you feeling about all this?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose relaxes slightly. He looks relieved that someone is listening.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Doc, yung kapitbahay ko, na-confine sa hospital. Natatakot ako baka ganun din ako. Ako lang kasi ang nagtatrabaho sa pamilya. Pag nagkasakit ako, walang kumakain."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH.
    -> information_gathering

* [Choice C: Focus on Environment and Exposure]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Mang Jose, given your neighbor's Dengue, I need to ask—have you been around areas with stagnant water? Any mosquito bites?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose looks defensive.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Nakatira ako sa probinsya, Doc. Syempre may lamok. Pero hindi ibig sabihin na may Dengue na ako!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Focus on Functional Impact]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Mang Jose, how has this fever affected your work and daily life? Are you able to function at your job?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose sighs.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Hindi na po ako makapagtrabaho nang maayos. Dalawang araw na akong hindi pumapasok sa bukid. Natatakot ako na baka lumala pa."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Mang Jose has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about warning signs: severe abdominal pain, persistent vomiting, bleeding]
    ~ info_score += 2
    "Mang Jose, I need to check for warning signs. Do you have severe stomach pain? Persistent vomiting? Any bleeding from your gums or nose? Blood in your stool or vomit?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Wala naman pong matinding sakit ng tiyan. Hindi naman ako nagsusuka. Wala ring dugo. Pero yung lagnat, hindi talaga bumababa."

    -> information_gathering_2

* [Ask about rash and skin changes]
    ~ info_score += 2
    "Mang Jose, have you noticed any rash on your body? Any red spots or skin changes?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You examine his arms and torso.

    # closeup: Mangjose_arm_0
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You note small, red, blanching maculopapular lesions on his forearm—consistent with a Dengue rash.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "May napansin nga po akong maliliit na butlig. Hindi ko lang pinansin."

    -> information_gathering_2

* [Ask about fluid intake and urine output]
    ~ info_score += 2
    "Mang Jose, how much water have you been drinking? When was the last time you urinated? Is it normal in amount?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Konti lang po ang iniinom ko kasi wala akong gana. Pero nakakaihi naman po ako nang normal."

    -> information_gathering_2

* [Ask about community context and mosquito exposure]
    ~ info_score += 1
    "Mang Jose, you mentioned your neighbor had Dengue. Can you tell me more about that? Are there mosquitoes around your home?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Marami pong lamok sa amin. Yung tubig sa mga paso at lalagyan, hindi namin natatakpan. Yung kapitbahay namin, na-dengue."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about associated symptoms: headache, eye pain, muscle pain]
    ~ info_score += 2
    "Mang Jose, besides the fever and body aches, do you have any headache, pain behind your eyes, or muscle pain?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "May sakit po ang ulo ko. At yung likod ng mata ko, masakit din. Pati yung binti at likod ko, sumasakit."

    -> diagnosis_phase

* [Ask about medical history and medications]
    ~ info_score += 1
    "Mang Jose, do you have any other medical conditions? Are you taking any medications?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Wala naman po akong ibang sakit. Wala ring gamot. Malusog naman ako dati."

    -> diagnosis_phase

* [Ask about health literacy and understanding of dengue]
    ~ info_score += 1
    "Mang Jose, what do you know about Dengue? What have you heard about how it's treated?"

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Ang alam ko po, galing sa lamok. Nakakamatay daw. Pero hindi ko alam kung paano gamutin. Sabi ng iba, painumin daw ng maraming tubig."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Mang Jose has:
- Fever for 3 days, temperature 39.2°C
- Body aches, joint pain, headache, retro-orbital pain
- Maculopapular rash on forearm
- No cough or colds
- No warning signs (no severe abdominal pain, no persistent vomiting, no bleeding)
- Decreased fluid intake
- Lives in a community with known Dengue cases

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Dengue Fever (Without Warning Signs)]
    ~ clinical_score = 5
    "Mang Jose, I believe you may have Dengue Fever. The fever for 3 days, body aches, joint pain, headache, and rash are classic symptoms. You do not have any warning signs right now, which is good. But we need to do a complete blood count to check your platelet count and monitor you closely."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Doc... kailangan ko bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Not necessarily. If your platelet count is stable and you have no warning signs, we can manage you at home with plenty of fluids and close monitoring. But we need to do the blood test first to be sure."

    -> management_phase

* [Choice B: Severe Dengue]
    ~ clinical_score = 2
    "Mang Jose, this could be severe dengue. You need to be admitted immediately for IV fluids and close monitoring."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Doc... ganun ba kalala? Wala naman akong bleeding o matinding sakit ng tiyan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have over-diagnosed. Mang Jose has no warning signs or severe features. He has dengue without warning signs, which can be managed as an outpatient.
    -> management_phase

* [Choice C: Influenza (Flu)]
    ~ clinical_score = 3
    "Mang Jose, this could be Influenza. The fever and body aches are common with the flu."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Doc... pero yung kapitbahay ko, Dengue daw. Baka ganun din ako?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the patient's concern about Dengue exposure. While the flu is possible, Dengue is also a serious possibility given the neighbor's case.
    -> management_phase

* [Choice D: Bacterial Infection]
    ~ clinical_score = 2
    "Mang Jose, this could be a bacterial infection. We should start you on antibiotics."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Doc... pero wala naman akong ubo o sipon. Bakit antibiotics?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have suggested antibiotics without clear evidence of bacterial infection. Viral fevers like Dengue or Flu do not respond to antibiotics.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Order CBC + Home Monitoring + Fluids + Follow-up]
    ~ safety_score = 4
    "Mang Jose, I'm going to order a complete blood count to check your platelet count. In the meantime, drink plenty of fluids—water, juice, or oral rehydration solution. Take paracetamol for the fever. Do not take aspirin or ibuprofen. Monitor your temperature and watch for warning signs: severe stomach pain, persistent vomiting, bleeding gums or nose, blood in your stool, or if you stop urinating. If any of these happen, come back immediately or go to the ER."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_2
    "Salamat, Doc. Ano po ang mga warning signs na dapat kong bantayan?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Severe stomach pain, persistent vomiting, bleeding gums or nose, blood in your stool, or if you don't urinate for 6 hours. These are danger signs. Also, come back in 2 days for a follow-up blood test."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Jose nods, understanding the plan.

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_2
    "Salamat, Doc. May gagawin na ako."
    -> education_phase

* [Choice B: Admit to Hospital Immediately]
    ~ safety_score = 3
    "Mang Jose, I'm going to admit you to the hospital for IV fluids and monitoring. This is the safest option."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Doc! Hindi ko po kaya. Ako lang ang nagtatrabaho sa pamilya. Kung ma-confine ako, walang kumakain sa mga anak ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated without clear indication. Mang Jose has dengue without warning signs. He can be managed as an outpatient with close follow-up.
    -> education_phase

* [Choice C: Send Home with Paracetamol Only]
    ~ safety_score = 1
    "Just take paracetamol for the fever and rest at home. Come back if it gets worse."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_1
    "Doc... pero paano kung Dengue nga ito? Paano kung bumaba ang platelets ko?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed the possibility of Dengue. Without a CBC and clear follow-up instructions, you cannot monitor for warning signs. This is unsafe.
    -> education_phase

* [Choice D: Give Antibiotics + Paracetamol]
    ~ safety_score = 2
    "I'll give you antibiotics and paracetamol. The antibiotics will kill the bacteria causing the fever."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Doc... kailangan po ba ng antibiotic? Wala naman akong ubo o sipon."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have prescribed antibiotics unnecessarily. Dengue is a viral illness—antibiotics are not indicated.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Mang Jose leaves, you have an opportunity to educate him about prevention and home management.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain warning signs, hydration, and mosquito prevention]
    ~ safety_score += 1
    "Mang Jose, remember the warning signs: severe stomach pain, persistent vomiting, bleeding, or not urinating. If any of these happen, come back immediately. Drink plenty of fluids. And to prevent Dengue in the future, remove stagnant water around your home, use mosquito nets, and wear long sleeves when working outdoors."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_3
    "Doc, naiintindihan ko na. Salamat sa pagpapaliwanag. Hindi ko na ito ipagsasawalang-bahala."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands warning signs and prevention. Safety score increased.
    -> ending

* [Choice B: Just tell him to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 2 days."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding warning signs or prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about platelets]
    ~ safety_score += 1
    "Mang Jose, think of your platelets like soldiers in your blood. Dengue can lower the number of soldiers, so we need to check them. If the soldiers get too few, that's when bleeding can happen. That's why we need the blood test and why you need to watch for warning signs."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_3
    "Ah, ganun pala iyon, Doc. Parang sundalo lang. Salamat, naiintindihan ko na."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands the connection between platelets and bleeding risk. Safety score increased.
    -> ending

* [Choice D: Give him a pamphlet about Dengue]
    ~ safety_score += 0
    "Here's a pamphlet about Dengue. Read it when you get home."

    # speaker: Mang Jose # portrait_left: Clear # portrait_right: Mangjose_0
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
        "Excellent work! You recognized Dengue Fever without warning signs, addressed Mang Jose's fears with empathy, ordered the appropriate test (CBC), and provided clear home monitoring instructions. Dengue is endemic in the Philippines—your prompt recognition and safe management will prevent complications."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and safe management plan, but Mang Jose left feeling rushed. Remember to listen to the patient's concerns—he is worried because his neighbor was hospitalized."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Dengue Fever but failed to provide comprehensive care. CBC, home monitoring instructions, and clear warning signs are essential for safe outpatient management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: high fever for 2-7 days plus body aches plus joint pain plus community context equals suspect Dengue."
    - clinical_score < 5:
        "You misdiagnosed Mang Jose's condition. Dengue is endemic in the Philippines. Always consider dengue in a patient with high fever, body aches, and joint pain, especially during the rainy season."
    - else:
        "Keep practicing! Dengue requires early recognition and close monitoring. Remember the warning signs: severe abdominal pain, persistent vomiting, bleeding, and decreased urine output."
}

-> END