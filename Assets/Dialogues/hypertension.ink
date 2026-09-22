// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0
VAR lifestyle_score = 0
VAR education_score = 0

// --- SCENE 1: INTRODUCTION ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is busy. Aling Corazon, a 58-year-old retired teacher, enters slowly. She looks tired and is holding her head. She sits down heavily, sighing. You notice she is slightly overweight and looks flushed.

# speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
"Doc, salamat po sa pagtanggap sa akin. Sumasakit po ang ulo ko at nahihilo ako. Ilang araw na rin akong pagod. Dati naman hindi ako ganito."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You check her vital signs. Blood Pressure is 165/100 mmHg. Pulse is 88 bpm. Temperature is 36.8°C. Respiratory rate is 18.

# speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
"Opo, dati may alta presyon ako. Pero sabi ng doktor noon, bantayan lang daw. Hindi na ako bumalik. Hindi naman kasi ako nagkakasakit. Pero ngayon, talagang masakit ang ulo ko. Yung nanay ko kasi, namatay sa stroke. Natatakot ako baka gayahin ko siya."


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Aling Corazon has elevated blood pressure, a headache, and a family history of stroke. She is scared. Your opening approach will shape the entire consultation.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on the headache and dizziness]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Corazon, let's start with your headache. How long has it been going on? Is it throbbing? Does it come with nausea or vision changes?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Corazon answers your questions but she seems tense. She keeps glancing at the door. She provides clinical facts but stays distant.

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Yung ulo ko... parang pumipintig. Mga tatlong araw na. Wala naman akong chest pain. Nahihilo lang ako. Minsan lumalabo ang paningin ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Aling Corazon feels like just another case.
    -> information_gathering

* [Choice B: Acknowledge her fear about her mother]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Corazon, I can see how worried you are. You mentioned your mother had a stroke. That must have been very difficult. Can you tell me more about what you're feeling right now, and what you're most worried about?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Corazon's shoulders relax. Her eyes well up. She looks relieved that someone is listening.

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc, natatakot ako. Yung nanay ko, bigla na lang nag-stroke. Hindi na siya nakalakad. Ayokong mangyari sa akin iyon. Hindi ko alam kung paano ko maiiwasan. Akala ko kasi okay lang ako."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Aling Corazon feels heard and understood.
    -> information_gathering

* [Choice C: Ask about diet, exercise, and lifestyle]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Aling Corazon, your blood pressure is very high. Let me ask you about your lifestyle. Do you eat salty food? Do you exercise regularly? Have you gained weight recently?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Corazon becomes defensive. She crosses her arms.

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_2
    "Doc, hindi naman ako kumakain ng maaalat. Nagtitipid nga ako sa pagkain. Wala namang kasalanan kung tumaba ako. Hindi ko naman ginusto ito."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about previous BP readings and medications]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Corazon, you mentioned seeing a doctor before. Can you tell me what your blood pressure readings were back then? Were you given any medications? Did you take them?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Corazon thinks for a moment. She seems willing to share but remains cautious.

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Dati po, mga 150/90 siguro. May binigay na gamot. Pero hindi ko naman tinuloy kasi mahal at wala naman akong nararamdaman. Akala ko okay lang."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Patient is sharing but not fully open.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Aling Corazon has given you some information. Now you need to decide what else to ask about. Choose your questions carefully.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about associated symptoms: chest pain, shortness of breath, palpitations, blurry vision, leg swelling]
    ~ info_score += 2
    "Aling Corazon, besides the headache and dizziness, have you noticed any chest pain, shortness of breath, palpitations, blurry vision, or swelling in your legs?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Wala naman chest pain. Pero minsan, parang may kabog sa dibdib ko. At yung paningin ko, lumalabo kapag pagod. Yung paa ko naman, hindi naman namamaga."

    -> information_gathering_2

* [Ask about family history in detail]
    ~ info_score += 2
    "Aling Corazon, you mentioned your mother had a stroke. What about your father? Any siblings with high blood pressure, heart disease, or diabetes?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Ang tatay ko po, may alta presyon din. Namatay siya sa heart attack. Ang mga kapatid ko, may alta presyon din. Parang pamilya na namin ito."

    -> information_gathering_2

* [Ask about social context and barriers]
    ~ info_score += 1
    "Aling Corazon, tell me about your daily life. What do you do? Who do you live with? Do you have support at home?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Nagtitinda po ako sa sari-sari store. Mag-isa na lang ako sa bahay. Yung mga anak ko, may sariling pamilya na. Wala akong kasama. Kaya pag may nararamdaman ako, hindi ko alam kung ano ang gagawin."

    -> information_gathering_2

