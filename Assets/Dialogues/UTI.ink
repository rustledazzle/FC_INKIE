// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Maria (Patient) Sprites:
//   UNCOMFORTABLE/NEUTRAL = Maria_U_0
//   GUARDED/DEFENSIVE = Maria_U_1
//   RELIEVED = Maria_U_2
//   GRATEFUL = Maria_U_3
//
// Close-Up Images:
//   Urinalysis Strip = Maria_Closeup_test_0
//   Urine Sample = Maria_Closeup_sample_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is busy. Maria, a 28-year-old call center agent, enters quickly. She looks uncomfortable and is shifting her weight from foot to foot. She sits down carefully, grimacing.

# speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
"Doc, salamat po sa pagtanggap sa akin. Masakit po kapag umiihi ako. Parang may nasusunog. Tapos, kahit kaka-CR ko lang, parang gusto ko na naman umihi."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice Maria looks tired. She mentions she works night shifts and often holds her urine for long periods because she is busy taking calls.

# speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
"Doc, mga tatlong araw na ito. Hindi naman ako nilalagnat. Wala rin akong sakit sa likod. Pero yung pag-ihi ko, sobrang sakit na. Nahihirapan na ako magtrabaho."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Maria is clearly uncomfortable and frustrated. She has been enduring this for three days. Your opening approach will shape the consultation.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on the painful urination immediately]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Maria, let's focus on the urination. When did the burning start? Is it constant or only at the end of urination? Are you able to empty your bladder completely?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria answers your questions but she seems guarded. She provides clinical facts but does not elaborate.

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Yung pag-ihi ko, masakit. Parang may nasusunog. Kahit kaka-CR ko lang, parang gusto ko na naman umihi. Hindi ko alam kung na-e-empty ko ba talaga."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Maria feels like just another case.
    -> information_gathering

* [Choice B: Acknowledge her discomfort and ask about her work]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Maria, I can see you're really uncomfortable. Three days of this must be exhausting. You mentioned you work night shifts. Can you tell me what a typical shift looks like for you? How often are you able to take a break?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria sighs deeply. She looks relieved that someone is asking about her situation.

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc, grabe. Twelve-hour shifts ako. Minsan, hindi ako makapag-CR kasi sunod-sunod ang calls. Tapos, konti lang ang iniinom ko na tubig kasi ayaw ko mag-CR nang mag-CR. Ngayon, eto, nagkasakit ako."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Maria feels heard and understood.
    -> information_gathering

* [Choice C: Ask about sexual activity and hygiene immediately]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Maria, are you sexually active? Do you urinate after intercourse? Do you use spermicides or diaphragms? These are common causes of UTI."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria becomes defensive and crosses her arms.

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_1
    "Doc, hindi naman po ako madumi. Nag-aalaga naman po ako ng sarili ko. Bakit niyo po ako tinatanong niyan?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about previous UTI episodes and medications]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Maria, have you had this before? Any previous UTI episodes? Were you given antibiotics? Did you finish them?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Maria thinks for a moment. She seems willing to share but remains cautious.

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Dati po, mga dalawang taon na. Binigyan ako ng gamot. Nainom ko naman. Pero ngayon, parang mas malala ito."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Patient is sharing but not fully open.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Maria has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about red flags: fever, flank pain, vomiting, chills]
    ~ info_score += 2
    "Maria, I need to check for warning signs. Have you had any fever, chills, pain on your side or back, nausea, or vomiting?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Wala naman po fever. Wala rin sakit sa likod. Hindi naman ako nagsusuka. Yung pag-ihi lang talaga ang problema."

    -> information_gathering_2

* [Ask about fluid intake and bladder habits]
    ~ info_score += 2
    "Maria, how much water do you drink in a day? How often do you urinate? Do you hold your urine for long periods?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Konti lang po iniinom ko. Mga dalawang baso lang sa isang shift. Minsan, apat na oras akong hindi nakaka-CR kasi busy. Alam ko naman na mali, pero wala akong choice."

    -> information_gathering_2

