// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Marco (Patient) Sprites:
//   WEAK/TIRED = Marco_0
//   GUARDED/DEFENSIVE = Marco_1
//   WORRIED = Marco_2
//   RELIEVED/GRATEFUL = Marco_3
//
// Close-Up Images:
//   Flushed Face = Flushed Face_0
//   Rose Spots = Rose Spots_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is warm. Marco, a 22-year-old college student, enters slowly. He looks pale and exhausted. He is holding his abdomen and appears weak. He sits down carefully, grimacing in pain.

# closeup: Flushed Face_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Marco looks dehydrated. His lips are dry. His face is flushed. He is sweating despite the air conditioning.

# speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
"Doc, ilang araw na akong nilalagnat. Sumasakit ang ulo ko at ang tiyan ko. Nagsusuka rin ako. Hindi na ako maka-pasok sa klase."

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
"Let me check your temperature."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You take his temperature. It is 39.2°C.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
"Marco, when did your symptoms start? Can you tell me more about what you've been feeling?"

# speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
"Doc, mga limang araw na. Nagsimula siya sa lagnat. Tapos sumakit ang ulo ko. Tapos sumakit ang tiyan ko. Ngayon, nagsusuka ako at nagtatae. Hindi ako makakain. Ang pangit ng lasa ng pagkain."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You note that Marco has had fever for 5 days with headache, abdominal pain, nausea, and diarrhea. The Philippine Clinical Practice Guidelines state that a patient with fever of 5 days or more, documented temperature above 38°C, with any of these symptoms should be considered a suspected typhoid fever case.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Marco has been sick for 5 days and is struggling to keep up with his studies. Your approach will determine whether he trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Marco, let's focus on your symptoms. When exactly did the fever start? Is it continuous? Do you have chills? What about your bowel movements?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marco answers your questions, but he looks uncomfortable. He feels like he's being interrogated.

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Yung lagnat ko... palagi. Parang hindi nawawala. Minsan nanginginig ako. Yung tae ko... matubig na. Minsan may dugo."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Marco feels like just another case.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Marco, I can see you're really struggling. Five days of fever is a long time. Can you tell me what your life has been like this past week? What do you usually eat? Where do you live?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marco relaxes slightly. He looks relieved that someone is listening to his story.

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc, nagbo-boarding house ako. Mahirap ang tubig. Minsan nawawalan. Kadalasan, kumakain ako sa karinderya o kaya street food. Hindi ko na alam kung saan ako nagkamali."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Marco feels heard and understood.
    -> information_gathering

* [Choice C: Focus on Food and Sanitation]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Marco, do you eat street food? Do you wash your hands before eating? Typhoid is often caused by poor sanitation."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marco becomes defensive.

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_1
    "Doc, wala naman akong choice! Mahirap kumain ng maayos sa boarding house. Hindi ko naman ginusto na magkasakit!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Marco has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about red flags: blood in stool, severe abdominal pain, confusion]
    ~ info_score += 2
    "Marco, I need to check for warning signs. Is there any blood in your stool? Any severe abdominal pain? Any confusion or changes in orientation?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "May dugo po sa dumi ko. Yung sakit ng tiyan, hindi naman sobrang tindi. Wala naman po akong pagkalito."

    -> information_gathering_2

* [Ask about associated symptoms: headache, muscle pain, appetite]
    ~ info_score += 2
    "Marco, besides the fever and stomach symptoms, do you have any headache, muscle pain, or loss of appetite?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "May sakit po ang ulo ko. Sumasakit din ang katawan ko. At wala po akong gana kumain. Ang pangit ng lasa ng pagkain."

    -> information_gathering_2

* [Ask about travel and exposure history]
    ~ info_score += 1
    "Marco, have you traveled recently? Any exposure to contaminated water or food?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Wala naman po akong nilakbay. Dito lang po ako sa school at boarding house. Yun nga po, mahirap ang tubig namin."

    -> information_gathering_2

