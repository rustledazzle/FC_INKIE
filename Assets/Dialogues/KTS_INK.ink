// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Aling Rosa (Mother) Sprites:
//   Tired/Exhausted = AlingRosaNegative_0
//   Anxious/Worried = AlingRosaNegative_1
//   Crying a bit = AlingRosaNegative_2
//   Relaxed = AlingRosaPositive_0
//   Happy = AlingRosaPositive_1
//   Normal = AlingRosaPositive_2
//
// Close-Up Images:
//   Doctor's hand lifting right leg clothing, baby's legs 3/4 body = KTSCASE_0
//   Baby's left leg being viewed = KTSCASE2_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The clinic room is warm. Aling Rosa enters carrying her 7-month-old daughter, Maya. The baby is fussy, pulling at her left leg. Rosa looks exhausted.

# speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_0
"Doc, salamat po sa pagtanggap sa amin. Si Maya po, since last night, mainit ang katawan niya. Hindi siya makatulog, umiiyak ng umiiyak."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
She hesitates, then gently pulls up Maya's onesie to reveal the left leg.

# closeup: KTSCASE_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe the left leg. A distinct, dark red-purple macular stain covers much of the thigh—consistent with a capillary malformation or port-wine stain.

# closeup: KTSCASE2_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Notably, the left leg appears slightly longer and bulkier than the right. The skin over the stain feels warm.

# speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_1
"Pero ito po ang talagang kinakatakutan ko. 'Yung birthmark niya... lumalaki. At mainit sa hawak. Sabi ng kapitbahay ko, baka naiinitan lang daw. Pero nakita ko sa Facebook, baka daw ito yung... Klippel-something?"


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
How do you begin this consultation? Your approach will establish trust—or create distance.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Good morning, Aling Rosa. Let's start with Maya's symptoms. When exactly did the fever start? Have you taken her temperature? And this birthmark—when did you first notice it getting bigger?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Rosa answers efficiently, providing clinical data. But her eyes remain downcast. She is a source of information, not a partner in care.

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_0
    "Yung lagnat, kagabi lang. Hindi ko nasukat, pero mainit talaga. Yung birthmark, meron na siya nung pinanganak siya. Pero ngayon lang lumaki."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Aling Rosa feels like just another case.
    -> information_gathering

* [Choice B: Focus on the Mother's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Rosa, I can see how worried you are. You mentioned seeing something on Facebook about Klippel-something. Tell me more about that—what have you been reading? And more importantly, how are you coping with all of this?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa's shoulders relax slightly. For the first time, she meets your eyes. She feels heard.

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_2
    "Doc, nag-iisa lang po ako. Ang asawa ko, nagtatrabaho sa Maynila. Ako lang ang nag-aalaga kay Maya. Nung nakita ko sa Facebook yung mga larawan ng batang may Klippel... natakot ako. Kasi kamukha ni Maya."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_2
    "Hindi ako nakatulog ng tatlong araw. Iniisip ko, paano kung lumala?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Aling Rosa feels heard and understood.
    -> information_gathering

* [Choice C: Focus on Safety / Psychosocial Screening]
    ~ trust_level = "LOW"
    ~ empathy_score = 1
    "Aling Rosa, before we discuss Maya's symptoms, I need to ask—how are you feeling? Are you getting enough rest? Any thoughts of harming yourself or Maya?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa recoils, visibly offended.

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_0
    "Doc! Bakit niyo po ako tatanungin niyan? Nandito po ako para kay Maya. Hindi ako baliw. Siyempre, pagod ako—sino bang hindi pagod? Pero hindi ko sasaktan ang anak ko!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust damaged. Trust Level: LOW. Rosa becomes defensive and guarded.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
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

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_0
    "Doc... may lunas po ba? Ano po ang gagawin namin?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "We need to confirm this with an ultrasound and genetic testing. But there is treatment. A medication called sirolimus has been shown to help children like Maya. It calms down the abnormal blood vessels and reduces the overgrowth."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa begins to cry—but they are tears of relief.

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_2
    "May pag-asa po pala. Akala ko... akala ko wala na."
    -> management_phase

* [Diagnose: Dengue Hemorrhagic Fever]
    ~ clinical_score = 2
    "Aling Rosa, given the fever and the season, this might be Dengue. We need to monitor her platelet count."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_1
    "Doc... pero bakit lumalaki yung birthmark niya? Yung kapitbahay ko nagka-dengue, hindi naman lumaki yung mga marks niya."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key physical finding. Dengue does not cause progressive limb overgrowth.
    -> management_phase

* [Diagnose: Osteomyelitis (Bone Infection)]
    ~ clinical_score = 2
    "Rosa, this could be a bone infection. The fever, the warmth, the swelling—it's classic for osteomyelitis."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_1
    "Pero Doc, yung birthmark niya po, meron na siya nung pinanganak siya. Hindi naman po siya nadapa o nasugatan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored the congenital nature of the lesion. Osteomyelitis is acute; this has been present since birth.
    -> management_phase


// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Refer to Specialist + PhilHealth / Malasakit Center]
    ~ safety_score = 5
    "I am going to refer Maya to a pediatric vascular specialist. We can also refer you to the Malasakit Center to help with the costs of the genetic testing."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaPositive_1
    "Doc... maraming salamat. Sa wakas, may gumagabay sa amin."
    -> ending

* [Observation Only / Send Home with Paracetamol]
    ~ safety_score = 1
    "Let's just observe Maya for now. Give her paracetamol for the fever. Monitor the leg at home. If it gets worse, come back."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_1
    "Doc... but what if it gets worse at home? Ako lang po mag-isa. Paano kung lumaki pa?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Rosa leaves with no clear plan. She is anxious, alone, and unsupported.
    -> ending

* [Immediate Hospital Admission]
    ~ safety_score = 2
    "This is serious. I am admitting Maya to the hospital immediately for IV antibiotics."

    # speaker: Aling Rosa # portrait_left: Clear # portrait_right: AlingRosaNegative_1
    "Doc! Hindi ko po kaya. May iba pa akong anak sa bahay. Wala akong maiiwan sa kanila."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated too quickly without considering Rosa's social context. She is overwhelmed and resistant.
    -> ending


// --- SCENE 6: END OF SCENARIO ---
== ending ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The consultation has ended. The patient leaves the clinic.
-> END