* [Ask about vaginal discharge or irritation]
    ~ info_score += 1
    "Maria, have you noticed any vaginal discharge, itching, or irritation? Any new sexual partner or change in contraception?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Wala naman po discharge. Wala ring itching. Hindi naman nagbago ang partner ko. Yung pag-ihi lang talaga ang problema."

    -> information_gathering_2

* [Ask about medical history: diabetes, kidney problems, pregnancy]
    ~ info_score += 2
    "Maria, do you have any medical conditions like diabetes or kidney problems? Is there any chance you might be pregnant?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Wala naman po akong diabetes o sakit sa bato. Hindi rin po ako buntis. Regular naman ang menstruation ko."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about impact on daily life and work]
    ~ info_score += 1
    "Maria, how has this affected your work and daily life? Are you able to function at your job?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc, nahihirapan na ako. Puro CR ako. Hindi ako makapag-focus sa trabaho. Yung supervisor ko, napapansin na. Natatakot ako na ma-terminate."

    -> diagnosis_phase

* [Ask about previous antibiotic use]
    ~ info_score += 2
    "Maria, have you taken any antibiotics recently? Any self-medication for this current episode?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Wala naman po akong iniinom na antibiotic. Hindi rin ako nag-self-medicate. Ngayon lang talaga ako nagpatingin."

    -> diagnosis_phase

* [Ask about health literacy and understanding of UTI]
    ~ info_score += 1
    "Maria, what do you know about UTI? What have you heard about how it's treated?"

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Ang alam ko po, dahil sa hindi pag-inom ng tubig at pagpigil ng ihi. Sabi ng kaibigan ko, dapat daw uminom ng antibiotics. Pero hindi ko alam kung alin."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Maria has:
- Dysuria, urinary frequency, urgency for 3 days
- No fever, no flank pain, no vomiting
- Low fluid intake, prolonged holding of urine
- No vaginal discharge, no new sexual partner
- No history of diabetes or kidney disease
- Not pregnant

Based on this information, how do you interpret her condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Acute Uncomplicated Cystitis]
    ~ clinical_score = 5
    "Maria, you have Acute Uncomplicated Cystitis. This is a bladder infection without complications. The burning, frequency, and urgency are classic signs. Because you have no fever, no flank pain, and no other medical conditions, we can treat this as an uncomplicated UTI."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... kailangan ko bang magpa-test muna?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Yes, we should do a urinalysis first to confirm the diagnosis before starting antibiotics. The Philippine CPG recommends urinalysis to confirm UTI before treatment."

    # closeup: Maria_Closeup_test_0
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You show Maria the urinalysis test strip. The results confirm the presence of leukocytes and nitrites—consistent with a urinary tract infection.

    -> management_phase

* [Choice B: Acute Pyelonephritis]
    ~ clinical_score = 2
    "Maria, this could be a kidney infection. We should check your flank and consider admission."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... pero wala naman akong sakit sa likod o lagnat. Sa pantog lang ang problema ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have over-diagnosed. Maria has no fever, no flank pain, and no systemic symptoms. This is uncomplicated cystitis, not pyelonephritis.
    -> management_phase

* [Choice C: Vaginitis or Sexually Transmitted Infection]
    ~ clinical_score = 2
    "Maria, the burning could be from a vaginal infection. Let's do a pelvic exam and test for STIs."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... wala naman akong discharge o itching. Yung pag-ihi lang talaga ang masakit."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key urinary symptoms. Dysuria and frequency without vaginal symptoms point to UTI, not vaginitis.
    -> management_phase

* [Choice D: Asymptomatic Bacteriuria]
    ~ clinical_score = 1
    "Maria, you may have bacteria in your urine without a true infection. Let's just monitor."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_1
    "Doc! Masakit nga po ang pag-ihi ko! Hindi naman ako walang nararamdaman!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have dismissed her symptoms. Asymptomatic bacteriuria has no symptoms. Maria has clear dysuria and frequency.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Order Urinalysis + Start Antibiotics + Hydration Counseling]
    ~ safety_score = 4
    "Maria, I'm going to order a urinalysis to confirm the UTI. The Philippine CPG recommends urinalysis before starting treatment. Once confirmed, I'll start you on antibiotics. First-line options include nitrofurantoin or fosfomycin. You also need to increase your water intake—at least 8 glasses a day. And please don't hold your urine. Take breaks at work, even if it's just for a few minutes."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... magkano po ang gamot? Pasensya na, nagtitipid ako."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "The antibiotics are affordable. You can also use your PhilHealth Konsulta benefits. The most important thing is to treat this now before it gets worse. Let's also talk about how to prevent this from happening again."

    # closeup: Maria_Closeup_sample_0
    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You show Maria the urine sample. It appears cloudy and slightly dark—consistent with a urinary tract infection.

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_2
    "Salamat, Doc. Akala ko magiging komplikado pa. Ngayon, alam ko na ang gagawin ko."

    -> education_phase

