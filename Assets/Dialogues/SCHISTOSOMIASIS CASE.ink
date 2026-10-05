// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Carlo (Patient) Sprites:
//   NEUTRAL/PALE = Carlo_0
//   WORRIED = Carlo_1
//   DEFENSIVE = Carlo_2
//   RELIEVED/GRATEFUL = Carlo_3
//
// Cousin Sprites:
//   NEUTRAL = carlo_cousin_0
//   WORRIED = carlo_cousin_1
//   DEFENSIVE = carlo_cousin_2
//   RELIEVED = carlo_cousin_3
//
// Close-Up Images:
//   Pale Face = Pale Face_0
//   Blood in Stool = Blood in Stool_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The rural primary care clinic is warm and humid. Carlo Dela Cruz, a 17-year-old boy, enters slowly with his older cousin. Carlo looks pale and tired. He has missed school several times because of abdominal discomfort. His cousin looks concerned.

# closeup: Pale Face_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Carlo closely. He looks pale and fatigued. He is slightly thin. He avoids eye contact.

# speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
"Doc, salamat po sa pagtanggap sa amin. Sumasakit po ang tiyan ko. Mga anim na buwan na. Minsan may dugo po sa dumi ko. Pagod na pagod din po ako."

# speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_0
"Doc, akala po namin simpleng sakit ng tiyan lang. Pero hindi na po nawawala. Napansin ko rin pong namumutla siya at pumapayat."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You note that Carlo has had abdominal pain for 6 months, with blood in his stool. He has lost weight and appears pale.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Carlo has been suffering for months. His cousin is worried. Your opening approach will determine whether they trust you enough to share important details.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Minimize the complaint]
    ~ trust_level = "LOW"
    ~ empathy_score = 1
    "Carlo, it is probably just something you ate. Drink more water and rest. If it gets worse, come back."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Carlo and his cousin stop sharing details. They look at each other, then at the floor.

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_2
    "Sige po, Doc. Salamat na lang."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust damaged. Trust Level: LOW. Carlo and his cousin feel dismissed.
    -> information_gathering

