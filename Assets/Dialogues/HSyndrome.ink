// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The dermatology clinic room is bright. Maria, a 16-year-old Filipina, enters with her mother, Aling Liza. Maria wears a hoodie pulled low, shielding her face. She sits down slowly, keeping her head down. Aling Liza looks exhausted—dark circles under her eyes, her hands trembling slightly as she holds a folder of medical records.

# speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
"Doc, salamat po sa pagtanggap sa amin. Ito po si Maria, ang anak ko. Dalawang taon na po siyang nagkakaganto."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Maria slowly lowers her hood. Her cheeks are noticeably enlarged—bilateral, firm swelling that gives her face a rounded, disproportionate appearance. Her skin on the lower legs shows dark, hyperpigmented patches with increased hair growth.

# speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
"Doc, nagsimula ito noong 14 years old siya. Una, yung pisngi niya, namaga. Tapos, nagkaroon ng maitim na balat sa mga hita niya. Lumaki ang buhok sa mga binti. Dati, maganda ang balat niya. Ngayon... tinatawanan siya ng mga kaklase."

# speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
"Doc... lagi po akong tinitingnan. Parang... may mali sa akin. Natatakot ako... lumabas ng bahay."

# speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
"Doc, sinabi ng ibang doktor na baka allergy lang daw. O kaya hormonal. Pero lumalala siya. Hindi na siya pumapasok sa eskwela. Natatakot siya sa tingin ng iba. Marami na kaming doktor na pinuntahan. Dalawang taon. Walang makapagsabi kung ano ito. Pagod na pagod na kami."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Maria has bilateral cheek swelling and hyperpigmented, hypertrichotic skin patches on her lower legs. She has been dismissed by multiple doctors. Your approach will determine whether she finally feels heard.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Good morning, Maria. Let's start with your symptoms. When exactly did the cheek swelling start? And the skin changes on your legs—can you describe them?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria answers quietly, keeping her eyes down. She is a source of information, not a partner in care.
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "Yung pisngi ko... dalawang taon na. Yung balat sa binti... maitim at makapal... may buhok."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Hindi siya kumakain ng maayos ngayon. Natatakot siyang lumabas. Dati, honor student siya."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Maria feels like just another case.
    -> information_gathering

