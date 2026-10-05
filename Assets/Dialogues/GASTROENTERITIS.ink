// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Aling Lorna (Mother) Sprites:
//   NEUTRAL/TIRED = Lornasprite_0
//   ANXIOUS/WORRIED = Lornasprite_1
//   DEFENSIVE/CRYING = Lornasprite_2
//   RELIEVED/GRATEFUL = Lornasprite_3
//
// Close-Up Images:
//   Bebe's Face (Dehydration Signs) = Gastroface_0
//   Skin Pinch Test = Gastropinch_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (212)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is warm. Aling Lorna enters carrying her 2-year-old daughter, Bebe. The child is limp and lethargic, resting her head on her mother's shoulder. Aling Lorna looks exhausted and worried. She sits down slowly, adjusting Bebe on her lap.

# speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
"Doc, salamat po sa pagtanggap sa amin. Si Bebe po, tatlong araw na siyang nagtatae. Matubig po. Tapos, ayaw niyang kumain at uminom. Sobrang lalata na siya."

# closeup: Gastroface_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Bebe closely. Her eyes appear sunken. Her lips are dry. Her skin is warm but not hot. She is drowsy and does not react much to your examination.

# closeup: Gastropinch_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
When you gently pinch the skin on her abdomen, it goes back slowly—a sign of severe dehydration.

# speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
"Doc, wala naman pong dugo sa dumi niya. Wala ring lagnat. Pero hindi ko na po alam ang gagawin. Wala kaming malinis na tubig sa bahay. Minsan, nawawalan kami ng supply."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Aling Lorna mentions that Bebe has not received any ORS or zinc. She has tried giving water and juice, but Bebe refuses to drink. She is worried that Bebe will become weaker.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Bebe is clearly dehydrated and lethargic. Aling Lorna is frightened and unsure. Your opening approach will shape the entire consultation.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on the diarrhea symptoms immediately]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Lorna, let's focus on Bebe's diarrhea. How many times has she had loose stools in the past 24 hours? Is there any blood? Has she had any vomiting?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Lorna answers your questions but she seems rushed and panicked. She provides facts but does not elaborate.

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Mga walong beses po sa isang araw. Wala pong dugo. Nagsusuka rin po siya. Kaya hindi siya makainom."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Aling Lorna feels like she's being interrogated while her child is suffering.
    -> information_gathering

* [Choice B: Acknowledge her fear and Bebe's condition]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Aling Lorna, I can see how scared you are. Bebe looks very weak. You mentioned you don't have clean water at home. Can you tell me more about what's been happening at home? How have you been managing?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Lorna's eyes well up. She looks relieved that someone is asking about her situation.

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc, mahirap po talaga. Wala kaming malinis na tubig. Yung tubig namin, galing sa balon, hindi namin napapakulo. Ngayon, si Bebe, sobrang lalata. Natatakot ako na baka hindi na siya magising."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Aling Lorna feels heard and understood.
    -> information_gathering

* [Choice C: Ask about hygiene and water practices]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Aling Lorna, do you wash your hands before feeding Bebe? Do you boil your drinking water? Diarrhea is often caused by poor sanitation."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Lorna becomes defensive and starts crying.

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_2
    "Doc, wala po kaming choice! Mahirap lang po kami. Hindi namin kayang magpakulo ng tubig araw-araw. Hindi ko naman ginusto na magkasakit si Bebe!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about previous episodes and treatments]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Aling Lorna, has Bebe had diarrhea before? Any previous episodes? Did you give her any medications or home remedies?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Aling Lorna thinks for a moment. She seems willing to share but remains cautious.

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Dati po, mga isang buwan na. Nagbigay ako ng gamot sa botika. Pero ngayon, mas malala ito. Hindi na umiinom si Bebe."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Patient is sharing but not fully open.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND - MAX 3 PTS) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Aling Lorna has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about red flags: blood in stool, persistent vomiting, inability to drink]
    ~ info_score += 3
    "Aling Lorna, I need to check for warning signs. Is there any blood in Bebe's stool? Has she been vomiting continuously? Is she able to drink anything at all?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Wala pong dugo. Nagsusuka po siya, pero hindi tuloy-tuloy. Yung pag-inom, ayaw niya. Kahit tubig, tinatanggihan niya."

    -> information_gathering_2

* [Ask about urine output and activity level]
    ~ info_score += 3
    "Aling Lorna, when was the last time Bebe urinated? Is she still active? Is she responsive?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Kaninang umaga pa po, hindi na siya umiihi. Sobrang lalata niya. Parang hindi na siya gumagalaw. Natatakot ako."

    -> information_gathering_2

* [Ask about feeding and fluid intake]
    ~ info_score += 2
    "Aling Lorna, is Bebe still breastfeeding? What has she been eating and drinking?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Hindi na po siya nagpa-breastfeed. Ayaw niyang kumain. Yung tubig at juice, tinatanggihan niya. Wala po siyang iniinom."

    -> information_gathering_2

* [Ask about social context and access to clean water]
    ~ info_score += 3
    "Aling Lorna, tell me more about your home. Do you have access to clean water? How do you store your drinking water?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Wala po kaming gripo. Yung balon, malayo. Hindi namin napapakulo. Kaya siguro nagkakasakit si Bebe. Mahirap po talaga."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND - MAX 2 PTS) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about vomiting frequency and ability to keep fluids down]
    ~ info_score += 2
    "Aling Lorna, how many times has Bebe vomited today? Does she keep anything down?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Mga apat na beses po siyang nagsuka ngayong araw. Kahit tubig, sinasuka niya. Kaya natatakot ako na baka ma-dehydrate siya."

    -> diagnosis_phase

