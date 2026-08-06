// Track player states for First Contact
VAR trust_level = "NEUTRAL"
VAR clinical_score = 0
VAR info_score = 0
VAR empathy_score = 0
VAR safety_score = 0
The clinic room is warm. Aling Rosa enters carrying her 7-month-old daughter, Maya.
"Doc, mainit po ang katawan niya. Hindi siya makatulog..."

* [Choice A: Focus on Physical Symptoms]
    ~ trust_level = "NEUTRAL"
    ~ clinical_score += 1
    "Good morning, Aling Rosa. Let's start with Maya's symptoms..." -> information_gathering

* [Choice B: Focus on Mother's Concerns (Empathy First)]
    ~ trust_level = "HIGH"
    ~ empathy_score += 5
    "Aling Rosa, I can see how worried you are..." -> information_gathering

== information_gathering ==
You proceed with the consultation.
-> END