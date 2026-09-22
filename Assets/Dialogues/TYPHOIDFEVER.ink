// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- SCENE 1: INTRODUCTION ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is warm. Andrei, a 22-year-old college student, enters slowly. He looks pale and exhausted. He is holding his abdomen and appears weak. He sits down carefully, grimacing in pain.

# speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
"Doc, ilang araw na akong nilalagnat. Sumasakit ang ulo ko at ang tiyan ko. Nagsusuka rin ako. Hindi na ako maka-pasok sa klase."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Andrei looks dehydrated. His lips are dry. He has a flushed face. He is sweating despite the air conditioning.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
"Let me check your temperature."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You take his temperature. It is 39.2°C.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
"Andrei, when did your symptoms start? Can you tell me more about what you've been feeling?"

# speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
"Doc, mga limang araw na. Nagsimula siya sa lagnat. Tapos sumakit ang ulo ko. Tapos sumakit ang tiyan ko. Ngayon, nagsusuka ako at nagtatae. Hindi ako makakain. Ang pangit ng lasa ng pagkain."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You note that Andrei has had fever for 5 days with headache, abdominal pain, nausea, and diarrhea. The Philippine Clinical Practice Guidelines state that a patient with fever of 5 days or more, documented temperature above 38°C, with any of these symptoms should be considered a suspected typhoid fever case.

// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Andrei has been sick for 5 days and is struggling to keep up with his studies. Your approach will determine whether he trusts you.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Andrei, let's focus on your symptoms. When exactly did the fever start? Is it continuous? Do you have chills? What about your bowel movements?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Andrei answers your questions, but he looks uncomfortable. He feels like he's being interrogated.

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Yung lagnat ko... palagi. Parang hindi nawawala. Minsan nanginginig ako. Yung tae ko... matubig na. Minsan may dugo."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Andrei feels like just another case.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Andrei, I can see you're really struggling. Five days of fever is a long time. Can you tell me what your life has been like this past week? What do you usually eat? Where do you live?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Andrei relaxes slightly. He looks relieved that someone is listening to his story.

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc, nagbo-boarding house ako. Mahirap ang tubig. Minsan nawawalan. Kadalasan, kumakain ako sa karinderya o kaya street food. Hindi ko na alam kung saan ako nagkamali."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Andrei feels heard and understood.
    -> information_gathering

* [Choice C: Focus on Food and Sanitation]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Andrei, do you eat street food? Do you wash your hands before eating? Typhoid is often caused by poor sanitation."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Andrei becomes defensive.

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_2
    "Doc, wala naman akong choice! Mahirap kumain ng maayos sa boarding house. Hindi ko naman ginusto na magkasakit!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. You gather Andrei's history and examine him:

- Fever for 5 days, documented at 39.2°C
- Headache, abdominal pain, nausea, vomiting, diarrhea
- Blood-streaked stools noted
- Anorexia (loss of appetite)
- Lives in a boarding house with intermittent water supply
- Regularly eats street food and at karinderyas
- No known chronic illnesses

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
These findings meet the criteria for suspected Typhoid Fever: fever of 5 days or more, temperature above 38°C, with gastrointestinal symptoms.

The 2017 Philippine Clinical Practice Guidelines on Typhoid Fever recommend that any individual who presents with fever of 5 days or more, documented fever above 38°C, with any of the following symptoms—headache, diarrhea, body malaise or weakness, abdominal distention or pain, gastrointestinal bleeding, or changes in orientation or confusion—should be considered a suspected typhoid fever case.

~ info_score = 5
-> diagnosis_phase

// --- SCENE 4: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Based on the fever for 5 days, headache, abdominal pain, vomiting, diarrhea, and possible exposure to contaminated food or water, what is your leading diagnosis?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Diagnose: Typhoid Fever]
    ~ clinical_score = 5
    "Andrei, I believe you have Typhoid Fever. It's a bacterial infection caused by Salmonella typhi. The bacteria is spread through contaminated food or water, and it sounds like you may have been exposed through street food or your boarding house's water supply. The fever for 5 days, headache, and stomach symptoms are classic signs."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... malala ba ito? Kailangan ko bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "We need to confirm with a blood culture or stool culture to detect the Salmonella typhi bacteria. The Widal test is no longer recommended for diagnosis because of false positives. If confirmed, we can treat you with antibiotics. If your symptoms are severe, we may need to admit you for IV antibiotics and fluids."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Andrei looks worried but relieved to finally have an answer.

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. At least alam ko na kung ano ang sakit ko."

    -> management_phase

* [Diagnose: Dengue Fever]
    ~ clinical_score = 2
    "The fever, headache, and body aches could be Dengue. We should do a complete blood count to check your platelets."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung tiyan ko? Yung pagsusuka at pagtatae? Hindi naman ganyan ang dengue diba?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the gastrointestinal symptoms. Dengue typically does not present with prolonged diarrhea and abdominal pain without other hemorrhagic signs.
    -> management_phase

* [Diagnose: Gastroenteritis]
    ~ clinical_score = 2
    "This could be acute gastroenteritis. We'll give you antibiotics and fluids."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung lagnat ko? Limang araw na. Hindi ba masyadong matagal na para sa gastroenteritis?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the duration of fever. Gastroenteritis typically resolves within 3-5 days without fever persisting this long.
    -> management_phase

// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Order Blood Culture + Start Azithromycin + Hydration + Follow-up]
    ~ safety_score = 5
    "Andrei, I'm going to order a blood culture to confirm the diagnosis. The Widal test is no longer recommended because it can give false positives. While we wait for the results, I'll start you on antibiotics. The Philippine guidelines recommend Azithromycin 500 mg once daily for 7 days for uncomplicated typhoid fever. You also need to drink plenty of fluids—oral rehydration solution, water, or juice to replace what you've lost. Come back in 3 days for the results and we'll check your progress."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... magkano po ang gamot? Student lang po ako."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Azithromycin is available at the health center pharmacy at a subsidized cost. You can also apply for PhilHealth assistance if needed. Your priority is to get better—we can figure out the finances later."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Andrei nods, looking relieved.

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. May pag-asa pa pala."
    -> ending

* [Widal Test + Empiric Antibiotics]
    ~ safety_score = 3
    "I'll order a Widal test to confirm typhoid and start you on Ciprofloxacin."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... sabi ng classmate ko, hindi na raw ginagamit ang Widal test?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have used an outdated diagnostic test. The Widal test is no longer recommended for diagnosing typhoid fever due to false positives. Blood culture is the gold standard.
    -> ending

* [Send Home with Paracetamol + Fluids Only]
    ~ safety_score = 1
    "Just take paracetamol for the fever and drink plenty of fluids. Come back if you don't improve."

    # speaker: Andrei # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! Limang araw na akong may lagnat! Hindi na ako makakain! Paano ako gagaling nang walang gamot?!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have made a critical mistake. Typhoid fever requires antibiotic treatment to prevent complications such as intestinal perforation, which occurs in 1-3% of hospitalized cases and can be fatal. Sending a patient home without antibiotics is a failure of patient safety.
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
        "Excellent work! You recognized the classic presentation of Typhoid Fever: fever for 5 days with headache, abdominal pain, and diarrhea. You followed the Philippine Clinical Practice Guidelines by ordering blood culture instead of the outdated Widal test, and started appropriate antibiotics. Typhoid fever remains a public health concern in the Philippines—your prompt action is crucial for preventing complications."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate treatment, but Andrei left feeling judged. Remember to approach patients with empathy—many are unaware of the risks of contaminated food and water."
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