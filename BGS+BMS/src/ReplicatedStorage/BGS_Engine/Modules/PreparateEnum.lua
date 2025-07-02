local module = {
	preparateNames = {
		"Gauze", "Tourniquet", "Plastic Cover", 
		"Suture Kit", "Painkiller", "Morphine", 
		"Caffeine", "Blood bag", "Splint", 
		"CPR", "Draw blood", "Defibrillator", 
		"Epinephrine", "Amputation"
	},
	
	waitingTimes = {
		7, 3, 7, 
		15, 2, 5, 
		3, 15, 5,
		15, 15, 5,
		5, 10
	},
	
	Gauze =        0, -- field treatments
	Tourniquet =   1, -- field treatments
	PlasticCover = 2, -- field treatments
	
	SutureKit =    3, -- further treatments
	
	Painkiller =   4, -- medicaments
	Morphine =     5, -- medicaments
	Caffeine =     6, -- medicaments
	
	BloodBag =     7, -- further treatments
	
	Splint =       8, -- field treatments
	
	CPR =          9, -- heart treatments
	DrawBlood =   10, -- further treatments
	
	Defibrillator=11, -- heart treatments
	Epinephrine = 12, -- medicaments
	Amputation =  13, -- further treatments
}

return module
