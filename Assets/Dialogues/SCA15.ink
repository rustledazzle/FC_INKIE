// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The neurology clinic is quiet. Maria, a 36-year-old Filipina, sits in a wheelchair, her hands resting unsteadily on her lap. Her older sister, Elena, stands beside her, holding a thick folder of medical records. Maria attempts to smile, but her facial muscles tremor. Her speech is slow and slurred.

# speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
"Doc, salamat po sa pagtanggap sa amin. Ako po si Elena, ate ni Maria. Si Maria po, hirap na hirap na siya maglakad at magsalita. Lumalala po ito sa nakalipas na sampung taon."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Maria closely. She has a wide-based, unsteady gait when she attempts to stand. Her speech is dysarthric—slow, slurred, and difficult to understand. Her hands show intentional tremors when she reaches for anything.

# speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
"D-Doc... dati... nakakalakad pa ako... ngayon... hirap na..."

# speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
"Doc, marami na kaming napuntahang doktor. Walang makapagsabi kung ano ang sakit niya. Sabi ng iba, psychological lang daw. Pero alam ko, may mali talaga. Doc... last na po ito. Kung wala pa rin... baka sumuko na kami."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Maria has been dismissed by multiple doctors for ten years. Your approach will determine whether she finally feels heard.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Good morning, Maria. Let's start with your symptoms. When exactly did you first notice difficulty walking? And the speech problems—when did those begin?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria attempts to answer, but her speech is slow. Elena steps in to provide the timeline. Maria looks down at her hands, frustrated.
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Mga sampung taon na po. Unti-unti. Una, nadadapa siya. Tapos, nahihirapan siya magsalita. Ngayon, hindi na siya makalakad nang walang tulong."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Maria feels like just another case.
    -> information_gathering