* [Ask about medication history and barriers to adherence]
    ~ info_score += 2
    "Aling Corazon, you mentioned you stopped your previous medication. Can you tell me why? Was it the cost? Side effects? Or something else?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Mahal po kasi. At nahihilo ako noong iniinom ko. Sabi ng doktor, normal lang daw. Pero natakot ako. Kaya tumigil ako. Akala ko kasi okay lang."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about lifestyle in a non-judgmental way]
    ~ info_score += 1
    "Aling Corazon, I want to understand your daily routine. What do you usually eat? Do you have time to walk or exercise? What does a typical day look like for you?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Maaga ako gumising para magtinda. Kadalasan, tuyo at kanin ang kinakain ko. Minsan, naglalakad naman ako papunta sa tindahan. Pero hindi na ako nag-e-exercise. Pagod na ako palagi."

    -> diagnosis_phase

* [Ask about danger signs and red flags]
    ~ info_score += 2
    "Aling Corazon, I need to check for warning signs. Have you had any severe headache that came on suddenly? Any difficulty speaking, weakness on one side of your body, or fainting?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Wala naman po. Yung ulo ko, masakit pero hindi naman biglaan. Wala namang panghihina o pamamanhid. Hindi naman ako nawawalan ng malay."

    -> diagnosis_phase

* [Ask about health literacy and understanding]
    ~ info_score += 1
    "Aling Corazon, what do you know about high blood pressure? What have you been told about why it's dangerous?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Ang alam ko po, nakakamatay ang alta presyon. Pero hindi ko alam kung paano. Sabi ng iba, dahil sa stress. Sabi naman ng iba, dahil sa pagkain. Hindi ko alam kung ano ang totoo."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Aling Corazon has:
- BP 165/100 mmHg on two separate readings
- Headache, dizziness, occasional palpitations, blurry vision when tired
- Family history of hypertension, stroke, and heart attack
- Previous BP elevation, stopped medication due to cost and side effects
- Sedentary lifestyle, high-salt diet
- No signs of organ damage

Based on this information, how do you interpret her condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Chronic hypertension that requires long-term management]
    ~ clinical_score = 5
    "Aling Corazon, your blood pressure is consistently high. This is not a one-time thing. Your readings, your family history, and your previous history all point to chronic hypertension. This is a long-term condition that needs ongoing management. The good news is that with the right treatment and lifestyle changes, we can control it and reduce your risk of stroke and heart attack."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... kailangan ko bang uminom ng gamot habang-buhay?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Yes, but it's not as scary as it sounds. We'll start with one medication and adjust it as needed. We'll also work on diet and exercise together. With your cooperation, you can live a normal, healthy life."

    -> management_phase

* [Choice B: Elevated BP likely due to stress and anxiety]
    ~ clinical_score = 2
    "Aling Corazon, your blood pressure is high, but it may be related to stress and anxiety. You mentioned you're scared about your mother's stroke. Let's focus on relaxation and stress management first before starting medication."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... pero yung nanay ko, namatay sa stroke. Hindi naman stress lang iyon. At yung BP ko, mataas talaga kahit hindi ako stressed."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have minimized a serious medical condition. Hypertension is a real cardiovascular risk factor, not just stress. Aling Corazon has Stage 2 Hypertension and needs treatment.
    -> management_phase

* [Choice C: Hypertensive emergency requiring immediate IV treatment]
    ~ clinical_score = 2
    "Aling Corazon, your blood pressure is dangerously high. We need to bring it down immediately. I'm going to give you IV medication to lower it right now."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! Ganyan po talaga ang sinabi ng doktor dati. Bigla akong binigyan ng gamot at nahilo ako. Natakot ako. Hindi ko na gusto iyon."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have over-escalated. Aling Corazon has no signs of organ damage. She is a case of Acute Severe Hypertension, not Hypertensive Emergency. Rapidly lowering BP can cause harm.
    -> management_phase

* [Choice D: Need more tests to rule out secondary causes]
    ~ clinical_score = 3
    "Aling Corazon, your blood pressure is high. Before we start treatment, I want to rule out other causes. Let's do an ECG, kidney function tests, and thyroid function tests."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... magkano po ang mga test na iyon? Wala akong trabaho ngayon. Mahirap lang po ako."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have ordered tests without considering the patient's resources. While ruling out secondary causes is good practice, in a resource-limited setting, starting treatment for Stage 2 Hypertension is the priority. You can order baseline tests while starting medication.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Start ARB + Lifestyle Counseling + PhilHealth Konsulta + BP Logbook]
    ~ safety_score = 5
    "Aling Corazon, I'm going to start you on a medication called an ARB. It's a very common and well-tolerated blood pressure medicine. ARBs are the most commonly prescribed antihypertensive in the Philippines. I will also give you a referral to PhilHealth's Konsulta package, which covers your medicines and follow-up visits. We'll also talk about lifestyle changes: reducing salt in your diet, walking for 30 minutes a day, and losing weight gradually. I'll give you a BP logbook so you can monitor your BP at home. Come back in 2 weeks so we can check your progress."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... magkano po ang gamot? Wala po akong trabaho ngayon."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "PhilHealth's Konsulta package covers the cost of medicines for hypertension. You won't have to pay out of pocket for the medication. We'll also give you a BP logbook so you can monitor your BP at home. Come back in 2 weeks so we can check your progress."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_0
    "Salamat, Doc. Akala ko wala nang pag-asa. Ngayon, may ginagawa na ako para sa sarili ko."

    -> education_phase