* [Ask about medical history and vaccination]
    ~ info_score += 2
    "Marco, do you have any other medical conditions? Have you received the typhoid vaccine?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Wala naman po akong ibang sakit. Wala rin po akong bakuna sa typhoid. Hindi ko po alam na may ganun pala."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# closeup: Rose Spots_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You examine Marco's torso. You note faint, rose-colored maculopapular lesions—consistent with rose spots of Typhoid Fever.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about fluid intake and hydration]
    ~ info_score += 2
    "Marco, how much water have you been drinking? Are you able to keep fluids down?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Mahirap po painumin. Nagsusuka po ako. Konti lang po ang naiinom ko."

    -> diagnosis_phase

* [Ask about functional impact]
    ~ info_score += 1
    "Marco, how has this affected your studies and daily life? Are you able to function?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Hindi na po ako makapasok sa klase. Nahihirapan po akong maglakad. Pagod na pagod po ako."

    -> diagnosis_phase

* [Ask about health literacy and understanding]
    ~ info_score += 1
    "Marco, what do you know about your symptoms? What have you been told about what might be causing them?"

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Ang alam ko po, baka sa tubig o pagkain. Sabi ng kaibigan ko, baka typhoid daw. Pero hindi ko po alam talaga."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Marco has:
- Fever for 5 days, documented at 39.2°C
- Headache, abdominal pain, nausea, vomiting, diarrhea
- Blood-streaked stools noted
- Anorexia (loss of appetite)
- Rose spots on torso
- Lives in a boarding house with intermittent water supply
- Regularly eats street food
- No known chronic illnesses

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Typhoid Fever]
    ~ clinical_score = 5
    "Marco, I believe you have Typhoid Fever. It's a bacterial infection caused by Salmonella typhi. The bacteria is spread through contaminated food or water, and it sounds like you may have been exposed through street food or your boarding house's water supply. The fever for 5 days, headache, and stomach symptoms are classic signs."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_2
    "Doc... malala ba ito? Kailangan ko bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "We need to confirm with a blood culture or stool culture to detect the Salmonella typhi bacteria. The Widal test is no longer recommended for diagnosis because of false positives. If confirmed, we can treat you with antibiotics. If your symptoms are severe, we may need to admit you for IV antibiotics and fluids."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marco looks worried but relieved to finally have an answer.

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_3
    "Salamat, Doc. At least alam ko na kung ano ang sakit ko."

    -> management_phase

* [Choice B: Dengue Fever]
    ~ clinical_score = 2
    "The fever, headache, and body aches could be Dengue. We should do a complete blood count to check your platelets."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc... pero yung tiyan ko? Yung pagsusuka at pagtatae? Hindi naman ganyan ang dengue diba?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the gastrointestinal symptoms. Dengue typically does not present with prolonged diarrhea and abdominal pain without other hemorrhagic signs.
    -> management_phase

* [Choice C: Gastroenteritis]
    ~ clinical_score = 2
    "This could be acute gastroenteritis. We'll give you antibiotics and fluids."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc... pero yung lagnat ko? Limang araw na. Hindi ba masyadong matagal na para sa gastroenteritis?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the duration of fever. Gastroenteritis typically resolves within 3-5 days without fever persisting this long.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Order Blood Culture + Start Azithromycin + Hydration + Follow-up]
    ~ safety_score = 4
    "Marco, I'm going to order a blood culture to confirm the diagnosis. The Widal test is no longer recommended because it can give false positives. While we wait for the results, I'll start you on antibiotics. The Philippine guidelines recommend Azithromycin 500 mg once daily for 7 days for uncomplicated typhoid fever. You also need to drink plenty of fluids—oral rehydration solution, water, or juice to replace what you've lost. Come back in 3 days for the results and we'll check your progress."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_2
    "Doc... magkano po ang gamot? Student lang po ako."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Azithromycin is available at the health center pharmacy at a subsidized cost. You can also apply for PhilHealth assistance if needed. Your priority is to get better—we can figure out the finances later."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Marco nods, looking relieved.

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_3
    "Salamat, Doc. May pag-asa pa pala."

    -> education_phase