* [Choice B: Start Antibiotics Without Urinalysis]
    ~ safety_score = 3
    "I'll start you on antibiotics right away. No need for tests."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... hindi ba dapat i-test muna? Baka mali ang gamot?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have skipped confirmatory testing. The Philippine CPG recommends urinalysis before treatment to confirm the diagnosis and guide antibiotic selection.
    -> education_phase

* [Choice C: Recommend Cranberry Juice and Fluids Only]
    ~ safety_score = 1
    "Just drink more water and cranberry juice. That should clear it up."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_1
    "Doc! Tatlong araw na akong nagtitiis! Hindi ba dapat gamutin ito nang maayos? Yung kaibigan ko, na-ospital dahil dito!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have under-treated a bacterial infection. UTI requires antibiotics. Cranberry is not a treatment for active infection.
    -> education_phase

* [Choice D: Refer to Urologist Immediately]
    ~ safety_score = 2
    "I'm going to refer you to a urologist. They can manage this better."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... kailan po ako makakakita ng urologist? Ang mahal po ng consultation. At baka hindi na kaya ng oras ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed treatment by referring to a specialist unnecessarily. Uncomplicated cystitis can be managed in primary care.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Maria leaves, you have an opportunity to educate her about prevention. This is your chance to ensure she understands how to avoid future UTIs.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain the connection between holding urine and UTI]
    ~ safety_score += 1
    "Maria, holding your urine for long periods allows bacteria to multiply in your bladder. That's why you got this infection. At work, please take bathroom breaks, even if it's just for two minutes. And drink water throughout your shift, not just when you remember."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_3
    "Doc, naiintindihan ko na. Akala ko kasi okay lang na pigilin. Ngayon, alam ko na ang gagawin ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands prevention. Safety score increased.
    -> ending

* [Choice B: Just tell her to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back if it doesn't improve."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about bladder health]
    ~ safety_score += 1
    "Maria, think of your bladder like a water bottle. If you don't empty it regularly, bacteria grow. Drinking water and urinating often flushes them out. It's that simple."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_3
    "Ah, ganun pala iyon, Doc. Parang hugasan lang ang bote. Salamat, naiintindihan ko na."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands prevention. Safety score increased.
    -> ending

* [Choice D: Give her a pamphlet about UTI]
    ~ safety_score += 0
    "Here's a pamphlet about UTI. Read it when you get home."

    # speaker: Maria # portrait_left: Clear # portrait_right: Maria_U_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At wala akong oras ngayon."

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
        "Excellent work! You recognized Acute Uncomplicated Cystitis, addressed Maria's work-related barriers with empathy, ordered urinalysis before treatment per the Philippine CPG, and provided prevention education. UTI is one of the most common primary care infections in the Philippines—your comprehensive approach will prevent recurrence."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate management, but Maria left feeling judged. Remember, UTI is not about hygiene—it's about hydration, bladder habits, and access to bathroom breaks."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed UTI but failed to provide comprehensive care. Urinalysis before antibiotics, hydration counseling, and prevention education are essential parts of UTI management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: dysuria plus frequency plus urgency without fever or flank pain equals uncomplicated cystitis."
    - clinical_score < 5:
        "You misdiagnosed a very common condition. UTI is the second leading cause of adult outpatient consultation in the Philippines. Always consider UTI in patients with urinary symptoms."
    - else:
        "Keep practicing! UTI is common but easily managed. Remember the key steps: confirm with urinalysis, treat with appropriate antibiotics, and educate on prevention."
}

-> END