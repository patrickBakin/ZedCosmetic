// ====================================================================
//	ZedCosmeticMut by Asapi1020
// ====================================================================
//	This mutator force zeds wear a hat.
//	Inspired by a Weekly Outbreak "WildWestLondon".
//	You can read an official code in "KFGame.KFCharacterInfo_Monster".
// 	It may help you to understand what is written here.
//	I tried making console commands to change config values in game
//	but I haven't completed yet.
// ====================================================================


// ====================================================================
//	ZedCosmeticMut by Asapi1020
// ====================================================================
//	This mutator force zeds wear a hat.
//	Inspired by a Weekly Outbreak "WildWestLondon".
//	You can read an official code in "KFGame.KFCharacterInfo_Monster".
// 	It may help you to understand what is written here.
//	I tried making console commands to change config values in game
//	but I haven't completed yet.
// ====================================================================

class ZedCosmeticMut extends KFMutator
	config(ZedCosmetic);

var string MeshPathes[25];
var transient LinearColor ZC_MonoChromeValue;
var transient LinearColor ZC_ColorValue;

var config int Version;
var config bool IgnoreStalkers;
var config string HatType;

var ZCRep ZCR;

event PostBeginPlay()
{
	super.PostBeginPlay();
    	ZCR = spawn(class'ZCRep');
    	ZCR.ZCM=self;
    
	SetupInteraction();
	SetupConfig();

	SaveConfig();
	ZCR.HatType=HatType;
	//AddMesh();

	//AddMesh();
}

function SetupInteraction()
{
	local KFPlayerController KFPC;
	local ZC_Interaction ZCI;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		ZCI = new (KFPC) class'ZC_Interaction';
		ZCI.OwningKFPC = KFPC;
		KFPC.Interactions.AddItem(ZCI);
	}
}

function SetupConfig()
{
	if(Version < 1)
	{
		IgnoreStalkers = true;
		HatType = "random";
		Version = 1;
	}
}

// it functioning now i guess...
function Mutate(string MutateString, PlayerController Sender)
{
	local array<string> StringParts;

	if (WorldInfo.NetMode == NM_Standalone || Sender.PlayerReplicationInfo.bAdmin)
	{
		StringParts = SplitString(MutateString, " ", true);

		if(StringParts[0] ~= "HatsIgnoreStalkers")
			ZCR.IgnoreStalkers = bool(StringParts[1]);

		else if (StringParts[0] ~= "SetHatType")
			ZCR.HatType = StringParts[1];
	}
	super.Mutate(MutateString, Sender);
}




/*function bool CheckRelevance(Actor Other)
{
	
	if(KFPawn(Other)!=none && KFPawn_Monster(Other)!=none){
		ZCR.Monster=KFPawn_Monster(Other);
		return true;
	}
	return super.CheckRelevance(Other);
}*/


defaultproperties
{
	
}