* [Choice B: Widal Test + Empiric Antibiotics]
    ~ safety_score = 3
    "I'll order a Widal test to confirm typhoid and start you on Ciprofloxacin."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc... sabi ng classmate ko, hindi na raw ginagamit ang Widal test?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have used an outdated diagnostic test. The Widal test is no longer recommended for diagnosing typhoid fever due to false positives. Blood culture is the gold standard.
    -> education_phase

* [Choice C: Send Home with Paracetamol + Fluids Only]
    ~ safety_score = 1
    "Just take paracetamol for the fever and drink plenty of fluids. Come back if you don't improve."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_1
    "Doc! Limang araw na akong may lagnat! Hindi na ako makakain! Paano ako gagaling nang walang gamot?!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made a critical mistake. Typhoid fever requires antibiotic treatment to prevent complications such as intestinal perforation, which occurs in 1-3% of hospitalized cases and can be fatal. Sending a patient home without antibiotics is a failure of patient safety.
    -> education_phase

* [Choice D: Refer to Specialist Without Treatment]
    ~ safety_score = 2
    "I'm going to refer you to a specialist. They can decide on the best treatment."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc... kailan po ako makakakita ng specialist? Baka hindi na umabot."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed treatment by referring to a specialist unnecessarily. Uncomplicated typhoid fever can be managed in primary care.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Marco leaves, you have an opportunity to educate him about prevention and home management. Good patient education is part of patient safety.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain prevention and safe water practices]
    ~ safety_score += 1
    "Marco, typhoid fever is spread through contaminated food and water. To prevent this in the future: always drink boiled or purified water. Eat food that is freshly cooked and still hot. Wash your hands before eating and after using the toilet. And consider getting the typhoid vaccine. These simple steps can protect you."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_3
    "Doc, naiintindihan ko na. Akala ko kasi okay lang ang street food. Ngayon, alam ko na ang gagawin ko."

    -> ending

* [Choice B: Just tell him to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 3 days."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about contaminated water]
    ~ safety_score += 1
    "Marco, think of contaminated water like a dirty glass. If you drink from it, you get sick. Boiling water is like washing the glass—it kills the germs. And washing your hands is like keeping your hands clean before touching food. It's that simple."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_3
    "Ah, ganun pala iyon, Doc. Parang hugasan lang ang baso. Salamat, naiintindihan ko na."

    -> ending

* [Choice D: Give him a pamphlet about typhoid]
    ~ safety_score += 0
    "Here's a pamphlet about typhoid fever. Read it when you get home."

    # speaker: Marco # portrait_left: Clear # portrait_right: Marco_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At wala po akong oras ngayon."

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
        "Excellent work! You recognized the classic presentation of Typhoid Fever: fever for 5 days with headache, abdominal pain, and diarrhea. You followed the Philippine Clinical Practice Guidelines by ordering blood culture instead of the outdated Widal test, and started appropriate antibiotics. Typhoid fever remains a public health concern in the Philippines—your prompt action is crucial for preventing complications."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate treatment, but Marco left feeling judged. Remember to approach patients with empathy—many are unaware of the risks of contaminated food and water."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Typhoid Fever but failed to treat appropriately. Typhoid requires antibiotics to prevent serious complications like intestinal perforation. Always provide definitive treatment."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: fever for 5 days or more plus headache plus abdominal symptoms plus possible exposure to contaminated food or water equals suspect Typhoid Fever."
    - clinical_score < 5:
        "You misdiagnosed Typhoid Fever. The key clue is fever lasting 5 days or more with gastrointestinal symptoms. In the Philippines, typhoid remains endemic with thousands of cases reported. Consider this diagnosis early."
    - else:
        "Keep practicing! Typhoid fever is a common but preventable disease. Remember the diagnostic criteria: fever of 5 days or more, temperature above 38°C, with headache, diarrhea, or abdominal pain."
}

-> END