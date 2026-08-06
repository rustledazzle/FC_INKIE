// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- SCENE 1: INTRODUCTION ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic room is warm. Aling Rosa enters carrying her 7-month-old daughter, Maya. The baby is fussy, pulling at her left leg. Rosa looks exhausted.

# speaker: Aling Rosa # portrait_left: Clear # portrait_right: patientVN_1
"Doc, salamat po sa pagtanggap sa amin. Si Maya po, since last night, mainit ang katawan niya. Hindi siya makatulog, umiiyak ng umiiyak."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
//--- clear portrait
She hesitates, then gently pulls up Maya's onesie to reveal the left leg.

# speaker: Aling Rosa # portrait_left: Clear # portrait_right: patientVN_1
"Pero ito po ang talagang kinakatakutan ko. 'Yung birthmark niya... lumalaki. At mainit sa hawak. Sabi ng kapitbahay ko, baka naiinitan lang daw. Pero nakita ko sa Facebook, baka daw ito yung... Klippel-something?"

// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Player # portrait_left: residentVN_2 # portrait_right: Clear
* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Good morning, Aling Rosa. Let's start with Maya's symptoms. When exactly did the fever start? And this birthmark—when did you first notice it getting bigger?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Rosa answers efficiently, providing clinical data. But her eyes remain downcast. She is a source of information, not a partner in care.
    -> information_gathering

* [Choice B: Focus on Mother's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Rosa, I can see how worried you are. You mentioned seeing something on Facebook. Tell me more about that—what have you been reading? And how are you coping?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa's shoulders relax slightly. For the first time, she meets your eyes. She feels heard.
    
    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: patientVN_1
    "Doc, nag-iisa lang po ako. Nung nakita ko sa Facebook yung mga larawan... natakot ako. Hindi ako nakatulog ng tatlong araw. Iniisip ko, paano kung lumala?"
    -> information_gathering

* [Choice C: Focus on Safety / Psychosocial Screening]
    ~ trust_level = "LOW"
    ~ empathy_score = 1
    "Aling Rosa, before we discuss Maya's symptoms, I need to ask—are you getting enough rest? Any thoughts of harming yourself or Maya?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa recoils, visibly offended.
    
    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: PatientVN_2
    "Doc! Bakit niyo po ako tatanungin niyan? Hindi ako baliw. Siyempre, pagod ako—sino bang hindi? Pero hindi ko sasaktan ang anak ko!"
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_right: Clear # portrait_left: Clear
You proceed with the consultation. You ask several questions about Maya's medical history, feeding habits, and family background, successfully gathering all necessary information.
~ info_score = 5 
-> diagnosis_phase


// --- SCENE 4: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Based on the history and physical exam (port-wine stain, leg overgrowth, warmth), what is your leading diagnosis?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Diagnose: Klippel-Trenaunay Syndrome (KTS)]
    ~ clinical_score = 5
    "Aling Rosa, I believe Maya may have a condition called Klippel-Trenaunay Syndrome. It matches what we're seeing: the port-wine stain, and the leg overgrowth."
    
    # speaker: Aling Rosa # portrait_left: residentVN_2 # portrait_right: patientVN_1
    "Doc... may lunas po ba? Ano po ang gagawin namin?"
    -> management_phase

* [Diagnose: Dengue Hemorrhagic Fever]
    ~ clinical_score = 2
    "Aling Rosa, given the fever and the season, this might be Dengue. We need to monitor her platelet count."
    
    # speaker: Aling Rosa # portrait_left: residentVN_0 # portrait: patientVN_2
    "Doc... pero bakit lumalaki yung birthmark niya? Yung kapitbahay ko nagka-dengue, hindi naman lumaki yung mga marks niya."
    -> management_phase

* [Diagnose: Osteomyelitis (Bone Infection)]
    ~ clinical_score = 2
    "Rosa, this could be a bone infection. The fever, the warmth, the swelling—it's classic for osteomyelitis."
    
    # speaker: Aling Rosa # portrait_left: residentVN_0 # portrait: patientVN_1
    "Pero Doc, yung birthmark niya po, meron na siya nung pinanganak siya. Hindi naman po siya nadapa o nasugatan."
    -> management_phase


// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Refer to Specialist + PhilHealth / Malasakit Center]
    ~ safety_score = 5
    "I am going to refer Maya to a pediatric vascular specialist. We can also refer you to the Malasakit Center to help with the costs of the genetic testing."
    
    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: patientVN_0
    "Doc... maraming salamat. Sa wakas, may gumagabay sa amin."
    -> ending

* [Observation Only / Send Home with Paracetamol]
    ~ safety_score = 1
    "Let's just observe Maya for now. Give her paracetamol for the fever. Monitor the leg at home. If it gets worse, come back."
    
    # speaker: Aling Rosa # portrait_left: residentVN_2 # portrait_right: patientVN_2
    "Doc... but what if it gets worse at home? Ako lang po mag-isa. Paano kung lumaki pa?"
    -> ending

* [Immediate Hospital Admission]
    ~ safety_score = 2
    "This is serious. I am admitting Maya to the hospital immediately for IV antibiotics."
    
    # speaker: Aling Rosa # portrait_left: residentVN_1 # portrait_right: patientVN_2
    "Doc! Hindi ko po kaya. May iba pa akong anak sa bahay. Wala akong maiiwan sa kanila."
    -> ending


// --- SCENE 6: END OF SCENARIO ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. The patient leaves the clinic.
-> END