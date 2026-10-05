// --- GLOBAL VARIABLES ---
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0

// --- IMAGE ASSET REFERENCE ---
// Mang Tomas (Patient) Sprites:
//   NEUTRAL/GUARDED = MangTomas_0
//   DEFENSIVE = MangTomas_1
//   RELIEVED = MangTomas_2
//   GRATEFUL = MangTomas_3
//
// Close-Up Images:
//   Red, Swollen Leg (Cellulitis) = MangTomasWoundCloseup_0
//   Wound from Rusty Fence = MangTomasWoundCloseup2_0
//
// Resident (Player) Sprites:
//   Neutral = residentVN_0
//   Happy = residentVN_1
//   Sad/Disappointed = residentVN_2


// --- SCENE 1: INTRODUCTION ---
# bg: BG (288)
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
The primary care clinic is warm. Mang Tomas, a 45-year-old farmer, enters slowly. He is limping, favoring his right leg. He looks tired but not severely ill. He sits down carefully, wincing as he lifts his leg.

# speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
"Doc, salamat po sa pagtanggap sa akin. Namamaga po at namumula ang binti ko. Masakit at mainit sa hawak. Dalawang araw na ito."

# closeup: MangTomasWoundCloseup_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You observe Mang Tomas's right lower leg. There is a clearly demarcated area of redness extending from the mid-calf to the ankle. The skin is warm, swollen, and tender to touch.

# closeup: MangTomasWoundCloseup2_0
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You notice a small healing wound on his shin from a rusty fence. He does not appear to have fever.

# speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
"Doc, nagtatrabaho po ako sa bukid. Noong isang linggo, lumusong ako sa baha. May maliit akong sugat sa binti. Hindi ko na inisip. Ngayon, lumaki na ang pamamaga at namumula."

# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Mang Tomas mentions he has no known diabetes or other chronic illnesses. He lives alone and works daily in the rice fields.


// --- SCENE 2: THE OPENING (EMPATHY SCORE) ---
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Mang Tomas is clearly in discomfort. He is a farmer who depends on his legs for work. Your opening approach will shape the consultation.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Focus on the wound and leg symptoms immediately]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Mang Tomas, let's focus on your leg. When exactly did the redness start? Did you have fever? Is the pain constant or does it come and go?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Tomas answers your questions but he seems guarded. He provides clinical facts but does not elaborate.

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Yung pamamaga, dalawang araw na. Wala naman akong lagnat. Masakit siya palagi, lalo na kapag tinatapakan ko."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Mang Tomas feels like just another case.
    -> information_gathering

* [Choice B: Acknowledge his work and how this affects him]
    ~ trust_level = "HIGH"
    ~ empathy_score = 5
    "Mang Tomas, I can see you're uncomfortable. You mentioned you work in the rice fields. Can you tell me how this has affected your work? What does a typical day look like for you?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Tomas sighs. He looks relieved that someone is asking about his situation.

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc, mahirap po. Hindi ako makapagtrabaho nang maayos. Naglalakad ako buong araw sa bukid. Ngayon, hirap na hirap ako. Natatakot ako na baka lumala ito at hindi na ako makapagtrabaho."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Trust established. Trust Level: HIGH. Mang Tomas feels heard and understood.
    -> information_gathering

* [Choice C: Ask about floodwater exposure and wound care]
    ~ trust_level = "LOW"
    ~ empathy_score = 2
    "Mang Tomas, you waded through floodwater. Did you clean the wound? Did you use any medicine? Floodwater is dirty—you should have cleaned it properly."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Tomas becomes defensive.

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_1
    "Doc, naghugas naman po ako ng tubig. Wala kaming malinis na tubig sa bukid. Hindi ko naman ginusto na lumusong sa baha. Kailangan kong magtrabaho."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Data obtained but patient feels judged. Trust Level: LOW.
    -> information_gathering