* [Choice B: Start Medication + No Lifestyle Counseling + No Financial Support]
    ~ safety_score = 3
    "I'm going to start you on medication. Take this once a day. Come back in a month."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... ano pong dapat kong kainin? Dapat ba akong mag-ehersisyo? At paano kung hindi ko kayang bilhin ang gamot?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have not addressed lifestyle modifications or financial barriers. In the Philippines, most hypertensive patients do not receive documented lifestyle advice. This is a gap in care that affects BP control.
    -> education_phase

* [Choice C: Recommend Lifestyle Changes Only + No Medication]
    ~ safety_score = 2
    "Aling Corazon, let's try lifestyle changes first. Reduce your salt intake, exercise more, and lose weight. If your BP doesn't improve, we can start medication."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_2
    "Doc! 165/100 ang BP ko! Hindi ba masyadong mataas na para sa lifestyle lang? Yung nanay ko, namatay sa stroke!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have under-treated Stage 2 Hypertension. According to the 2024 Philippine CPG, Stage 2 Hypertension requires immediate pharmacologic treatment. Lifestyle changes alone are insufficient.
    -> education_phase

* [Choice D: Refer to Specialist + No Immediate Treatment]
    ~ safety_score = 2
    "Aling Corazon, I'm going to refer you to a cardiologist. They can decide on the best treatment for you."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... kailan po ako makakakita ng cardiologist? Mahirap po ang schedule. At baka masayang ang oras ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed treatment by referring to a specialist unnecessarily. Stage 2 Hypertension can be managed in primary care. Delaying treatment puts the patient at risk.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (EDUCATION SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Aling Corazon leaves, you have an opportunity to educate her about her condition. This is your chance to ensure she understands and can manage her health.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain hypertension and its complications in simple terms]
    ~ education_score = 5
    "Aling Corazon, let me explain. Hypertension is like too much pressure in a water pipe. Over time, the pressure damages the pipe. In your body, it damages your heart, your brain, and your kidneys. That's why it's important to take your medicine every day, even if you feel fine. The medicine keeps the pressure normal so your organs stay safe."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_0
    "Ah, ganun pala iyon, Doc. Akala ko kasi kapag wala akong nararamdaman, okay lang. Ngayon, naiintindihan ko na."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands the importance of medication adherence. Education score high.
    -> ending

* [Choice B: Tell her to just take the medicine and come back]
    ~ education_score = 2
    "Just take the medicine as prescribed and come back in 2 weeks. Any questions?"

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding why she needs medication. Education score low.
    -> ending

* [Choice C: Use a metaphor to explain BP and stroke risk]
    ~ education_score = 4
    "Aling Corazon, think of your blood vessels like a hose. If the water pressure is too high all the time, the hose can burst. In your body, if your blood pressure is too high, a vessel in your brain can burst. That's what happened to your mother. Taking your medicine keeps the pressure normal so that doesn't happen to you."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_0
    "Doc, salamat. Ngayon alam ko na kung bakit importante ang gamot. Hindi ko na ito titigilan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands the connection between BP and stroke. Education score high.
    -> ending

* [Choice D: Give her a pamphlet and tell her to read it]
    ~ education_score = 1
    "Here's a pamphlet about hypertension. Read it when you get home. It explains everything."

    # speaker: Aling Corazon # portrait_left: Clear # portrait_right: patientVN_1
    "Doc... hindi po ako masyadong marunong magbasa ng Ingles. At malabo ang mata ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Education score very low. You did not address her literacy or vision barriers.
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
Patient Education: {education_score}/5
--------------------------------------------------
TOTAL SCORE: {clinical_score + info_score + empathy_score + safety_score + education_score}/25
--------------------------------------------------

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
{
    - clinical_score == 5 and empathy_score == 5 and safety_score == 5 and education_score >= 4:
        "Excellent work! You recognized Stage 2 Hypertension, addressed Aling Corazon's fears with empathy, provided comprehensive management including lifestyle counseling and financial support, and ensured she understood her condition. Hypertension is the silent killer, affecting 1 in 3 Filipino adults, and you demonstrated true primary care excellence."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate management, but Aling Corazon left feeling judged. Remember, patients with chronic conditions need empathy, not lectures."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Hypertension but failed to provide comprehensive care. Lifestyle counseling, financial support, and patient education are essential parts of hypertension management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good management, but you missed the diagnosis. Remember: BP of 140/90 or higher on two occasions indicates Hypertension. Stage 2 is 160/100 or higher."
    - clinical_score < 5:
        "You misdiagnosed a very common condition. Hypertension affects 16.8 million Filipinos. Always check BP, consider family history, and provide both lifestyle and pharmacologic management."
    - else:
        "Keep practicing! Hypertension is the silent killer. It often has no symptoms until complications occur. Early detection, patient education, and consistent management save lives."
}

-> END