* [Choice B: Validate and ask about context (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Carlo, I can see you've been through a lot. Blood in the stool and symptoms lasting this long deserve a careful assessment. I would like to ask about your bowel symptoms, water exposure, and any warning signs. Would that be okay?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Carlo looks up. He looks relieved that someone is taking him seriously.

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_3
    "Salamat po, Doc. Akala ko po kasi wala lang ito. Pero natatakot na rin po ako."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Carlo and his cousin feel heard.
    -> information_gathering

* [Choice C: Announce the disease immediately]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Carlo, I think you have schistosomiasis. We need to treat you for that."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Carlo and his cousin become frightened.

    # speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_1
    "Doc, ano po iyon? Nakakahawa po ba? Paano po nakuha iyon?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: You labeled the condition before examination and testing. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about symptoms only]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Carlo, let's focus on your symptoms. When did the abdominal pain start? How often do you see blood in your stool?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Carlo answers your questions but remains guarded. He provides facts but does not elaborate.

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Mga anim na buwan na po. Yung dugo, hindi naman po palagi. Minsan lang."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Carlo has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about duration, frequency, and progression of symptoms]
    ~ info_score += 2
    "Carlo, when did the abdominal pain and bowel changes begin? Are they becoming more frequent? Is the blood in the stool getting worse?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Mga anim na buwan na po. Parang pabalik-balik. Ngayon, mas madalas na po ang loose stool. At may dugo po."

    -> information_gathering_2

* [Ask about danger signs: fever, vomiting, weight loss, jaundice, swelling]
    ~ info_score += 2
    "Carlo, have you had fever, vomiting, weight loss, severe weakness, yellowing of the eyes, or increasing abdominal swelling?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Pumapayat po ako kasi wala akong gana kumain. Wala naman po akong yellow eyes. Yung tiyan ko, parang mabigat minsan, pero hindi naman sobrang lumalaki."

    -> information_gathering_2

* [Ask about freshwater exposure]
    ~ info_score += 2
    "Carlo, do you ever swim, bathe, fish, wash clothes, cross, or work in freshwater? How often? Do you use protective footwear?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Lumulusong po ako sa ilog halos araw-araw para makatawid sa bukid. Minsan, naliligo na rin po ako doon kapag walang tubig sa bahay. Nakatsinelas lang po ako, minsan wala."

    -> information_gathering_2

* [Ask about household and community context]
    ~ info_score += 1
    "Carlo, has anyone else in your household or community had similar symptoms? Have they received treatment through a local health program?"

    # speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_0
    "May mga kapitbahay po kami na umiinom ng gamot tuwing may health activity. Si Carlo, hindi po nakasama noong huli kasi nasa eskwela siya."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# closeup: Blood in Stool_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You ask about the blood in his stool. Carlo describes it as a small amount, sometimes streaked on the surface.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about urgent warning signs today]
    ~ info_score += 2
    "Carlo, do you have severe abdominal pain, black or heavy bloody stool, fainting, confusion, repeated vomiting, trouble breathing, or sudden worsening weakness today?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Wala naman pong pagkahilo o hirap sa paghinga. Konti lang po ang dugo. Pero mas mahina po ako kaysa dati."

    -> diagnosis_phase

* [Ask about functional impact on school and daily life]
    ~ info_score += 1
    "Carlo, how has this affected your school and daily life? Are you able to function normally?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Hindi na po ako makapasok nang tuluy-tuloy sa eskwela. Nahihirapan po akong maglakad nang matagal. Pagod po ako palagi."

    -> diagnosis_phase

* [Ask about health literacy and understanding of the illness]
    ~ info_score += 1
    "Carlo, what do you know about your symptoms? What have you been told about what might be causing them?"

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Ang alam ko po, baka dahil sa tubig o pagkain. Sabi ng iba, baka sa ilog daw. Pero hindi ko po alam talaga."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Carlo has:
- Abdominal pain for 6 months, intermittent, with blood in stool
- Weight loss, fatigue, pallor
- No jaundice, no severe abdominal swelling
- No urgent warning signs today
- Frequent freshwater exposure (wading, bathing in river, barefoot)
- Household/community members with similar symptoms
- Missed community health treatment program

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Suspected Schistosomiasis (Requires Confirmation)]
    ~ clinical_score = 5
    "Carlo, your symptoms—the chronic abdominal pain, blood in the stool, weight loss, and fatigue—along with your frequent exposure to freshwater, suggest a possible parasitic infection called schistosomiasis. We cannot confirm this yet, but we need to arrange the appropriate tests through the health team. We should also check for other causes of gastrointestinal bleeding."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_1
    "Doc... malala po ba iyon? Ano po ang gagawin namin?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "It is treatable, but we need to confirm it first. We will arrange a stool examination and other tests. We will also connect you with the local health team for follow-up and possible community screening."

    -> management_phase

* [Choice B: Simple Stomach Infection]
    ~ clinical_score = 2
    "Carlo, this is probably just a simple stomach infection. Take something for the stomach and return only if it gets much worse."

    # speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_1
    "Doc... pero anim na buwan na po ito. At may dugo po sa dumi niya."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored persistent symptoms, blood in the stool, and a relevant freshwater exposure. This is unsafe.
    -> management_phase

* [Choice C: Intestinal Tuberculosis]
    ~ clinical_score = 2
    "Carlo, this could be intestinal tuberculosis. We should start you on anti-TB medications."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Doc... wala naman po akong ubo. At wala ring TB sa pamilya namin."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have suggested a diagnosis without considering the exposure history. Intestinal TB does not explain the freshwater exposure pattern.
    -> management_phase

* [Choice D: Amoebiasis]
    ~ clinical_score = 3
    "Carlo, this could be amoebiasis from contaminated water. We should start you on metronidazole."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Doc... pero anim na buwan na po ito. At lagi po akong nasa ilog."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Amoebiasis is a possibility, but the chronic duration and freshwater exposure make schistosomiasis more likely. You should not commit to a single diagnosis without testing.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Arrange Testing + Public Health Referral + Education]
    ~ safety_score = 4
    "Carlo, we have a pattern that needs proper assessment, not a final diagnosis. We will document your symptoms, arrange the appropriate stool or other tests through the health team, and discuss liver and blood-related assessment if clinically indicated. I will also connect you with the local health team for follow-up and possible community-based screening. Please follow local health-worker advice about testing and treatment."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_3
    "Salamat po, Doc. Akala ko po wala nang solusyon."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Until you receive guidance, avoid unnecessary contact with potentially unsafe freshwater when a safer option is available. Use protective footwear or clothing for necessary work, and ask the local health team about sanitation, safe water, and community prevention activities."

    -> education_phase

* [Choice B: Treat as Simple Stomach Infection + Send Home]
    ~ safety_score = 1
    "Take something for the stomach and return only if it gets much worse."

    # speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_1
    "Doc! Anim na buwan na po siyang ganito. Paano po kung lumala?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored persistent symptoms, blood in the stool, and a relevant freshwater exposure. This is unsafe.
    -> education_phase

* [Choice C: Promise One Medicine for Everyone]
    ~ safety_score = 2
    "Everyone in your household should take the same medicine today. That will cure all of you."

    # speaker: Cousin # portrait_left: Clear # portrait_right: carlo_cousin_1
    "Doc... lahat po? Hindi po ba kailangan muna ng test?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made treatment and household-management decisions without confirming infection, assessing each person, or following local clinical and public-health guidance. This is unsafe.
    -> education_phase

* [Choice D: Refer to Specialist Without Testing]
    ~ safety_score = 2
    "I'm going to refer you to a specialist. They can decide on the best treatment."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Doc... kailan po kami makakakita ng specialist? Malayo po ang ospital."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed appropriate testing and public-health referral by escalating unnecessarily. Schistosomiasis testing and community follow-up can be arranged through the local health team.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Carlo and his cousin leave, you have an opportunity to educate them about prevention and community health. Good patient education is part of patient safety.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain prevention and respectful risk assessment]
    ~ safety_score += 1
    "Carlo, you did not cause this by helping your family. Asking about river exposure helps us understand risk, and it is important that we ask respectfully rather than blame people for the conditions they live and work in. To prevent infection in the future: avoid unnecessary contact with potentially unsafe freshwater when a safer option is available. Use protective footwear or clothing for necessary work. And ask the local health team about sanitation, safe water, and community prevention activities."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_3
    "Doc, salamat po. Akala ko po kasi ako ang may kasalanan. Ngayon, alam ko na ang gagawin namin."

    -> ending

* [Choice B: Just tell them to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 1 week."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention or community follow-up. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about exposure]
    ~ safety_score += 1
    "Carlo, think of the river water like a place where tiny parasites can live. If your skin touches the water for a long time, they can get in. That's why we use boots and avoid unnecessary contact. It's like wearing a raincoat in the rain—not because you did something wrong, but because it protects you."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_3
    "Ah, ganun pala iyon, Doc. Parang kapote lang sa ulan. Salamat, naiintindihan ko na."

    -> ending

* [Choice D: Give a pamphlet about schistosomiasis]
    ~ safety_score += 0
    "Here's a pamphlet about schistosomiasis. Read it when you get home."

    # speaker: Carlo # portrait_left: Clear # portrait_right: Carlo_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At malabo po ang mata ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Safety score unchanged.
    -> ending


// --- SCENE 8: ENDING & FEEDBACK ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. The patient and his cousin leave the clinic.

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
        "Excellent work! You recognized the possible exposure-related pattern of schistosomiasis without labeling the condition prematurely, addressed Carlo's and his cousin's concerns with empathy, arranged proper testing and public-health follow-up, and provided respectful prevention education. Schistosomiasis remains endemic in selected Philippine communities—your comprehensive, non-blaming approach will help Carlo and his family access appropriate care."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct clinical assessment and arranged appropriate follow-up, but Carlo and his cousin left feeling judged. Remember, endemic diseases are tied to structural water and sanitation limitations—not personal failings. Approach families with respect."
    - clinical_score == 5 and safety_score < 5:
        "You correctly recognized the possible diagnosis but failed to provide comprehensive care. Testing, public-health referral, and prevention education are essential parts of management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: chronic abdominal pain + blood in the stool + weight loss + freshwater exposure = suspect Schistosomiasis."
    - clinical_score < 5:
        "You misdiagnosed Carlo's condition. Schistosomiasis is endemic in selected Philippine communities. Always ask about freshwater exposure in patients with chronic gastrointestinal symptoms, and arrange appropriate testing."
    - else:
        "Keep practicing! Schistosomiasis is a neglected tropical disease in the Philippines. Remember the key steps: ask about exposure without blaming, recognize the pattern, arrange testing and public-health follow-up, and educate on prevention."
}

-> END