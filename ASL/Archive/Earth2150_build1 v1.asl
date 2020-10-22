//working from 13:40 today till ~17
//17:50 with IGT included
//around 30 minutes last night
//subtract 10 minutes from the final time

state("Earth2150") {
	
	//name of the area the player is currently in
	string30 areaName: 	0x63D254, 0x58, 0x0C, 0x44, 0x0C;
	
	//1 when in "freeroam" (able to start a mission), 0 otherwise
	int freeroam: 	0x5D0914;
	
	//1 when on the mission-end stats screen
	int missionEnd:	0x381454;
	
	//1 when loading
	int load:		0x5DB8F0;
	
	//4 in (some)loads and in the menu
	int menu:		0x345420;
	
	//counter, appears to be tied to game speed
	int counter:	0x367A50;
}

startup {
	//add settings groups
	settings.Add("ED", true, "Eurasian Dynasty");
	settings.Add("UCS", true, "United Civilized States");
	settings.Add("LC", true, "Lunar Corporation");
	
	//create a list of mission names, used in some logic
	vars.missionList = new List<string>();
	
	//add settings for each mission
	vars.missionsLC = new Dictionary<string, string> {
		{"LCUral", "Ural"},
		{"LCArctic", "Arctic"},
		{"LCHimalaya", "Himalaya"},
		{"LCKamchatka", "Kamchatka"},
		{"LCCanada", "Canada"},
		{"LCBaikal", "Baikal"},
		{"LCAmazon", "Amazon"},
		{"LCThe Great Lakes", "The Great Lakes"},
		{"LCMadagascar", "Madagascar"},
		{"LCAustralia", "Australia"},
		{"LCMozambique", "Mozambique"},
		{"LCRio de Janeiro", "Rio de Janeiro"},
		{"LCLesotho", "Lesotho"},
		{"LCPeru", "Peru"},
		{"LCAmazon2", "Amazon 2"},
		{"LCAndes", "Andes"},
		{"ACME", "Split at the end of ACME Lab missions"}
	};
	
	foreach (var Tag in vars.missionsLC) {
		vars.missionList.Add(Tag.Key);
		settings.Add(Tag.Key, true, Tag.Value, "LC");
    };
	
	vars.missionsUCS = new Dictionary<string, string> {
		{"UCSUral", "Ural"},
		{"UCSArctic", "Arctic"},
		{"UCSArctic II", "Arctic II"},
		{"UCSBaikal", "Baikal"},
		{"UCSAlaska", "Alaska"},
		{"UCSJapan", "Japan"},
		{"UCSKurtshatov FZ", "Kurtshatov FZ"},
		{"UCSGreat Lakes", "Great Lakes"},
		{"UCSIndia", "India"},
		{"UCSMadagascar", "Madagascar"},
		{"UCSAustralia", "Australia"},
		{"UCSEgypt", "Egypt"},
		{"UCSMozambique", "Mozambique"},
		{"UCSAndes", "Andes"},
		{"UCSColumbia", "Columbia"},
		{"SFL", "Split at the end of Stanford Lab missions"}
	};
		
	foreach (var Tag in vars.missionsUCS) {
		vars.missionList.Add(Tag.Key);
		settings.Add(Tag.Key, true, Tag.Value, "UCS");
    };
	
	vars.missionsED = new Dictionary<string, string> {
		{"EDUral", "Ural"},
		{"EDArctic", "Arctic"},
		{"EDArctic 2", "Arctic 2"},
		{"EDHimalaya", "Himalaya"},
		{"EDKamchatka", "Kamchatka"},
		{"EDLeviathan", "Leviathan"},
		{"EDAlaska", "Alaska"},
		{"EDJapan", "Japan"},
		{"EDCanada", "Canada"},
		{"EDAmazon -N-", "Amazon -N-"},
		{"EDGreat Lakes", "Great Lakes"},
		{"EDNew York", "New York"},
		{"EDIndonesia", "Indonesia"},
		{"EDArea 51", "Area 51"},
		{"EDMadagascar", "Madagascar"},
		{"EDIndia", "India"},
		{"EDAustralia", "Australia"},
		{"EDPanama", "Panama"},
		{"EDMozambique", "Mozambique"},
		{"EDRed Rock", "Red Rock"},
		{"EDNew Zealand", "New Zealand"},
		{"EDEgypt", "Egypt"},
		{"EDCongo", "Congo"},
		{"EDLesotho", "Lesotho"},
		{"EDAlgeria", "Algeria"},
		{"EDAndes", "Andes"},
		{"EDColumbia", "Columbia"}
	};
	
	foreach (var Tag in vars.missionsED) {
		vars.missionList.Add(Tag.Key);
		settings.Add(Tag.Key, true, Tag.Value, "ED");
    };
	
	//variable keeping track of the last played mission
	vars.realMission = "h";
	
	//variable keeping track of progress in the campaign to use in lab splits
	vars.currentProgress = 0;
	
}

update {
	if (current.areaName != old.areaName) {
		//this is an ugly mess but It Works so I Dont Care
		if (vars.missionList.Contains("LC" + current.areaName) ||
		vars.missionList.Contains("UCS" + current.areaName) ||
		vars.missionList.Contains("ED" + current.areaName) ||
		current.areaName == "ACME-Laboratory" ||
		current.areaName == "ACME-Lab" ||
		current.areaName == "Stanford Lab") {
			vars.realMission = current.areaName;
		}
		
		if (current.areaName == "Ural") {
			vars.currentProgress = 0;
		}
	}
	
	//if (current.areaName != old.areaName) {
	//	print(old.areaName + " -> " + current.areaName);
	//}
	
}

start {
	if (current.menu == 0 && old.menu == 4) {
		vars.realMission = "h";
		vars.currentProgress = 0;
		return true;
	}
}

split {
	//regular mission splits
	if (current.missionEnd == 1 && old.missionEnd == 0) {
		//LUNAR CORPORATION
		if (settings["LC" + vars.realMission]) {
			if (vars.realMission == "The Great Lakes") {	//have to have done Amazon1 to enter great lakes
				vars.currentProgress = 1;					//need to keep track of this for Amazon2 setting
				return true;
			}
		
			else {
				return true;
			}
		}
		
		if (vars.realMission == "Amazon" && vars.currentProgress == 1) {
			if (settings["LCAmazon2"]) {
				return true;
			}
		}
		
		//UNITED CIVILIZED STATES
		if (settings["UCS" + vars.realMission]) {
			return true;
		}
		
		if (settings["SFL"] && vars.realMission == "Stanford Lab") {
			return true;
		}
		
		//EURASIAN DYNASTY
		if (settings["ED" + vars.realMission]) {
			return true;
		}
	}
	
	//ACME Lab splits
	if (vars.realMission == "ACME-Laboratory" || vars.realMission == "ACME-Lab") {
		if (current.freeroam == 1 && old.freeroam == 0 && settings["ACME"]) {
			return true;
		}
	}
		
}

isLoading {
	return (current.load == 1);
}