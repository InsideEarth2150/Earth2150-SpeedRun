/* Contributers
                       
┌───────────────┐  
│    Role       │ 	   
├───────────────┼─────────────────────────────┐
│   Dev Lead    │  Animal                     │
│               │  ΛΝΙΜΛL™#0001               │
│               │  AnimalUK@outlook.com       │
├───────────────┼─────────────────────────────┤
│   Coder       │  Rythin	              │
│               │  Rythin#0135                │
├───────────────┼─────────────────────────────┤
│   Coder       │  FloatingHitPoint	      │
│               │  FloatingHitPoint#1507      │
└───────────────┴─────────────────────────────┘

 */

// IMPORTANT: If there is an issue, please report on Discord: https://discord.gg/yxtzdUZ

state("Earth2150") 
{
	string30 areaName: 	0x63D254, 0x58, 0x0C, 0x44, 0x0C;
	int freeroam: 		0x5D0914;
	int overlay:		0x381454;
	int missionEnd:		0x5D08D4;
	int load:		0x5DB8F0;
	int menu:		0x345420;
	int fmv:		0x359F54;
}

startup 
{
	settings.Add("ED", true, "Eurasian Dynasty");
	settings.Add("UCS", true, "United Civilized States");
	settings.Add("LC", true, "Lunar Corporation");
	
	vars.missionsLC = new Dictionary<string, string> {
		{"LCTutorial", "Tutorial"},
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
		{"LCIndia", "India"},
		{"LCEgypt", "Egypt"},
		{"LCCongo", "Congo"},
		{"LCPeru", "Peru"},
		{"LCAmazon2", "Amazon 2"},
		{"LCAndes", "Andes"},
		{"ACME", "Split at the end of ACME Lab missions"}
	};
	
	foreach (var Tag in vars.missionsLC) {
		settings.Add(Tag.Key, true, Tag.Value, "LC");
    };
	
	vars.missionsUCS = new Dictionary<string, string> {
		{"UCSTutorial", "Tutorial"},
		{"UCSUral", "Ural"},
		{"UCSArctic", "Arctic"},
		{"UCSArctic II", "Arctic II"},
		{"UCSBaikal", "Baikal"},
		{"UCSAlaska", "Alaska"},
		{"UCSJapan", "Japan"},
		{"UCSJapan II", "Japan II"},
		{"UCSKurtshatov FZ", "Kurtshatov FZ"},
		{"UCSGreat Lakes", "Great Lakes"},
		{"UCSNew York", "New York"},
		{"UCSIndia", "India"},
		{"UCSMadagascar", "Madagascar"},
		{"UCSAustralia", "Australia"},
		{"UCSEgypt", "Egypt"},
		{"UCSMozambique", "Mozambique"},
		{"UCSAndes", "Andes"},
		{"UCSColumbia", "Columbia"},
		{"UCSStanford Lab", "Split at the end of Stanford Lab missions"}
	};
		
	foreach (var Tag in vars.missionsUCS) {
		settings.Add(Tag.Key, true, Tag.Value, "UCS");
    };
	
	vars.missionsED = new Dictionary<string, string> {
		{"EDTutorial", "Tutorial"},
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
		settings.Add(Tag.Key, true, Tag.Value, "ED");
    };
	
	vars.realMission = "";
	vars.currentProgress = 0;
	vars.campaign = "";
	refreshRate = 30;
}

update {
	if (current.areaName != old.areaName) {
		if (current.areaName != null && !current.areaName.Contains("Base")) {
			vars.realMission = current.areaName;
			print("realMission = " + vars.realMission);
		}
		
		if (current.areaName == "Ural") {
			vars.currentProgress = 0;
		}
	}
	
	if (vars.realMission == "The Great Lakes" && vars.campaign == "LC") {
		if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1) {
			vars.currentProgress = 1;
		}
	}
	
	if (current.freeroam == 1 && old.freeroam == 0) {
		string currentBase = current.areaName;
		switch (currentBase) {
			case "LC Base":
			vars.campaign = "LC";
			print("Campaign set to: " + vars.campaign);
			break;
			
			case "ED Base":
			vars.campaign = "ED";
			print("Campaign set to: " + vars.campaign);
			break;
			
			case "UCS Base":
			vars.campaign = "UCS";
			print("Campaign set to: " + vars.campaign);
			break;
		}
	}
	
	if (current.fmv == 1 && old.fmv == 0) {
		print("FMV Started!");
	}
}

start {
	if (current.menu == 0 && old.menu == 4) {
		vars.realMission = "";
		vars.campaign = "";
		vars.currentProgress = 0;
		return true;
	}
}

split {
	if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1 || current.overlay == 1 && old.overlay == 0 && current.missionEnd == 1) {
		if (settings[vars.campaign + vars.realMission]) {
			return true;
		}
	}
	
	if (settings["LCAmazon2"]) {
		if (vars.realMission == "Amazon" && vars.currentProgress == 1) {
			if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1) {
				return true;
			}
		}
	}
	
	if (vars.realMission == "ACME-Lab" || vars.realMission == "ACME-Laboratory") {
		if (current.freeroam == 1 && old.freeroam == 0) {
			if (settings["ACME"]) {
				return true;
			}
		}
	}
	
	if (current.fmv == 1 && old.fmv == 0) {
		return true;
	}
}

isLoading {
	return (current.load == 1 || current.menu == 4);
}