* [Ask about health literacy and understanding of diarrhea]
    ~ info_score += 2
    "Aling Lorna, what do you know about diarrhea? What have you been told about how to manage it?"

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Ang alam ko po, dapat painumin ng ORS. Pero hindi ko alam kung paano ihanda. At wala kaming pera pambili. Akala ko, tubig lang, okay na."

    -> diagnosis_phase

* [Ask about vaccination status]
    ~ info_score += 1
    "Aling Lorna, has Bebe received her rotavirus vaccine? It helps prevent severe diarrhea."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Hindi ko po alam. Wala kaming bakuna. Hindi namin alam na may ganun pala."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Bebe has:
- Watery diarrhea for 3 days, approximately 8 episodes per day
- Vomiting 4 times today
- Poor oral intake, refusing to drink
- No blood in stool
- Sunken eyes, dry lips, slow skin pinch
- Lethargic, drowsy, poor responsiveness
- Decreased urine output
- No fever
- Lives in a community with no access to clean water

Based on this information, how do you interpret her condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Acute Gastroenteritis with Severe Dehydration]
    ~ clinical_score = 5
    "Aling Lorna, Bebe has Acute Gastroenteritis with Severe Dehydration. The watery diarrhea, vomiting, sunken eyes, slow skin pinch, and lethargy are all signs of severe dehydration. She needs immediate intravenous fluids. This is a medical emergency that requires hospitalization."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_2
    "Doc... kailangan po bang ma-confine? Wala po kaming pera."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "I understand your concern. But Bebe is very dehydrated. If we don't act now, she could go into shock. We can apply for PhilHealth assistance and Malasakit Center support. Her life is the priority right now."

    -> management_phase

* [Choice B: Acute Gastroenteritis with Mild to Moderate Dehydration]
    ~ clinical_score = 3
    "Bebe has Acute Gastroenteritis with Mild to Moderate Dehydration. We can manage her with ORS at home."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc... pero sobrang lalata niya. At ayaw niyang uminom. Paano po ang ORS kung hindi siya umiinom?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have underestimated the severity. Bebe has sunken eyes, slow skin pinch, and lethargy—signs of severe dehydration. ORS alone is insufficient for severe dehydration.
    -> management_phase

* [Choice C: Acute Gastroenteritis with No Dehydration]
    ~ clinical_score = 2
    "Bebe has Acute Gastroenteritis without dehydration. Just continue feeding and give fluids."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_2
    "Doc! Hindi nga siya umiinom! Sobrang lalata niya! Paano po walang dehydration?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the clear signs of severe dehydration. Bebe is lethargic, has sunken eyes, and a slow skin pinch. This is a life-threatening situation.
    -> management_phase

* [Choice D: Cholera]
    ~ clinical_score = 2
    "The watery diarrhea and dehydration could be Cholera. We should do a stool culture and start antibiotics."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc... hindi ko alam kung cholera ito. Pero yung anak ko, nanghihina na. Dapat ba siyang bigyan ng IV agad?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have focused on a specific diagnosis without addressing the immediate life-threatening dehydration. The priority is rehydration, not identifying the organism.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE - MAX 4 PTS) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Admit for IV Fluids + ORS + Zinc + Continued Feeding]
    ~ safety_score = 4
    "Aling Lorna, I am admitting Bebe to the hospital immediately. She needs IV fluids to correct her severe dehydration. Once she is stabilized, we will transition her to low-osmolarity ORS. She will also need zinc supplementation—20 mg daily for 10-14 days. We will continue feeding her as soon as she can tolerate it. And we will monitor her closely."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc... magkano po ang magagastos? Wala po kaming trabaho ngayon."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "PhilHealth has a package for acute gastroenteritis. We can also apply for Malasakit Center assistance. Don't worry about the cost right now—Bebe's life is the priority. We will help you with the paperwork."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_3
    "Salamat, Doc. Akala ko wala nang pag-asa. Ngayon, may gagawin na tayo."

    -> education_phase