* [Choice B: Focus on the Patient's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Maria, Elena. I can see you've been through a lot. Ten years is a long time to live with this uncertainty. Maria, can you tell me—what was your life like before this started? What do you miss the most?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria's eyes well up with tears. Elena puts a hand on her sister's shoulder.
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "D-Dati... nagtatrabaho ako... bilang... guro... mahal ko... ang mga bata... Ngayon... hindi na... ako makapagturo..."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "First time po na may nagtanong sa kanya kung ano ang na-miss niya. Usually, symptoms lang ang tinatanong."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Maria and Elena feel seen and heard.
    -> information_gathering

* [Choice C: Focus on Family History / Genetics First]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Maria, Elena. Given the progressive nature of these symptoms, I need to ask—is there a family history of similar conditions? Any relatives who had difficulty walking or speaking?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Elena's face pales. She looks at Maria nervously.
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... bakit po? May kaugnayan ba iyon?"
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "Ate... sabihin mo... sa kanya..."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... marami po sa pamilya namin ang may ganito. Ang nanay namin, namatay dahil dito. Ang tito, ang mga pinsan... mga 18 katao po."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Critical genetic information obtained, but the patient feels like a data point. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. You review Maria's records and perform a neurological examination. You note: wide-based ataxic gait, scanning dysarthria, intention tremors, and bilateral cerebellar atrophy on MRI. Elena reveals that 18 family members have been affected, with 10 already deceased. This autosomal dominant pattern points to a hereditary ataxia—likely Spinocerebellar Ataxia Type 15 (SCA15).
~ info_score = 5
-> diagnosis_phase


// --- SCENE 4: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Based on the progressive cerebellar ataxia, autosomal dominant family history (18 affected relatives), and bilateral cerebellar atrophy on MRI, what is your leading diagnosis?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Diagnose: Spinocerebellar Ataxia Type 15 (SCA15)]
    ~ clinical_score = 5
    "Maria, Elena. I believe this is a type of Spinocerebellar Ataxia—specifically, SCA15. It's a rare genetic condition that affects the cerebellum. The progressive symptoms, the cerebellar atrophy on MRI, and most importantly, the strong family history—18 affected relatives—all point to a hereditary ataxia. We need genetic testing to confirm mutations in the ITPR1 gene."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "SCA... 15? Doc, may gamot po ba?"
    
    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "There is no cure yet, but we can do genetic testing to confirm the diagnosis. If we find the specific gene mutation, we can provide you with accurate information about inheritance, prognosis, and connect you with support groups and rehabilitation services."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Elena grips Maria's hand tightly.
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_0
    "Finally... after ten years... may pangalan na ang sakit niya."
    -> management_phase

* [Diagnose: Multiple Sclerosis (MS)]
    ~ clinical_score = 2
    "Given the progressive neurological symptoms and cerebellar involvement, this could be Multiple Sclerosis. We need to do a spinal tap and more MRI scans."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung family history po? 18 sa pamilya namin ang may ganito. Ang MS po ba ay namamana?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key genetic clue. MS is not typically inherited in this autosomal dominant pattern across multiple generations.
    -> management_phase

* [Diagnose: Parkinson's Disease]
    ~ clinical_score = 2
    "The tremors and difficulty walking could be Parkinson's disease. We should start her on levodopa."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung nanay namin, hindi naman siya nanginginig. At yung MRI ni Maria, sabi niyo cerebellar atrophy. Ang Parkinson's ba ay nakakaapekto sa cerebellum?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ignored the cerebellar findings. Parkinson's is a basal ganglia disorder, not primarily cerebellar.
    -> management_phase

* [Diagnose: Functional Neurological Disorder]
    ~ clinical_score = 1
    "Given the normal initial MRIs and the absence of a clear diagnosis, this may be a functional neurological disorder. Stress and anxiety can cause these symptoms."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Elena's face hardens. Maria looks down, defeated.
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_2
    "Doc... sinabi na po iyan sa amin ng tatlong doktor. Sinubukan namin ang therapy, ang gamot sa anxiety. Walang nagbago. Lumala pa siya. At ang 18 katao sa pamilya namin—lahat ba sila ay may 'stress' din?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have dismissed a legitimate organic condition as psychological. This is the most damaging misdiagnosis.
    -> management_phase


// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Refer to Genetics + Physiatry]
    ~ safety_score = 5
    "Elena, I am going to refer Maria to a geneticist for formal genetic testing. We need to identify the specific mutation—likely in the ITPR1 gene. I'll also write a referral to a physiatrist for physical therapy and occupational therapy to help maintain Maria's function. And I'll connect you with the Philippine Ataxia Support Group."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_0
    "Doc... sampung taon kaming naghanap ng sagot. Ngayon, may direksyon na kami. Hindi na kami naliligaw."
    -> ending

* [Observation and Symptomatic Treatment Only]
    ~ safety_score = 2
    "Let's just monitor Maria's symptoms for now. I'll prescribe some physical therapy. If it gets worse, come back."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero paano po ang family history? Paano ang mga pamangkin ko? Dapat ba silang magpa-test?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed the genetic implications for the wider family. Elena leaves with incomplete answers.
    -> ending

* [Immediate Hospital Admission]
    ~ safety_score = 1
    "Maria needs to be admitted immediately. We need to do a full workup—more MRIs, lumbar puncture, muscle biopsy."
    
    # speaker: Elena # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! Hindi po namin kaya. Si Maria, may mga anak. Ako, may trabaho. Hindi namin kayang mag-stay sa hospital nang matagal."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated too quickly without considering the family's resources. This is a chronic, progressive condition—not an acute emergency.
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
        "Excellent work! You recognized the autosomal dominant pattern of SCA15, built trust with Maria and Elena, and made a safe referral. This is the GOLDEN PATH. You've diagnosed the first case of SCA15 in Asia!"
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and safe referral, but Maria and Elena left feeling unseen. Remember to build trust through empathy—they've been dismissed for ten years."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and made a safe referral, but you missed the diagnosis. Remember: progressive cerebellar ataxia + autosomal dominant family history = hereditary ataxia (SCA15)."
    - clinical_score < 5:
        "You misdiagnosed Maria's condition. Remember: progressive ataxia + 18 affected family members = hereditary ataxia. Consider SCA15 in patients with cerebellar atrophy and family history."
    - safety_score < 5 and clinical_score == 5:
        "You correctly diagnosed SCA15 but failed to act. Compassion without diagnostic action is incomplete care. Always provide genetic counseling for the family."
    - else:
        "Keep practicing! Focus on gathering family history, recognizing patterns, and making safe referrals."
}

-> END