* [Choice D: Ask about previous skin infections and medical history]
    ~ trust_level = "NEUTRAL"
    ~ empathy_score = 3
    "Mang Tomas, have you had skin infections before? Any history of diabetes, leg swelling, or previous cellulitis?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Mang Tomas thinks for a moment. He seems willing to share but remains cautious.

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Wala naman po akong diabetes. Wala ring history ng ganito. Ngayon lang talaga ito nangyari. Yung sugat ko, galing sa bakod na kinakalawang."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Clinical data obtained. Trust Level: NEUTRAL. Patient is sharing but not fully open.
    -> information_gathering


// --- SCENE 3: INFORMATION GATHERING (FIRST ROUND) ---
== information_gathering ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You proceed with the consultation. Mang Tomas has given you some initial information. Now you need to decide what else to ask about.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about red flags: fever, chills, severe pain, rapidly spreading redness]
    ~ info_score += 2
    "Mang Tomas, I need to check for warning signs. Have you had any fever, chills, or severe pain that seems worse than the skin looks? Is the redness spreading quickly?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Wala naman po fever o chills. Yung sakit, kasya naman sa itsura ng pamamaga. Hindi naman mabilis kumalat. Kanina, ganito na ang laki."

    -> information_gathering_2

* [Ask about the wound: how it happened, when, any discharge]
    ~ info_score += 2
    "Mang Tomas, can you tell me more about the wound on your leg? How did you get it? Is there any discharge or pus?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Yung sugat, galing sa kinakalawang na bakod. Mga isang linggo na. May konting nana pero hindi naman dumadaloy. Yung paligid ng sugat, namumula na."

    -> information_gathering_2

* [Ask about limb elevation and rest]
    ~ info_score += 1
    "Mang Tomas, have you been resting your leg? Elevating it? Or have you been walking on it normally?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Hindi po ako nakakapagpahinga. Kailangan kong magtrabaho. Kahit masakit, naglalakad pa rin ako. Hindi ko maiangat ang binti ko nang matagal."

    -> information_gathering_2

* [Ask about other medical conditions and medications]
    ~ info_score += 2
    "Mang Tomas, do you have any other medical conditions? Are you taking any medications? Any allergies to antibiotics?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Wala naman po akong ibang sakit. Wala ring gamot. Wala ring allergy sa antibiotics. Ngayon lang talaga ako nagkasakit nang ganito."

    -> information_gathering_2


// --- SCENE 4: INFORMATION GATHERING (SECOND ROUND) ---
== information_gathering_2 ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have gathered initial information. Now you can ask one more set of questions to complete your assessment.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Ask about functional impact]
    ~ info_score += 1
    "Mang Tomas, how has this affected your ability to walk, work, or do daily activities?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc, nahihirapan na ako. Hindi ako makapagtrabaho nang maayos. Yung binti ko, mabigat at masakit. Natatakot ako na baka lumala pa."

    -> diagnosis_phase

* [Ask about health literacy and understanding of skin infections]
    ~ info_score += 1
    "Mang Tomas, what do you know about skin infections like this? What have you heard about how it's treated?"

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Ang alam ko po, dahil sa dumi ng baha. Sabi ng kapitbahay ko, dapat daw antibiotic. Pero hindi ko alam kung alin."

    -> diagnosis_phase

* [Ask about tetanus vaccination status]
    ~ info_score += 2
    "Mang Tomas, when was your last tetanus shot? The wound came from a rusty fence—tetanus is a concern."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Hindi ko na po matandaan. Matagal na. Wala akong bakuna sa tetanus. Hindi ko alam na kailangan pala."

    -> diagnosis_phase


// --- SCENE 5: DIAGNOSIS (CLINICAL SCORE) ---
== diagnosis_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
You have completed your assessment. Mang Tomas has:
- Well-demarcated, red, warm, swollen, tender right lower leg for 2 days
- Small healing wound on the shin from a rusty fence
- Waded through floodwater 1 week ago
- No fever, no chills, no severe systemic symptoms
- No rapidly spreading redness, no crepitation, no skin necrosis
- No diabetes, no chronic oedema, no previous cellulitis