* [Choice B: Send Home with ORS + Zinc + Follow-up Instructions]
    ~ safety_score = 3
    "I'll give you ORS and zinc. Give her small amounts every few minutes. Come back if she doesn't improve."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_2
    "Doc! Ayaw nga po niyang uminom! Paano po siya gagaling sa bahay? Hindi po ba siya kailangan ng IV?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have under-treated severe dehydration. Bebe needs IV fluids. Sending her home with ORS alone is unsafe and could be fatal.
    -> education_phase

* [Choice C: Give ORS Only Without Zinc]
    ~ safety_score = 2
    "Just give her ORS. No need for zinc. She'll recover on her own."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc... sabi ng kapitbahay ko, may zinc daw na dapat ibigay. Hindi ba importante iyon?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have omitted zinc supplementation. The Philippine CPG strongly recommends zinc for children with acute diarrhea. Zinc reduces the duration and severity of diarrhea.
    -> education_phase

* [Choice D: Give Antibiotics + ORS]
    ~ safety_score = 2
    "I'll give you antibiotics and ORS. The antibiotics will kill the bacteria causing the diarrhea."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_1
    "Doc... kailangan po ba ng antibiotic? Wala namang dugo sa dumi niya."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have prescribed antibiotics unnecessarily. The Philippine CPG explicitly states that antibiotics are NOT recommended for acute non-bloody diarrhea.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE - MAX +1 PT) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Aling Lorna leaves, you have an opportunity to educate her about prevention and home management. This is your chance to ensure she understands how to prevent future episodes.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain ORS preparation, zinc, and safe water practices]
    ~ safety_score += 1
    "Aling Lorna, let me show you how to prepare ORS. One sachet in one liter of clean water. Give small amounts—just a spoonful every 1-2 minutes. For zinc, give 20 mg daily for 10-14 days. And for prevention, always boil your drinking water or use a water filter. Wash your hands before feeding Bebe and after changing her diaper. These simple steps can save her life."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_3
    "Doc, naiintindihan ko na. Akala ko kasi tubig lang, okay na. Ngayon, alam ko na ang tamang paraan."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands proper ORS preparation and prevention. Safety score increased.
    -> ending

* [Choice B: Just tell her to give ORS and come back]
    ~ safety_score += 0
    "Give her ORS and come back in 3 days."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding proper ORS preparation or prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about dehydration]
    ~ safety_score += 1
    "Aling Lorna, think of Bebe's body like a plant. If you don't water it, it wilts. ORS is like water for her body—it replaces what she lost. Zinc is like fertilizer—it helps her grow stronger and fight the diarrhea. And clean water is like good soil—it keeps her healthy."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_3
    "Ah, ganun pala iyon, Doc. Parang halaman lang. Salamat, naiintindihan ko na."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient understands the connection between hydration and health. Safety score increased.
    -> ending

* [Choice D: Give her a pamphlet about diarrhea]
    ~ safety_score += 0
    "Here's a pamphlet about diarrhea. Read it when you get home."

    # speaker: Aling Lorna # portrait_left: Clear # portrait_right: Lornasprite_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At wala akong oras ngayon."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient cannot understand the pamphlet. Safety score unchanged.
    -> ending


// --- SCENE 8: ENDING & FEEDBACK ---
== ending ==
// HARD CAP SAFETY NET: Ensures no metric can ever exceed 5/5
{ clinical_score > 5:
    ~ clinical_score = 5
}
{ info_score > 5:
    ~ info_score = 5
}
{ empathy_score > 5:
    ~ empathy_score = 5
}
{ safety_score > 5:
    ~ safety_score = 5
}

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
        "Excellent work! You recognized Acute Gastroenteritis with Severe Dehydration, addressed Aling Lorna's fears with empathy, and provided comprehensive management including IV fluids, ORS, zinc, and prevention education. Acute gastroenteritis is a leading cause of morbidity in Filipino children—your prompt action saved Bebe's life."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate management, but Aling Lorna left feeling judged. Remember, access to clean water is a structural issue—not a personal failing. Approach families with empathy."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed severe dehydration but failed to provide comprehensive care. ORS alone is insufficient for severe dehydration. IV fluids and zinc supplementation are essential."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the severity of dehydration. Remember: lethargy, sunken eyes, slow skin pinch, and poor drinking indicate severe dehydration requiring immediate IV fluids."
    - clinical_score < 5:
        "You misdiagnosed a life-threatening condition. Acute gastroenteritis with severe dehydration requires immediate IV rehydration. Delayed treatment can lead to shock and death."
    - else:
        "Keep practicing! Gastroenteritis is common but can be deadly in children. Remember the key steps: assess dehydration severity, give ORS or IV fluids, supplement with zinc, and educate on prevention."
}

-> END