* [Choice B: Focus on Maria's Story (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Maria, Aling Liza. I can see this has been incredibly difficult. Maria, can you tell me—what was your life like before this started? What do you miss the most?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria finally looks up. Her eyes are red.
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "Dati... mahilig ako mag-ayos... magsuot ng magagandang damit. Ngayon... nagtatago na lang ako. Hindi na ako... pumapasok sa eskwela."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Marami na kaming doktor na pinuntahan. Dalawang taon. Walang makapagsabi kung ano ito. Pagod na pagod na kami."
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "Doc... may pag-asa pa ba ako?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Maria and her mother feel heard for the first time.
    -> information_gathering

* [Choice C: Focus on Family History and Genetics]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Maria, Aling Liza. Given the skin and facial changes, I need to ask—is there a family history of similar conditions? Any relatives with skin problems or unusual growths?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Liza looks thoughtful.
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Wala naman po. Walang ganito sa pamilya namin. Ang tatay ni Maria, malusog. Ako, malusog. Ang mga kapatid niya, normal."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels clinical. Trust Level: LOW.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. You examine Maria's skin and facial features. You note bilateral cheek enlargement, hyperpigmented patches on the lower legs with hypertrichosis, and mild sensorineural hearing loss. You recall that this pattern—skin changes, hearing loss, and short stature—points to a rare genetic condition called H Syndrome.
~ info_score = 5
-> diagnosis_phase


// --- SCENE 4: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Based on the bilateral cheek swelling, hyperpigmented patches with hypertrichosis on the legs, hearing loss, and short stature, what is your leading diagnosis?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Diagnose: H Syndrome]
    ~ clinical_score = 5
    "Maria, I believe you have H Syndrome. It's a rare genetic condition caused by mutations in the SLC29A3 gene. The name comes from the fact that most features start with the letter 'H': hyperpigmentation, hypertrichosis, hearing loss, and other features. Your bilateral cheek swelling is a unique presentation, but it fits with the inflammation seen in this condition."
    
    # speaker: Maria # portrait_left: Clear # portrait_right: patientVN_2
    "H... Syndrome? Parang... napaka-rare po?"
    
    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Yes, it is rare. That's why other doctors may not have recognized it. But we can confirm with genetic testing, which will look for mutations in your SLC29A3 gene. Once confirmed, we can start treatments like anti-inflammatory medications to help manage your symptoms."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Liza grips Maria's hand tightly. Tears stream down her face.
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_0
    "Doc... pagkatapos ng dalawang taon... may pangalan na ang sakit ni Maria. Hindi na kami nalilito."
    -> management_phase

* [Diagnose: Allergic Reaction or Angioedema]
    ~ clinical_score = 2
    "The cheek swelling and skin changes could be a chronic allergic reaction or angioedema. We should do allergy testing and try antihistamines."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero ginawa na po namin iyon. Dalawang taon na siyang umiinom ng antihistamines. Walang nagbago. At yung balat sa binti niya—hindi allergy ang itsura noon."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key skin findings. Allergies do not cause hyperpigmented, indurated patches with hypertrichosis.
    -> management_phase

* [Diagnose: Lupus or Autoimmune Disease]
    ~ clinical_score = 2
    "Given the skin changes and systemic symptoms, this could be an autoimmune condition like lupus. We should do autoimmune panels."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... sinabi na po iyon ng ibang doktor. Ginawa na namin ang mga test. Negative naman lahat. Bakit walang nagpapakita?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have suggested a common diagnosis without considering that the pattern doesn't fit. Lupus doesn't typically present with bilateral cheek enlargement without other systemic features.
    -> management_phase

* [Diagnose: Unknown / Will Observe]
    ~ clinical_score = 1
    "This is a very unusual presentation. I'm not sure what it is. Let's just observe for now and see if anything changes."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Liza's face falls.
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_2
    "Doc... dalawang taon na kaming nag-oobserve. Lumalala siya. Hindi na siya pumapasok sa eskwela. Natatakot siya sa tingin ng iba. Hindi na po namin kayang maghintay pa."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have failed to provide direction. Maria and her mother leave without answers.
    -> management_phase


// --- SCENE 5: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
* [Refer to Genetics + Malasakit Center]
    ~ safety_score = 5
    "Aling Liza, I am going to refer Maria for genetic testing to confirm H Syndrome. We need to look for mutations in the SLC29A3 gene. I will also refer you to the Philippine General Hospital's Genetics Clinic. They have programs for rare diseases. We can also apply for assistance through the Malasakit Center."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_0
    "Doc... dalawang taon kaming naghanap. Ngayon, may direksyon na kami. Hindi na kami naliligaw."
    -> ending

* [Symptomatic Management Only]
    ~ safety_score = 2
    "Let's just manage Maria's symptoms for now. I'll prescribe some anti-inflammatory medication and monitor her. Come back if it gets worse."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero paano po ang diagnosis? Dapat ba naming sabihin sa ibang anak ko na magpa-test?"
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed the genetic implications for the family. Aling Liza leaves with more questions than answers.
    -> ending

* [Immediate Hospital Admission]
    ~ safety_score = 1
    "Maria needs to be admitted immediately. We need to do a full workup—skin biopsy, genetic testing, imaging, and specialist consultations."
    
    # speaker: Aling Liza # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! Hindi po namin kaya. Si Maria, may mga kapatid. Ako, ang nag-aalaga sa kanila. Hindi namin kayang mag-stay sa hospital nang matagal."
    
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have escalated too quickly without considering the family's resources. H Syndrome is a chronic condition—not an acute emergency.
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
        "Excellent work! You recognized the rare pattern of H Syndrome, built trust with Maria and her mother, and made a safe referral. This is the GOLDEN PATH."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and safe referral, but Maria and her mother left feeling unseen. Remember to build trust through empathy."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and made a safe referral, but you missed the diagnosis. Remember: bilateral cheek swelling + hyperpigmented patches with hypertrichosis = H Syndrome."
    - clinical_score < 5:
        "You misdiagnosed Maria's condition. Remember: bilateral cheek swelling + hyperpigmented patches with hypertrichosis = H Syndrome. Consider genetic causes for rare presentations."
    - safety_score < 5 and clinical_score == 5:
        "You correctly diagnosed H Syndrome but failed to act. Compassion without diagnostic action is incomplete care. Always provide a clear pathway for the patient."
    - else:
        "Keep practicing! Focus on gathering information, recognizing patterns, and making safe referrals."
}

-> END