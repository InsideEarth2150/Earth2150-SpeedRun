//Earth 2150 EftBP autosplitter v1.02

state("Earth2150")
{
	string16 areaName : 0x0063D254, 0x58, 0x0C, 0x44, 0x0C;
	int areaShown : 0x063d254;
	int resSent : 0x005D08C8, 0x84;
	bool chooseMissionUp: 0x005D0914;
}

startup
{
	vars.levels = new string[15]{
		"ACME-Laboratory",
		"Stanford Lab",
		"Ural",
		"Arctic",
		"Arctic II",
		"Alaska",
		"Baikal",
		"Japan",
		"Great Lakes",
		"New York",
		"Himalaya",
		"Kamchatka",
		"Leviathan",
		"Canada",
		"Amazon"
	};
	vars.matchFound=false;
	vars.oldArea="";
	print("variables set");
}

init
{
	print("Game process located");
}

start
{
	//starts when there is the current area name on the bottom left is shown
	if(current.areaName.Contains("Base")) return true;
}

split
{
	//splits whenever the Choose Mission button is available after a mission from the list
	//OR the game exits to the main menu when the campaign is over
	if(current.chooseMissionUp && !old.chooseMissionUp){
		vars.oldArea=old.areaName.Trim();
		vars.matchFound=false;
		foreach(string levelName in vars.levels){
			if(levelName==vars.oldArea){
				vars.matchFound=true;
				break;
			}
		}
		if(vars.matchFound) return true;	
		//if(vars.oldArea!="")
		//return true;
	}
	else if(current.areaShown==0){
		if(old.resSent>=1000000 || (old.resSent>=500000 && old.areaName.Contains("LC Base"))) return true;
	}
}