Based on this information, how do you interpret his condition?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Cellulitis (Uncomplicated)]
    ~ clinical_score = 5
    "Mang Tomas, you have Cellulitis. This is a bacterial infection of the deep skin and tissues. The bacteria entered through the wound on your leg, likely from the floodwater. The redness, warmth, swelling, and pain are classic signs. Because you have no fever, no rapidly spreading infection, and no other medical conditions, this is an uncomplicated case that we can treat with oral antibiotics."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... kailangan ko bang ma-confine?"

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Not necessarily. We can manage this at home with oral antibiotics. I'll outline the area of redness to monitor if it spreads. You'll need to rest and elevate your leg. We also need to check your tetanus vaccination status because of the rusty fence wound."

    -> management_phase

* [Choice B: Necrotizing Fasciitis]
    ~ clinical_score = 2
    "Mang Tomas, this could be a serious deep tissue infection. We need to admit you immediately for IV antibiotics and possible surgery."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... ganun ba kalala? Wala naman akong fever. At yung sakit, kasya naman sa itsura."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have over-diagnosed. Mang Tomas has no fever, no pain out of proportion, no crepitation, and no rapid progression. This is uncomplicated cellulitis, not necrotizing fasciitis.
    -> management_phase

* [Choice C: Deep Vein Thrombosis (DVT)]
    ~ clinical_score = 2
    "The swelling and pain in your leg could be a blood clot. We should do a Doppler ultrasound."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... pero namumula at mainit ang balat ko. At may sugat ako. Hindi naman ganyan ang blood clot diba?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have missed the key signs of infection: redness, warmth, and a portal of entry (the wound). DVT typically presents with swelling and pain but without erythema or warmth.
    -> management_phase

* [Choice D: Contact Dermatitis]
    ~ clinical_score = 1
    "The redness could be an allergic reaction. Let's give you antihistamines and a steroid cream."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_1
    "Doc! Namamaga at mainit ang binti ko! At may sugat ako! Hindi naman ito allergy!"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have dismissed a bacterial infection. Contact dermatitis does not cause warmth, significant swelling, or a wound with purulent discharge.
    -> management_phase


// --- SCENE 6: MANAGEMENT (SAFETY SCORE) ---
== management_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
With the diagnosis considered, how do you proceed?

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Start Cephalexin + Outline Erythema + Elevation + Tetanus Prophylaxis]
    ~ safety_score = 4
    "Mang Tomas, I'm going to start you on Cephalexin 1000 mg twice a day for 7 days. This is the first-line antibiotic for cellulitis according to the Philippine National Antimicrobial Guideline. I will outline the red area with a pen so we can monitor if it spreads. You need to rest and elevate your leg as much as possible. Also, because your wound came from a rusty fence, we need to give you a tetanus vaccine. Come back in 3 days so we can check if the redness is improving."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... magkano po ang gamot? Mahirap lang po ako."

    # speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear
    "Cephalexin is available at the health center at a subsidized cost. You can also use your PhilHealth Konsulta benefits. The most important thing is to treat this now before it gets worse. Let's also make sure your tetanus vaccine is updated."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_2
    "Salamat, Doc. Akala ko magiging komplikado pa. Ngayon, alam ko na ang gagawin ko."

    -> education_phase

* [Choice B: Start Antibiotics Without Outlining or Tetanus Prophylaxis]
    ~ safety_score = 3
    "I'll start you on antibiotics. Take this for 5 days. Come back if it gets worse."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... paano ko po malalaman kung gumagaling na? At yung sugat ko galing sa kalawang—hindi ba kailangan ng tetanus shot?"

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have omitted two important steps: outlining the erythema to monitor progression, and tetanus prophylaxis for a rusty wound. Both are standard of care.
    -> education_phase

* [Choice C: Recommend Topical Antibiotic Only]
    ~ safety_score = 2
    "Just apply this antibiotic cream to the red area. No need for oral antibiotics."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_1
    "Doc! Malaki ang pamamaga! Hindi ba dapat oral antibiotic ito? Yung kapitbahay ko, ganito rin, pina-oral antibiotic."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have under-treated the infection. Topical antibiotics are for localized impetigo, not for cellulitis extending over a large area.
    -> education_phase

