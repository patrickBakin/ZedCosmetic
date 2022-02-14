class ZCRep extends ReplicationInfo
dependson(ZedCosmeticMut);
var ZedCosmeticMut ZCM;
var string MeshPathes[25];
var transient LinearColor ZC_MonoChromeValue;
var transient LinearColor ZC_ColorValue;
var repnotify KFPawn_Monster Monster;
var bool IgnoreStalkers;
var string HatType;
replication
{
	if(bNetDirty)
		MeshPathes,ZC_ColorValue,ZC_MonoChromeValue,ZCM,Monster,HatType,IgnoreStalkers;
}

simulated event PreBeginPlay(){
	super.PreBeginPlay();
	AddMesh();
	SetTimer(2,true,'AddHattoZed');
}
/*
simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'Monster')
	{
	   AddHat(Monster);
	}
}*/

simulated function AddHattoZed(){
	local KFPawn_Monster KFPM;
	foreach WorldInfo.AllPawns(class'KFPawn_Monster',KFPM){
		if(KFPM!=none && KFPM.IsAliveAndWell() && !KFPM.bIsHeadless && KFPM.CharacterMICs.Length<=2)
			AddHat(KFPM);
	}
}
simulated function AddHat(Pawn AIPawn){

	local KFPawn KFP;
	local int i;
	local StaticAttachments NewAttachment;
	local StaticMeshComponent StaticAttachment;
	local MaterialInstanceConstant NewMIC;
	KFP = KFPawn(AIPawn);

	if( KFP != none && KFPawn_Monster(KFP) != none &&
		!(KFGameReplicationInfo(KFP.WorldInfo.GRI).bIsWeeklyMode && (class'KFGameEngine'.static.GetWeeklyEventIndexMod() == 12)) &&
		!(IgnoreStalkers && KFPawn_ZedStalker(KFP) != none))
	{
		if(HatType ~= "cowboy")
			i = 0;
		else if(HatType ~= "xmas")
			i = 1 + Rand(8);
		else if(HatType ~= "halloween")
			i = 9 + Rand(9);
		else
			i = Rand(25);

		NewAttachment.StaticAttachment = StaticMesh(DynamicLoadObject(MeshPathes[i], class'StaticMesh'));
		NewAttachment.AttachSocketName = KFPawn_Monster(KFP).ZEDCowboyHatAttachName;
		if(NewAttachment.StaticAttachment==none) LogInternal("StaticAttachment==================None");
		StaticAttachment = new (KFP) class'StaticMeshComponent';
		if (StaticAttachment != none)
		{
			KFPawn_Monster(KFP).StaticAttachList.AddItem(StaticAttachment);
			StaticAttachment.SetActorCollision(false, false);
			StaticAttachment.SetStaticMesh(NewAttachment.StaticAttachment);
			StaticAttachment.SetShadowParent(KFP.Mesh);
			StaticAttachment.SetLightingChannels(KFP.PawnLightingChannel);
			NewMIC = StaticAttachment.CreateAndSetMaterialInstanceConstant(0);
			NewMIC.SetVectorParameterValue('color_monochrome', ZC_MonoChromeValue);
			NewMIC.SetVectorParameterValue('Black_White_switcher', ZC_ColorValue);
			KFP.AttachComponent(StaticAttachment);
			KFP.Mesh.AttachComponentToSocket(StaticAttachment, NewAttachment.AttachSocketName);
			KFP.CharacterMICs.AddItem(NewMIC);
		}
	}
}

simulated function AddMesh(){

	MeshPathes[0]="CHR_CosmeticSet01_MESH.cowboyhat.CHR_CowboyHat_Alberts_Cosmetic";// 0
	MeshPathes[1]="CHR_Cosmetic_XMAS_MESH.CHR_PoinsettaHat_Cosmetic" ;//1
	MeshPathes[2]="CHR_Cosmetic_XMAS_MESH.CHR_Ushanka_Cosmetic";
	MeshPathes[3]="CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_ChimneyHat";
	MeshPathes[4]="CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_Treeyhat";
	MeshPathes[5]="CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_Penguinhat";
	MeshPathes[6]="CHR_CosmeticSet_XMAS_03_MESH.snowmancap.CHR_Cosmetic_XMas19_SnowmanCap_LOD1";
	MeshPathes[7]="CHR_CosmeticSet_XMAS_03_MESH.TopHat.CHR_Cosmetic_XMas19_TopHat_LOD0";
	MeshPathes[8]="CHR_CosmeticSet_XMAS_03_MESH.clotthat.CHR_Cosmetic_XMas19_ClotHat_LOD0";
	MeshPathes[9]="CHR_CosmeticSet_Halloween_01_MESH.CHR_Cosmetic_Halloween_Axed" ;// 9
	MeshPathes[10]="CHR_CosmeticSet_Halloween_02_MESH.CHR_Cosmetic_Halloween_PirateHat";
	MeshPathes[11]="CHR_CosmeticSet_Halloween_02_MESH.CHR_Cosmetic_Halloween_WitchHat";
	MeshPathes[12]="CHR_CosmeticSet_Halloween_03_MESH.batcathat.CHR_Cosmetic_Halloween19_BatCatHat";
	MeshPathes[13]="CHR_CosmeticSet_Halloween_03_MESH.biohazardhat.CHR_Cosmetic_Halloween19_BiohazardHat";
	MeshPathes[14]="CHR_CosmeticSet_Halloween_03_MESH.monsterwitchhat.CHR_Cosmetic_Halloween19_MonsterWitchHat";
	MeshPathes[15]="CHR_CosmeticSet_Halloween_03_MESH.pumpkinhat.CHR_Cosmetic_Halloween19_PumpkinHat";
//	MeshPathes[0]="CHR_CosmeticSet_Halloween_04_MESH.CHR_HalloweenFingerTophat_Cosmetic") // This item doesn't work properly
	MeshPathes[16]="CHR_CosmeticSet_Halloween_04_MESH.CHR_HalloweenSorceressHat_Cosmetic";
	MeshPathes[17]="CHR_CosmeticSet_Halloween_05_MESH.muertos_tophat.CHR_MuertosTopHat_Cosmetic";
	MeshPathes[18]="CHR_CosmeticSet_Spring_01_MESH.cyborg_brainhelmet.CHR_CyborgBrainHelmet_Cosmetic"	;// 19 // 18
	MeshPathes[19]="CHR_CosmeticSet_SS_01_MESH.CHR_Clown_Hat";
	MeshPathes[20]="CHR_CosmeticSet_SS_01_MESH.CHR_Tiny_Hat_Alberts";
	MeshPathes[21]="CHR_CosmeticSet_SS_01_MESH.CHR_Witchdoctor_Hat";
	MeshPathes[22]="CHR_CosmeticSet_Steampunk01_MESH.flatcap.SP_FlatCap_Mesh";
	MeshPathes[23]="CHR_CosmeticSet_Steampunk01_MESH.TopHat.SP_TopHat_Mesh";
	MeshPathes[24]="CHR_CosmeticSet01_MESH.chefhat.CHR_ChefHat_Alberts_Cosmetic_LOD0_LOD0";

	ZC_MonoChromeValue = MakeLinearColor(1.0,0.0,0.0,255);
	ZC_ColorValue = MakeLinearColor(1.0,0.0,0.0,255);
}