* [Choice D: Refer to Surgeon Immediately]
    ~ safety_score = 2
    "I'm going to refer you to a surgeon. This might need drainage."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... kailan po ako makakakita ng surgeon? Ang mahal po. At wala naman akong nana na dumadaloy."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    You have delayed treatment by referring to a specialist unnecessarily. Uncomplicated cellulitis without abscess can be managed in primary care.
    -> education_phase


// --- SCENE 7: PATIENT EDUCATION (ADDS TO SAFETY SCORE) ---
== education_phase ==
# speaker: Narrator # portrait_left: Clear # portrait_right: Clear
Before Mang Tomas leaves, you have an opportunity to educate him about prevention. This is your chance to ensure he understands how to avoid future skin infections.

# speaker: Player # portrait_left: residentVN_0 # portrait_right: Clear

* [Choice A: Explain the connection between wound care and infection]
    ~ safety_score += 1
    "Mang Tomas, any break in the skin—even a small wound—can let bacteria in. When you work in the fields, always clean wounds immediately with soap and clean water. Cover them with a bandage. If you wade through floodwater, wash your legs thoroughly afterward. And make sure your tetanus vaccine is up to date."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_3
    "Doc, naiintindihan ko na. Akala ko kasi maliit na sugat lang, hindi na importante. Ngayon, alam ko na."

    -> ending

* [Choice B: Just tell him to take the medicine and come back]
    ~ safety_score += 0
    "Take the medicine as prescribed and come back in 3 days."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Wala na po, Doc. Salamat."

    # speaker: Narrator # portrait_left: Clear # portrait_right: Clear
    Effect: Patient leaves without understanding prevention. Safety score unchanged.
    -> ending

* [Choice C: Use a simple analogy about skin and bacteria]
    ~ safety_score += 1
    "Mang Tomas, think of your skin like a wall. If there's a crack, bacteria can get in and cause trouble. That's what happened with your wound. Keeping wounds clean and covered is like repairing the wall. And the tetanus vaccine is like a shield for your body."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_3
    "Ah, ganun pala iyon, Doc. Parang bakod lang na may butas. Salamat, naiintindihan ko na."

    -> ending

* [Choice D: Give him a pamphlet about wound care]
    ~ safety_score += 0
    "Here's a pamphlet about wound care. Read it when you get home."

    # speaker: Mang Tomas # portrait_left: Clear # portrait_right: MangTomas_0
    "Doc... hindi po ako masyadong nagbabasa ng Ingles. At malabo ang mata ko."

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
        "Excellent work! You recognized uncomplicated Cellulitis, addressed Mang Tomas's work concerns with empathy, followed the Philippine National Antimicrobial Guideline by prescribing Cephalexin, outlined the erythema to monitor progression, and provided tetanus prophylaxis. Skin and soft tissue infections are common in Philippine primary care—your comprehensive approach will prevent complications."
    - clinical_score == 5 and empathy_score < 5 and safety_score == 5:
        "You made the correct diagnosis and appropriate management, but Mang Tomas left feeling judged. Remember, cellulitis is not about poor hygiene—it's about exposure to bacteria through breaks in the skin, often during work."
    - clinical_score == 5 and safety_score < 5:
        "You correctly diagnosed Cellulitis but failed to provide comprehensive care. Outlining the erythema, tetanus prophylaxis, and patient education are essential parts of management."
    - clinical_score < 5 and empathy_score == 5 and safety_score == 5:
        "You built trust and provided good care, but you missed the diagnosis. Remember: redness plus warmth plus swelling plus pain plus a portal of entry equals Cellulitis."
    - clinical_score < 5:
        "You misdiagnosed a common skin infection. Cellulitis is characterized by acute onset of red, painful, hot, swollen skin. Always look for a portal of entry and screen for red flags like necrotizing fasciitis."
    - else:
        "Keep practicing! Cellulitis is common but easily managed. Remember the key steps: confirm the diagnosis, prescribe appropriate antibiotics, outline the erythema, and address tetanus prophylaxis."
}

-> END