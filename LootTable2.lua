-----------------------------------------------------------------------------------------------
-- Client Lua Script for LootTable2
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------

require "Apollo"
require "GameLib"
require "FriendshipLib"
require "ChallengesLib"
require "QuestLib"

local LootTable2 = {}

local kItemTooltipWindowWidth = 300
local kstrTab = "    "
local kUIBody = "ff39b5d4"
local kUITeal = "ff53aa7f"
local kUIRed = "ffda2a00" -- "ffab472f" Sat +50
local kUIGreen = "ff42da00" -- "ff55ab2f" Sat +50
local kUIYellow = kUIBody
local kUILowDurability = "yellow"
local kUIHugeFontSize = "CRB_HeaderSmall"

local karSimpleDispositionUnitTypes =
{
	["Simple"]			= true,
	["Chest"]			= true,
	["Door"]			= true,
	["Collectible"]		= true,
	["Platform"]		= true,
	["Mailbox"]			= true,
	["BindPoint"]		= true,
}

local karNPCDispositionUnitTypes =
{
	["NonPlayer"]			= true,
	["Destructible"]		= true,
	["Vehicle"]				= true,
	["Corpse"]				= true,
	["Mount"]				= true,
	["Taxi"]				= true,
	["DestructibleDoor"]	= true,
	["Turret"]				= true,
	["Pet"]					= true,
	["Esper Pet"]			= true,
	["Scanner"]				= true,
	["StructuredPlug"]		= true,
}

local ktMicrochipTypeNames =
{
	[Item.CodeEnumMicrochipType.PowerSource] 	= Apollo.GetString("CRB_Crafting_Circuit_Power_Core"),
	[Item.CodeEnumMicrochipType.Stat] 			= Apollo.GetString("CRB_Crafting_Circuit_Stat"),
	[Item.CodeEnumMicrochipType.PowerUp] 		= Apollo.GetString("CRB_Crafting_Circuit_Power_Up"),
	[Item.CodeEnumMicrochipType.Special] 		= Apollo.GetString("CRB_Crafting_Circuit_Special"),
	[Item.CodeEnumMicrochipType.Set]			= Apollo.GetString("CRB_Crafting_Circuit_Set"),
	[Item.CodeEnumMicrochipType.Omni] 			= Apollo.GetString("CRB_Crafting_Circuit_Omni"),
	[Item.CodeEnumMicrochipType.Capacitor] 		= Apollo.GetString("CRB_Crafting_Circuit_Capacitor"),
	[Item.CodeEnumMicrochipType.Resistor] 		= Apollo.GetString("CRB_Crafting_Circuit_Resistor"),
	[Item.CodeEnumMicrochipType.Inductor] 		= Apollo.GetString("CRB_Crafting_Circuit_Inductor")
}

local karClassToString =
{
	[GameLib.CodeEnumClass.Warrior]       	= Apollo.GetString("ClassWarrior"),
	[GameLib.CodeEnumClass.Engineer]      	= Apollo.GetString("ClassEngineer"),
	[GameLib.CodeEnumClass.Esper]         	= Apollo.GetString("ClassESPER"),
	[GameLib.CodeEnumClass.Medic]         	= Apollo.GetString("ClassMedic"),
	[GameLib.CodeEnumClass.Stalker]       	= Apollo.GetString("ClassStalker"),
	[GameLib.CodeEnumClass.Spellslinger]    = Apollo.GetString("ClassSpellslinger"),
}

local ktClassToIcon =
{
	[GameLib.CodeEnumClass.Medic]       	= "Icon_Windows_UI_CRB_Medic",
	[GameLib.CodeEnumClass.Esper]       	= "Icon_Windows_UI_CRB_Esper",
	[GameLib.CodeEnumClass.Warrior]     	= "Icon_Windows_UI_CRB_Warrior",
	[GameLib.CodeEnumClass.Stalker]     	= "Icon_Windows_UI_CRB_Stalker",
	[GameLib.CodeEnumClass.Engineer]    	= "Icon_Windows_UI_CRB_Engineer",
	[GameLib.CodeEnumClass.Spellslinger]  	= "Icon_Windows_UI_CRB_Spellslinger",
}

local ktPathToString =
{
	[PlayerPathLib.PlayerPathType_Soldier]    = Apollo.GetString("PlayerPathSoldier"),
	[PlayerPathLib.PlayerPathType_Settler]    = Apollo.GetString("PlayerPathSettler"),
	[PlayerPathLib.PlayerPathType_Scientist]  = Apollo.GetString("PlayerPathExplorer"),
	[PlayerPathLib.PlayerPathType_Explorer]   = Apollo.GetString("PlayerPathScientist"),
}

local ktPathToIcon =
{
	[PlayerPathLib.PlayerPathType_Soldier]    = "Icon_Windows_UI_CRB_Soldier",
	[PlayerPathLib.PlayerPathType_Settler]    = "Icon_Windows_UI_CRB_Colonist",
	[PlayerPathLib.PlayerPathType_Scientist]  = "Icon_Windows_UI_CRB_Scientist",
	[PlayerPathLib.PlayerPathType_Explorer]   = "Icon_Windows_UI_CRB_Explorer",
}

local karFactionToString =
{
	[Unit.CodeEnumFaction.ExilesPlayer]     = Apollo.GetString("CRB_Exile"),
	[Unit.CodeEnumFaction.DominionPlayer]   = Apollo.GetString("CRB_Dominion"),
}

local karDispositionColors =
{
	[Unit.CodeEnumDisposition.Neutral]  = ApolloColor.new("DispositionNeutral"),
	[Unit.CodeEnumDisposition.Hostile]  = ApolloColor.new("DispositionHostile"),
	[Unit.CodeEnumDisposition.Friendly] = ApolloColor.new("DispositionFriendly"),
}

local karDispositionColorStrings =
{
	[Unit.CodeEnumDisposition.Neutral]  = "DispositionNeutral",
	[Unit.CodeEnumDisposition.Hostile]  = "DispositionHostile",
	[Unit.CodeEnumDisposition.Friendly] = "DispositionFriendly",
}

local karDispositionFrameSprites =
{
	[Unit.CodeEnumDisposition.Neutral]  = "sprTooltip_SquareFrame_UnitYellow",
	[Unit.CodeEnumDisposition.Hostile]  = "sprTooltip_SquareFrame_UnitRed",
	[Unit.CodeEnumDisposition.Friendly] = "sprTooltip_SquareFrame_UnitGreen",
}

local karRaceToString =
{
	[GameLib.CodeEnumRace.Human] 	= Apollo.GetString("RaceHuman"),
	[GameLib.CodeEnumRace.Granok] 	= Apollo.GetString("RaceGranok"),
	[GameLib.CodeEnumRace.Aurin] 	= Apollo.GetString("RaceAurin"),
	[GameLib.CodeEnumRace.Draken] 	= Apollo.GetString("RaceDraken"),
	[GameLib.CodeEnumRace.Mechari] 	= Apollo.GetString("RaceMechari"),
	[GameLib.CodeEnumRace.Chua] 	= Apollo.GetString("RaceChua"),
	[GameLib.CodeEnumRace.Mordesh] 	= Apollo.GetString("CRB_Mordesh"),
}

local karConInfo =
{
	{-4, ApolloColor.new("ConTrivial"), 	Apollo.GetString("TargetFrame_Trivial"), 	Apollo.GetString("Tooltips_None"), 		"ff7d7d7d"},
	{-3, ApolloColor.new("ConInferior"), 	Apollo.GetString("TargetFrame_Inferior"), 	Apollo.GetString("Tooltips_Minimal"), 	"ff01ff07"},
	{-2, ApolloColor.new("ConMinor"), 		Apollo.GetString("TargetFrame_Minor"), 		Apollo.GetString("Tooltips_Minor"), 	"ff01fcff"},
	{-1, ApolloColor.new("ConEasy"), 		Apollo.GetString("TargetFrame_Easy"), 		Apollo.GetString("Tooltips_Low"), 		"ff597cff"},
	{ 0, ApolloColor.new("ConAverage"), 	Apollo.GetString("TargetFrame_Average"), 	Apollo.GetString("Tooltips_Normal"), 	"ffffffff"},
	{ 1, ApolloColor.new("ConModerate"), 	Apollo.GetString("TargetFrame_Moderate"), 	Apollo.GetString("Tooltips_Improved"), 	"ffffff00"},
	{ 2, ApolloColor.new("ConTough"), 		Apollo.GetString("TargetFrame_Tough"), 		Apollo.GetString("Tooltips_High"), 		"ffff8000"},
	{ 3, ApolloColor.new("ConHard"), 		Apollo.GetString("TargetFrame_Hard"), 		Apollo.GetString("Tooltips_Major"), 	"ffff0000"},
	{ 4, ApolloColor.new("ConImpossible"), 	Apollo.GetString("TargetFrame_Impossible"), Apollo.GetString("Tooltips_Superior"),	"ffff00ff"}
}

local ktRankDescriptions =
{
	[Unit.CodeEnumRank.Fodder] 		= 	Apollo.GetString("TargetFrame_Fodder"),
	[Unit.CodeEnumRank.Minion] 		= 	Apollo.GetString("TargetFrame_Minion"),
	[Unit.CodeEnumRank.Standard]	= 	Apollo.GetString("TargetFrame_Grunt"),
	[Unit.CodeEnumRank.Champion] 	=	Apollo.GetString("TargetFrame_Challenger"),
	[Unit.CodeEnumRank.Superior] 	=  	Apollo.GetString("TargetFrame_Superior"),
	[Unit.CodeEnumRank.Elite] 		= 	Apollo.GetString("TargetFrame_Prime"),
}

local ktRewardToIcon =
{
	["Quest"] 			= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_ActiveQuest",
	["Challenge"] 		= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_Challenge",
	["Explorer"] 		= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PathExp",
	["Scientist"] 		= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PathSci",
	["Soldier"] 		= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PathSol",
	["Settler"] 		= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PathSet",
	["PublicEvent"] 	= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PublicEvent",
	["Rival"] 			= "ClientSprites:Icon_Windows_UI_CRB_Rival",
	["Friend"] 			= "ClientSprites:Icon_Windows_UI_CRB_Friend",
	["ScientistSpell"]	= "CRB_TargetFrameRewardPanelSprites:sprTargetFrame_PathSciSpell"
}

local ktRewardToString =
{
	["Quest"] 			= Apollo.GetString("Tooltips_Quest"),
	["Challenge"] 		= Apollo.GetString("Tooltips_Challenge"),
	["Explorer"] 		= Apollo.GetString("ZoneMap_ExplorerMission"),
	["Scientist"] 		= Apollo.GetString("ZoneMap_ScientistMission"),
	["Soldier"] 		= Apollo.GetString("ZoneMap_SoldierMission"),
	["Settler"] 		= Apollo.GetString("ZoneMap_SettlerMission"),
	["PublicEvent"] 	= Apollo.GetString("ZoneMap_PublicEvent"),
	["Rival"] 			= Apollo.GetString("Tooltips_Rival"),
	["Friend"] 			= Apollo.GetString("Tooltips_Friend"),
	["ScientistSpell"]	= Apollo.GetString("PlayerPathScientist")
}

local karSigilTypeToIcon =
{
	[Item.CodeEnumSigilType.Air] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Air",
	[Item.CodeEnumSigilType.Water] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Water",
	[Item.CodeEnumSigilType.Earth] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Earth",
	[Item.CodeEnumSigilType.Fire] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Fire",
	[Item.CodeEnumSigilType.Logic] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Logic",
	[Item.CodeEnumSigilType.Life] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Life",
	[Item.CodeEnumSigilType.Omni] 				= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Omni",
	[Item.CodeEnumSigilType.Fusion] 			= "ClientSprites:Icon_Windows_UI_CRB_Tooltip_Fusion",
}

local karSigilTypeToString =
{
	[Item.CodeEnumSigilType.Air] 				= Apollo.GetString("CRB_Air"),
	[Item.CodeEnumSigilType.Water] 				= Apollo.GetString("CRB_Water"),
	[Item.CodeEnumSigilType.Earth] 				= Apollo.GetString("CRB_Earth"),
	[Item.CodeEnumSigilType.Fire] 				= Apollo.GetString("CRB_Fire"),
	[Item.CodeEnumSigilType.Logic] 				= Apollo.GetString("CRB_Logic"),
	[Item.CodeEnumSigilType.Life] 				= Apollo.GetString("CRB_Life"),
	[Item.CodeEnumSigilType.Omni] 				= Apollo.GetString("CRB_Omni"),
	[Item.CodeEnumSigilType.Fusion] 			= Apollo.GetString("CRB_Fusion"),
}

local ktAttributeToText =
{
	[Unit.CodeEnumProperties.Dexterity] 					= Apollo.GetString("CRB_Finesse"),
	[Unit.CodeEnumProperties.Technology] 					= Apollo.GetString("CRB_Tech_Attribute"),
	[Unit.CodeEnumProperties.Magic] 						= Apollo.GetString("CRB_Moxie"),
	[Unit.CodeEnumProperties.Wisdom] 						= Apollo.GetString("UnitPropertyInsight"),
	[Unit.CodeEnumProperties.Stamina] 						= Apollo.GetString("CRB_Grit"),
	[Unit.CodeEnumProperties.Strength] 						= Apollo.GetString("CRB_Brutality"),

	[Unit.CodeEnumProperties.Armor] 						= Apollo.GetString("CRB_Armor") ,
	[Unit.CodeEnumProperties.ShieldCapacityMax] 			= Apollo.GetString("CBCrafting_Shields"),

	[Unit.CodeEnumProperties.AssaultPower] 					= Apollo.GetString("CRB_Assault_Power"),
	[Unit.CodeEnumProperties.SupportPower] 					= Apollo.GetString("CRB_Support_Power"),
	[Unit.CodeEnumProperties.Rating_AvoidReduce] 			= Apollo.GetString("CRB_Strikethrough_Rating"),
	[Unit.CodeEnumProperties.Rating_CritChanceIncrease] 	= Apollo.GetString("CRB_Critical_Chance"),
	[Unit.CodeEnumProperties.RatingCritSeverityIncrease] 	= Apollo.GetString("CRB_Critical_Severity"),
	[Unit.CodeEnumProperties.Rating_AvoidIncrease] 			= Apollo.GetString("CRB_Deflect_Rating"),
	[Unit.CodeEnumProperties.Rating_CritChanceDecrease] 	= Apollo.GetString("CRB_Deflect_Critical_Hit_Rating"),
	[Unit.CodeEnumProperties.ManaPerFiveSeconds] 			= Apollo.GetString("CRB_Attribute_Recovery_Rating"),
	[Unit.CodeEnumProperties.HealthRegenMultiplier] 		= Apollo.GetString("CRB_Health_Regen_Factor"),
	[Unit.CodeEnumProperties.BaseHealth] 					= Apollo.GetString("CRB_Health_Max"),

	[Unit.CodeEnumProperties.ResistTech] 					= Apollo.GetString("Tooltip_ResistTech"),
	[Unit.CodeEnumProperties.ResistMagic]					= Apollo.GetString("Tooltip_ResistMagic"),
	[Unit.CodeEnumProperties.ResistPhysical]				= Apollo.GetString("Tooltip_ResistPhysical"),

	[Unit.CodeEnumProperties.PvPOffensiveRating] 			= Apollo.GetString("Tooltip_PvPOffense"),
	[Unit.CodeEnumProperties.PvPDefensiveRating]			= Apollo.GetString("Tooltip_PvPDefense"),
}

-- TODO REFACTOR, we can combine all these item quality tables into one
local karEvalColors =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "ItemQuality_Inferior",
	[Item.CodeEnumItemQuality.Average] 			= "ItemQuality_Average",
	[Item.CodeEnumItemQuality.Good] 			= "ItemQuality_Good",
	[Item.CodeEnumItemQuality.Excellent] 		= "ItemQuality_Excellent",
	[Item.CodeEnumItemQuality.Superb] 			= "ItemQuality_Superb",
	[Item.CodeEnumItemQuality.Legendary] 		= "ItemQuality_Legendary",
	[Item.CodeEnumItemQuality.Artifact]		 	= "ItemQuality_Artifact",
}

local karEvalSprites =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "sprTT_HeaderDarkGrey",
	[Item.CodeEnumItemQuality.Average] 			= "sprTT_HeaderWhite",
	[Item.CodeEnumItemQuality.Good] 			= "sprTT_HeaderGreen",
	[Item.CodeEnumItemQuality.Excellent] 		= "sprTT_HeaderBlue",
	[Item.CodeEnumItemQuality.Superb] 			= "sprTT_HeaderPurple",
	[Item.CodeEnumItemQuality.Legendary] 		= "sprTT_HeaderOrange",
	[Item.CodeEnumItemQuality.Artifact]		 	= "sprTT_HeaderLightPurple",
}

local karEvalInsetSprites =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "sprTT_HeaderInsetDarkGrey",
	[Item.CodeEnumItemQuality.Average] 			= "sprTT_HeaderInsetWhite",
	[Item.CodeEnumItemQuality.Good] 			= "sprTT_HeaderInsetGreen",
	[Item.CodeEnumItemQuality.Excellent] 		= "sprTT_HeaderInsetBlue",
	[Item.CodeEnumItemQuality.Superb] 			= "sprTT_HeaderInsetPurple",
	[Item.CodeEnumItemQuality.Legendary] 		= "sprTT_HeaderOrange",
	[Item.CodeEnumItemQuality.Artifact]		 	= "sprTT_HeaderInsetLightPurple"
}

local karEvalStrings =
{
	[Item.CodeEnumItemQuality.Inferior] 		= Apollo.GetString("CRB_Inferior"),
	[Item.CodeEnumItemQuality.Average] 			= Apollo.GetString("CRB_Average"),
	[Item.CodeEnumItemQuality.Good] 			= Apollo.GetString("CRB_Good"),
	[Item.CodeEnumItemQuality.Excellent] 		= Apollo.GetString("CRB_Excellent"),
	[Item.CodeEnumItemQuality.Superb] 			= Apollo.GetString("CRB_Superb"),
	[Item.CodeEnumItemQuality.Legendary] 		= Apollo.GetString("CRB_Legendary"),
	[Item.CodeEnumItemQuality.Artifact]		 	= Apollo.GetString("CRB_Artifact")
}

local karItemQualityToHeaderBG =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "CRB_Tooltips:sprTooltip_Header_Silver",
	[Item.CodeEnumItemQuality.Average] 			= "CRB_Tooltips:sprTooltip_Header_White",
	[Item.CodeEnumItemQuality.Good] 			= "CRB_Tooltips:sprTooltip_Header_Green",
	[Item.CodeEnumItemQuality.Excellent] 		= "CRB_Tooltips:sprTooltip_Header_Blue",
	[Item.CodeEnumItemQuality.Superb] 			= "CRB_Tooltips:sprTooltip_Header_Purple",
	[Item.CodeEnumItemQuality.Legendary] 		= "CRB_Tooltips:sprTooltip_Header_Orange",
	[Item.CodeEnumItemQuality.Artifact]		 	= "CRB_Tooltips:sprTooltip_Header_Pink",
}

local karItemQualityToHeaderBar =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "CRB_Tooltips:sprTooltip_RarityBar_Silver",
	[Item.CodeEnumItemQuality.Average] 			= "CRB_Tooltips:sprTooltip_RarityBar_White",
	[Item.CodeEnumItemQuality.Good] 			= "CRB_Tooltips:sprTooltip_RarityBar_Green",
	[Item.CodeEnumItemQuality.Excellent] 		= "CRB_Tooltips:sprTooltip_RarityBar_Blue",
	[Item.CodeEnumItemQuality.Superb] 			= "CRB_Tooltips:sprTooltip_RarityBar_Purple",
	[Item.CodeEnumItemQuality.Legendary] 		= "CRB_Tooltips:sprTooltip_RarityBar_Orange",
	[Item.CodeEnumItemQuality.Artifact]		 	= "CRB_Tooltips:sprTooltip_RarityBar_Pink",
}

local karItemQualityToBorderFrameBG =
{
	[Item.CodeEnumItemQuality.Inferior] 		= "CRB_Tooltips:sprTooltip_SquareFrame_Silver",
	[Item.CodeEnumItemQuality.Average] 			= "CRB_Tooltips:sprTooltip_SquareFrame_White",
	[Item.CodeEnumItemQuality.Good] 			= "CRB_Tooltips:sprTooltip_SquareFrame_Green",
	[Item.CodeEnumItemQuality.Excellent] 		= "CRB_Tooltips:sprTooltip_SquareFrame_Blue",
	[Item.CodeEnumItemQuality.Superb] 			= "CRB_Tooltips:sprTooltip_SquareFrame_Purple",
	[Item.CodeEnumItemQuality.Legendary] 		= "CRB_Tooltips:sprTooltip_SquareFrame_Orange",
	[Item.CodeEnumItemQuality.Artifact]		 	= "CRB_Tooltips:sprTooltip_SquareFrame_Pink",
}

local kcrGroupTextColor					= ApolloColor.new("crayBlizzardBlue")
local kcrFlaggedFriendlyTextColor 		= karDispositionColors[Unit.CodeEnumDisposition.Friendly]
local kcrDefaultUnflaggedAllyTextColor 	= karDispositionColors[Unit.CodeEnumDisposition.Friendly]
local kcrAggressiveEnemyTextColor 		= karDispositionColors[Unit.CodeEnumDisposition.Neutral]
local kcrNeutralEnemyTextColor 			= ApolloColor.new("crayDenim")


local knWndHeightBuffer

function LootTable2:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	self.currentLootTarget = nil -- current loot target
	self.currentSalvageableTarget = nil -- current salvageable target
	self.nUnitGameTime = nil -- time stamp since last kill in seconds
	self.nSalvageableGameTime = nil -- time since last 'ItemRemoved' in seconds
	self.tSavedData = { -- saved data table
		REVISION = 0,
		tSessions = {},
		tItems = {},
		tVirtualItems = {},
		tSalvageables = {}
	}
	self.sSessionKey = nil
	self.tSessionTable = nil

	return o
end

function LootTable2:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		"ToolTips",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
	
	-- create new session
	if self.sSessionKey == nil then
		local sSessionKey, tSessionTable = self:CreateSession()
		self.tSavedData.tSessions[sSessionKey] = tSessionTable
		self.sSessionKey = sSessionKey
		self.tSessionTable = tSessionTable
	end
end

function LootTable2:OnLoad()
    self.xmlDoc = XmlDoc.CreateFromFile("TooltipsForms.xml")
    self.xmlDoc:RegisterCallback("OnDocumentReady", self)

    local TT = Apollo.GetAddon("ToolTips")
	TT.UnitTooltipGen = function (luaCalller, wndContainer, unitSource, strProp)
		self.UnitTooltipGen(luaCaller, wndContainer, unitSource, strProp)
	end
end

function LootTable2:OnDocumentReady()
    if self.xmlDoc == nil then
        return
    end

	-- LootTable2 Event Handlers
	Apollo.RegisterEventHandler("UnitCreated", "OnUnitCreated", self)
	Apollo.RegisterEventHandler("CombatLogDamage", "OnCombatLogDamage", self)
	Apollo.RegisterEventHandler("LootedItem", "OnLootedItem", self)
	Apollo.RegisterEventHandler("ItemRemoved", "OnItemRemoved", self)
end

function LootTable2:UnitTooltipGen(wndContainer, unitSource, strProp)
	local self = Apollo.GetAddon("ToolTips")
	local this = Apollo.GetAddon("LootTable2")

	local wndTooltipForm = nil
	local bSkipFormatting = false -- used to identify when we switch to item tooltips (aka pinata loot)
	local bNoDisposition = false -- used to replace dispostion assets when they're not needed
	local bHideFormSecondary = true
	
	if not unitSource and strProp == "" then
		wndContainer:SetTooltipForm(nil)
		wndContainer:SetTooltipFormSecondary(nil)
		return
	elseif strProp ~= "" then
		if not self.wndPropTooltip or not self.wndPropTooltip:IsValid() then
			self.wndPropTooltip = wndContainer:LoadTooltipForm("ui\\Tooltips\\TooltipsForms.xml", "PropTooltip_Base", self)
		end
		self.wndPropTooltip:FindChild("NameString"):SetText(strProp)

		wndContainer:SetTooltipForm(self.wndPropTooltip)
		wndContainer:SetTooltipFormSecondary(nil)
		return
	end

	if not self.wndUnitTooltip or not self.wndUnitTooltip:IsValid() then
		self.wndUnitTooltip = wndContainer:LoadTooltipForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Base", self)
	end

	local wndTopDataBlock 			= self.wndUnitTooltip:FindChild("TopDataBlock")
	local wndMiddleDataBlock 		= self.wndUnitTooltip:FindChild("MiddleDataBlock") -- THIS GETS USED FOR A LOT!!
	local wndBottomDataBlock 		= self.wndUnitTooltip:FindChild("BottomDataBlock")
	local wndTopRight				= wndTopDataBlock:FindChild("RightSide")
	local wndMiddleDataBlockContent = wndMiddleDataBlock:FindChild("MiddleDataBlockContent")
	local wndPathIcon 				= wndTopRight:FindChild("PathIcon")
	local wndClassIcon 				= wndTopRight:FindChild("ClassIcon")
	local wndClassBack 				= wndTopRight:FindChild("ClassBack")
	local wndPathBack 				= wndTopRight:FindChild("PathBack")
	local wndLevelBack 				= wndTopRight:FindChild("LevelBack")
	local wndXpAwardString 			= wndBottomDataBlock:FindChild("XpAwardString")
	local wndBreakdownString 		= wndBottomDataBlock:FindChild("BreakdownString")
	local wndDispositionFrame 		= self.wndUnitTooltip:FindChild("DispositionArtFrame")
	local wndNameString 			= wndTopDataBlock:FindChild("NameString")
	local wndLevelString 			= self.wndUnitTooltip:FindChild("LevelString")
	local wndAffiliationString 		= self.wndUnitTooltip:FindChild("AffiliationString")

	local unitPlayer = GameLib.GetPlayerUnit()
	local eDisposition = unitSource:GetDispositionTo(unitPlayer)

	local fullWndLeft, fullWndTop, fullWndRight, fullWndBottom = self.wndUnitTooltip:GetAnchorOffsets()
	local topBlockLeft, topBlockTop, topBlockRight, topBlockBottom = self.wndUnitTooltip:FindChild("TopDataBlock"):GetAnchorOffsets()

	-- Basics
	wndLevelString:SetText(unitSource:GetLevel())
	wndNameString:SetText(string.format("<P Font=\"CRB_HeaderSmall\" TextColor=\"%s\">%s</P>", karDispositionColorStrings[eDisposition], unitSource:GetName()))
	wndDispositionFrame:SetSprite(karDispositionFrameSprites[eDisposition] or "")

	-- Unit to player affiliation
	local strAffiliationName = unitSource:GetAffiliationName() or ""
	wndAffiliationString:SetTextRaw(strAffiliationName)
	wndAffiliationString:Show(strAffiliationName ~= "")
	wndAffiliationString:SetTextColor(karDispositionColors[eDisposition])

	-- Reward info
	wndMiddleDataBlockContent:DestroyChildren()
	for idx, tRewardInfo in pairs(unitSource:GetRewardInfo() or {}) do
		local strRewardType = tRewardInfo.strType
		local bCanAddReward = true

		-- Only show active challenge rewards
		if strRewardType == "Challenge" then
			bCanAddReward = false
			for index, clgCurr in pairs(ChallengesLib.GetActiveChallengeList()) do
				if tRewardInfo.idChallenge == clgCurr:GetId() and clgCurr:IsActivated() and not clgCurr:IsInCooldown() and not clgCurr:ShouldCollectReward() then
					bCanAddReward = true
					break
				end
			end
		end

		if bCanAddReward and ktRewardToIcon[strRewardType] and ktRewardToString[strRewardType] then
			if strRewardType == "PublicEvent" then
				tRewardInfo.strTitle = tRewardInfo.peoObjective:GetEvent():GetName() or ""
			elseif strRewardType == "Soldier" or strRewardType == "Explorer" or strRewardType == "Settler" then
				tRewardInfo.strTitle = tRewardInfo.pmMission and tRewardInfo.pmMission:GetName() or ""
			elseif strRewardType == "Scientist" then
				if tRewardInfo.pmMission then
					if tRewardInfo.pmMission:GetMissionState() >= PathMission.PathMissionState_Unlocked then
						tRewardInfo.strTitle = tRewardInfo.pmMission:GetName()
					else
						tRewardInfo.strTitle = Apollo.GetString("TargetFrame_UnknownReward")
					end
				end
			end

			if tRewardInfo.strTitle and tRewardInfo.strTitle ~= "" then
				local wndReward = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Reward", wndMiddleDataBlockContent, self)
				wndReward:FindChild("Icon"):SetSprite(ktRewardToIcon[strRewardType])
				wndReward:FindChild("Label"):SetText(String_GetWeaselString(Apollo.GetString("Tooltip_TitleReward"), tRewardInfo.strTitle, ktRewardToString[strRewardType]))
				
				-- Adjust height to fit text
				wndReward:FindChild("Label"):SetHeightToContentHeight()
				if wndReward:FindChild("Label"):GetHeight() > wndReward:GetHeight() then
					local rewardWndLeft, rewardWndTop, rewardWndRight, rewardWndBottom = wndReward:GetAnchorOffsets()
					wndReward:SetAnchorOffsets(rewardWndLeft, rewardWndTop, rewardWndRight, wndReward:FindChild("Label"):GetHeight())
				end
			end
		end
	end

	local strUnitType = unitSource:GetType()
	if strUnitType == "Player" then

		-- Player
		local tSourceStats = unitSource:GetBasicStats()
		local ePathType = unitSource:GetPlayerPathType()
		local eClassType = unitSource:GetClassId()
		local bIsPvpFlagged = unitSource:IsPvpFlagged()

		wndPathIcon:SetSprite(ktPathToIcon[ePathType])
		wndClassIcon:SetSprite(ktClassToIcon[eClassType])

		-- Player specific affiliation override
		local strPlayerAffiliationName = unitSource:GetGuildName()
		if strPlayerAffiliationName then
			wndAffiliationString:SetTextRaw(String_GetWeaselString(Apollo.GetString("Nameplates_GuildDisplay"), strPlayerAffiliationName))
			wndAffiliationString:Show(true)
		end

		-- Player specific disposition color override
		local crColorToUse = karDispositionColors[eDisposition]
		if eDisposition == Unit.CodeEnumDisposition.Friendly then
			if unitSource:IsPvpFlagged() then
				crColorToUse = kcrFlaggedFriendlyTextColor
			elseif unitSource:IsInYourGroup() then
				crColorToUse = kcrGroupTextColor
			else
				crColorToUse = kcrDefaultUnflaggedAllyTextColor
			end
		else
			local bIsUnitFlagged = unitSource:IsPvpFlagged()
			local bAmIFlagged = GameLib.IsPvpFlagged()
			if not bAmIFlagged and not bIsUnitFlagged then
				crColorToUse = kcrNeutralEnemyTextColor
			elseif bAmIFlagged ~= bIsUnitFlagged then
				crColorToUse = kcrAggressiveEnemyTextColor
			end
		end
		wndNameString:SetTextColor(crColorToUse)
		wndAffiliationString:SetTextColor(crColorToUse)

		-- Determine if Exile Human or Cassian
		local strRaceString = ""
		local nRaceID = unitSource:GetRaceId()
		local nFactionID = unitSource:GetFaction()
		if nRaceID == GameLib.CodeEnumRace.Human then
			if nFactionID == Unit.CodeEnumFaction.ExilesPlayer then
				strRaceString = Apollo.GetString("CRB_ExileHuman")
			elseif nFactionID == Unit.CodeEnumFaction.DominionPlayer then
				strRaceString = Apollo.GetString("CRB_Cassian")
			end
		else
			strRaceString = karRaceToString[nRaceID]
		end

		local strBreakdown = String_GetWeaselString(Apollo.GetString("Tooltip_CharacterDescription"), tSourceStats.nLevel, strRaceString)
		if tSourceStats.nEffectiveLevel ~= 0 and unitSource:IsMentoring() then -- GOTCHA: Intentionally we don't care about IsRallied()
			strBreakdown = String_GetWeaselString(Apollo.GetString("Tooltips_MentoringAppend"), strBreakdown, tSourceStats.nEffectiveLevel)
		end
		if bIsPvpFlagged then
			strBreakdown = String_GetWeaselString(Apollo.GetString("Tooltips_PvpFlagged"), strBreakdown)
		end
		wndBreakdownString:SetText(strBreakdown)

		-- Friend or Rival
		if unitSource:IsFriend() then
			local wndReward = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Reward", wndMiddleDataBlockContent, self)
			wndReward:FindChild("Icon"):SetSprite(ktRewardToIcon["Friend"])
			wndReward:FindChild("Label"):SetText(ktRewardToString["Friend"])
			wndMiddleDataBlockContent:Show(true)
		end

		if unitSource:IsRival() then
			local wndReward = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Reward", wndMiddleDataBlockContent, self)
			wndReward:FindChild("Icon"):SetSprite(ktRewardToIcon["Rival"])
			wndReward:FindChild("Label"):SetText(ktRewardToString["Rival"])
			wndMiddleDataBlockContent:Show(true)
		end

		wndBottomDataBlock:Show(true)
		wndPathIcon:Show(true)
		wndClassIcon:Show(true)
		wndLevelString:Show(true)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(true)

	elseif karNPCDispositionUnitTypes[strUnitType] then
		-- NPC

		local nCon = self:HelperCalculateConValue(unitSource)
		if nCon == 1 then
			wndXpAwardString:SetAML("")
		else
			local strXPFinal = String_GetWeaselString(Apollo.GetString("Tooltips_XPAwardValue"), Apollo.GetString("Tooltips_XpAward"), karConInfo[nCon][4])
			wndXpAwardString:SetAML(string.format("<P Font=\"CRB_InterfaceSmall\" TextColor=\"UI_TextHoloBody\" Align=\"Right\">%s</P>", strXPFinal))
		end
		wndBreakdownString:SetText(ktRankDescriptions[unitSource:GetRank()] or "")

		-- Settler improvement
		if unitSource:IsSettlerImprovement() then
			if unitSource:IsSettlerReward() then
				local strSettlerRewardName = String_GetWeaselString(Apollo.GetString("Tooltips_SettlerReward"), unitSource:GetSettlerRewardName(), Apollo.GetString("CRB_Settler_Reward"))
				local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
				wndInfo:FindChild("Label"):SetText(strSettlerRewardName)
			else
				local tSettlerImprovementInfo = unitSource:GetSettlerImprovementInfo()

				for idx, strOwnerName in pairs(tSettlerImprovementInfo.arOwnerNames) do
					local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
					wndInfo:FindChild("Label"):SetText(Apollo.GetString("Tooltips_GetSettlerDepot")..strOwnerName)
				end

				if not tSettlerImprovementInfo.bIsInfiniteDuration then
					local strSettlerTimeRemaining = string.format(Apollo.GetString("CRB_Remaining_Time_Format"), tSettlerImprovementInfo.nRemainingTime)
					local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
					wndInfo:FindChild("Label"):SetText(strSettlerTimeRemaining)
				end

				for idx, tTier in pairs(tSettlerImprovementInfo.arTiers) do
					local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
					wndInfo:FindChild("Label"):SetText(String_GetWeaselString(Apollo.GetString("Tooltips_SettlerTier"), tTier.nTier, tTier.strName))
				end
			end
		end
		
		
		-- accumulate data
		local sName = unitSource:GetName()
		local tProperties = {}
		for kSession,tSession in pairs(this.tSavedData.tSessions) do
			for k,tUnits in pairs(tSession) do
				if k == "tUnits" then
					for kUnit, tUnit in pairs(tUnits) do
						if sName == kUnit then
							this:GetZoneProperties(tUnit.tZones, tProperties)
						end
					end
				end
			end
		end
		
		-- consolidate item data
		local tUnitData = { nKillCount = 0, nTotalMoney = 0, tLootTable = {} }
		for _,tProp in ipairs(tProperties) do
			-- add killCounts
			tUnitData.nKillCount = tUnitData.nKillCount + tProp.nKillCount
			
			for nItemId,tLoot in pairs(tProp.tLootTable) do
				if nItemId ~= "Cash" then
					tUnitData.tLootTable[nItemId] = tUnitData.tLootTable[nItemId] or {
						nItemId = nItemId,
						sItemName = this.tSavedData.tItems[nItemId].sItemName,
						sIcon = this.tSavedData.tItems[nItemId].sIcon,
						eItemQuality = this.tSavedData.tItems[nItemId].eItemQuality,
						nDropCount = 0,
						nTotalDropCount = 0,
						nMinDropCount = tLoot.nMinDropCount,
						nMaxDropCount = tLoot.nMaxDropCount
					}
					tUnitData.tLootTable[nItemId].nDropCount = tUnitData.tLootTable[nItemId].nDropCount + tLoot.nDropCount
					tUnitData.tLootTable[nItemId].nTotalDropCount = tUnitData.tLootTable[nItemId].nTotalDropCount + tLoot.nTotalDropCount
					tUnitData.tLootTable[nItemId].nMinDropCount = math.min(tUnitData.tLootTable[nItemId].nMinDropCount, tLoot.nMinDropCount)
					tUnitData.tLootTable[nItemId].nMaxDropCount = math.min(tUnitData.tLootTable[nItemId].nMaxDropCount, tLoot.nMaxDropCount)
				else
					tUnitData.nTotalMoney = tUnitData.nTotalMoney + tLoot.nTotalMoney
				end
			end
		end
		
		-- display loot in tooltip
		local tSortableLootTable = {}
		for k,v in pairs(tUnitData.tLootTable) do
			table.insert(tSortableLootTable, v)
		end

		tUnitData.tLootTable = tSortableLootTable
		table.sort(tUnitData.tLootTable, function (a,b) return a.nDropCount>b.nDropCount end)
		
		local bAddSeperator = true
		for i,v in ipairs(tUnitData.tLootTable) do
			-- add a seperator
			if bAddSeperator then
				Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "SeparatorSmallLine", wndMiddleDataBlockContent, this)
				bAddSeperator = false
			end
			-- add loot information to middle data block
			local wndLoot = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Reward", wndMiddleDataBlockContent, this)
			local nDropChance = (v.nDropCount/tUnitData.nKillCount)*100
			local sText = string.format("<P Font=\"CRB_InterfaceSmall\" TextColor=\"%s\">(%.1f%%) %s</P>", karEvalColors[v.eItemQuality], nDropChance, v.sItemName)
			
			wndLoot:FindChild("Icon"):SetSprite(v.sIcon)
			wndLoot:FindChild("Label"):SetText(sText)
			wndLoot:FindChild("Label"):SetHeightToContentHeight()
			if wndLoot:FindChild("Label"):GetHeight() > wndLoot:GetHeight() then
				local lootWndLeft, lootWndTop, lootWndRight, lootWndBottom = wndLoot:GetAnchorOffsets()
				wndLoot:SetAnchorOffsets(lootWndLeft, lootWndTop, lootWndRight, wndLoot:FindChild("Label"):GetHeight())
			end
		end
		
		if tUnitData.nKillCount>0 then
			Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "SeparatorSmallLine", wndMiddleDataBlockContent, this)
			local wndKillCount = Apollo.LoadForm(this.xmlDoc, "UnitTooltip_KillCash", wndMiddleDataBlockContent, this)
			wndKillCount:FindChild("Label"):SetText(tostring(tUnitData.nKillCount))
			
			if tUnitData.nTotalMoney >= 1 then
				local wndCashWindow = wndKillCount:FindChild("CashWindow")
				wndCashWindow:Show(true)
				wndCashWindow:SetAmount(math.floor(tUnitData.nTotalMoney/tUnitData.nKillCount), true)
			end	
		end
		

		-- Friendly Warplot structure
		if unitSource:IsFriendlyWarplotStructure() then
			local strCurrentTier = String_GetWeaselString(Apollo.GetString("CRB_WarplotPlugTier"), unitSource:GetCurrentWarplotTier())
			local wndCurrentTier = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
			wndCurrentTier:FindChild("Label"):SetText(strCurrentTier)
			if unitSource:CanUpgradeWarplotStructure() then
				local strCurrentCost = String_GetWeaselString(Apollo.GetString("CRB_WarplotPlugUpgradeCost"), unitSource:GetCurrentWarplotUpgradeCost())
				local wndCurrentCost = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
				wndCurrentCost:FindChild("Label"):SetText(strCurrentCost)
			end
		end

		wndBottomDataBlock:Show(true)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(true)
		wndXpAwardString:Show(eDisposition == Unit.CodeEnumDisposition.Hostile or eDisposition == Unit.CodeEnumDisposition.Neutral)
		wndBreakdownString:Show(true)

	elseif karSimpleDispositionUnitTypes[strUnitType] then

		-- Simple
		bNoDisposition = true

		wndBottomDataBlock:Show(false)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(true)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(false)

	elseif strUnitType == "InstancePortal" then
		-- Instance Portal
		bNoDisposition = true

		local tLevelRange = unitSource:GetInstancePortalLevelRange()
		if tLevelRange and tLevelRange.nMinLevel and tLevelRange.nMaxLevel then
			local strInstancePortalLevelRange = ""
			if tLevelRange.nMinLevel == tLevelRange.nMaxLevel then
				strInstancePortalLevelRange = string.format(Apollo.GetString("InstancePortal_RequiredLevel"), tLevelRange.nMaxLevel)
			else
				strInstancePortalLevelRange = string.format(Apollo.GetString("InstancePortal_LevelRange"), tLevelRange.nMinLevel, tLevelRange.nMaxLevel)
			end
			local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
			wndInfo:FindChild("Label"):SetText(strInstancePortalLevelRange)
		end

		local nPortalCompletionTime = unitSource:GetInstancePortalCompletionTime()
		if nPortalCompletionTime then
			local strInstanceCompletionTime = string.format(Apollo.GetString("InstancePortal_ExpectedCompletionTime"), nPortalCompletionTime)
			local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
			wndInfo:FindChild("Label"):SetText(strInstanceCompletionTime)
		end

		local nPortalRemainingTime = unitSource:GetInstancePortalRemainingTime()
		if nPortalRemainingTime and nPortalRemainingTime > 0 then
			local strInstancePortalRemainingTime = string.format(Apollo.GetString("CRB_Remaining_Time_Format"), nPortalRemainingTime)
			local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
			wndInfo:FindChild("Label"):SetText(strInstancePortalRemainingTime)
		end

		wndBottomDataBlock:Show(false)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(false)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(false)

	elseif strUnitType == "Harvest" then
		-- Harvestable
		bNoDisposition = true

		local strHarvestRequiredTradeskillName = unitSource:GetHarvestRequiredTradeskillName()
		local wndInfo = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Info", wndMiddleDataBlockContent, self)
		wndInfo:FindChild("Label"):SetText(strHarvestRequiredTradeskillName)

		if strHarvestRequiredTradeskillName then
			wndBreakdownString:SetText(string.format(Apollo.GetString("CRB_Requires_Tradeskill_Tier"), strHarvestRequiredTradeskillName, unitSource:GetHarvestRequiredTradeskillTier()))
		end

		wndBottomDataBlock:Show(true)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(false)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(true)

	elseif strUnitType == "PinataLoot" then
		local tLoot = unitSource:GetLoot()
		if tLoot then
			bNoDisposition = true

			if tLoot.eLootItemType == Unit.CodeEnumLootItemType.StaticItem then
				bHideFormSecondary = false
				local itemEquipped = tLoot.itemLoot:GetEquippedItemForItemType()
				-- Overwrite everything and show itemLoot tooltip instead
				wndTooltipForm = Tooltip.GetItemTooltipForm(self, wndContainer, tLoot.itemLoot, {bPrimary = true, itemCompare = itemEquipped, itemModData = tLoot.itemModData, tGlyphData = tLoot.itemSigilData})
				bSkipFormatting = true
			elseif tLoot.eLootItemType == Unit.CodeEnumLootItemType.Cash then
				local wndCash = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_Cash", wndMiddleDataBlockContent, self)
				wndCash:FindChild("CashWindow"):SetAmount(tLoot.monCurrency, true)

			elseif tLoot.eLootItemType == Unit.CodeEnumLootItemType.VirtualItem then
				local wndLoot = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_PinataLoot", wndMiddleDataBlockContent, self)
				local wndLootLeft, wndLootTop, wndLootRight, wndLootBottom = wndLoot:GetAnchorOffsets()

				wndLoot:FindChild("TextWindow"):SetText(tLoot.tVirtualItem.strFlavor)
				wndLoot:FindChild("TextWindow"):SetHeightToContentHeight()
				wndLoot:SetAnchorOffsets( wndLootLeft, wndLootTop, wndLootRight, math.max(wndLootBottom, wndLoot:FindChild("TextWindow"):GetHeight()))

			elseif tLoot.eLootItemType == Unit.CodeEnumLootItemType.AdventureSpell then
				local wndLoot = Apollo.LoadForm("ui\\Tooltips\\TooltipsForms.xml", "UnitTooltip_PinataLoot", wndMiddleDataBlockContent, self)
				local wndLootLeft, wndLootTop, wndLootRight, wndLootBottom = wndLoot:GetAnchorOffsets()

				wndLoot:FindChild("TextWindow"):SetText(tLoot.tAbility.strDescription)
				wndLoot:FindChild("TextWindow"):SetHeightToContentHeight()
				wndLoot:SetAnchorOffsets( wndLootLeft, wndLootTop, wndLootRight, math.max(wndLootBottom, wndLoot:FindChild("TextWindow"):GetHeight()))
			end
		end

		wndBottomDataBlock:Show(false)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(false)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(false)

	else -- error state, do name only
		bNoDisposition = true

		wndBottomDataBlock:Show(false)
		wndPathIcon:Show(false)
		wndClassIcon:Show(false)
		wndLevelString:Show(true)
		wndXpAwardString:Show(false)
		wndBreakdownString:Show(false)
	end

	-- formatting and resizing --
	if not bSkipFormatting then
		if bNoDisposition then
			wndNameString:SetTextColor(ApolloColor.new("UI_TextHoloBodyHighlight"))
			wndDispositionFrame:SetSprite("sprTooltip_SquareFrame_UnitTeal")
		end

		wndClassBack:Show(wndClassIcon:IsShown())
		wndPathBack:Show(wndPathIcon:IsShown())
		wndLevelBack:Show(wndLevelString:GetText() ~= "")

		-- Right anchor of name
		local lsLeft, lsTop, lsRight, lsBottom = wndNameString:GetAnchorOffsets()
		if wndPathIcon:IsShown() then
			local pathLeft, pathTop, pathRight, pathBottom = wndPathBack:GetAnchorOffsets()
			wndNameString:SetAnchorOffsets(lsLeft, lsTop, pathLeft, lsBottom)
		elseif wndClassIcon:IsShown() then
			local classLeft, classTop, classRight, classBottom = wndClassBack:GetAnchorOffsets()
			wndNameString:SetAnchorOffsets(lsLeft, lsTop, classLeft, lsBottom)
		elseif wndLevelString:IsShown() then
			local levelLeft, levelTop, levelRight, levelBottom = wndLevelBack:GetAnchorOffsets()
			wndNameString:SetAnchorOffsets(lsLeft, lsTop, levelLeft, lsBottom)
		else
			local levelLeft, levelTop, levelRight, levelBottom = wndLevelBack:GetAnchorOffsets()
			wndNameString:SetAnchorOffsets(lsLeft, lsTop, levelRight, lsBottom)
		end

		-- Vertical Height
		local nHeight = 16 -- Space between the bottom of BottomDataBlock and the bottom of the entire window

		local nNameWidth, nNameHeight = wndNameString:SetHeightToContentHeight()
		nNameHeight = math.max(nNameHeight, 32) -- 32 is starting height from XML
		local nTopDataBlockLeft, nTopDataBlockTop, nTopDataBlockRight, nTopDataBlockBottom = wndTopDataBlock:GetAnchorOffsets()
		wndTopDataBlock:SetAnchorOffsets(nTopDataBlockLeft, nTopDataBlockTop, nTopDataBlockRight, nTopDataBlockTop + math.max(32, lsTop + nNameHeight))

		local nTopDataBlockHeight = wndTopDataBlock:GetHeight()
		nHeight = nHeight + nTopDataBlockHeight

		if wndAffiliationString:IsShown() then
			local nLeft, nTop, nRight, nBottom = wndAffiliationString:GetAnchorOffsets()
			local nAffiliationBottom = nTopDataBlockHeight + wndAffiliationString:GetHeight()
			wndAffiliationString:SetAnchorOffsets(nLeft, nTopDataBlockHeight, nRight, nAffiliationBottom)

			local nLeft, nTop, nRight, nBottom = wndMiddleDataBlock:GetAnchorOffsets()
			wndMiddleDataBlock:SetAnchorOffsets(nLeft, nAffiliationBottom, nRight, nAffiliationBottom + wndMiddleDataBlock:GetHeight())

			nHeight = nHeight + wndAffiliationString:GetHeight()
		else
			local nLeft, nTop, nRight, nBottom = wndMiddleDataBlock:GetAnchorOffsets()
			wndMiddleDataBlock:SetAnchorOffsets(nLeft, nTopDataBlockHeight, nRight, nBottom)
		end

		-- Size middle block
		local bShowMiddleBlock = #wndMiddleDataBlockContent:GetChildren() > 0
		wndMiddleDataBlock:Show(bShowMiddleBlock)
		if bShowMiddleBlock then
			local nInnerHeight = wndMiddleDataBlockContent:ArrangeChildrenVert(0)
			local nOuterHeight = nInnerHeight + 8
			nHeight = nHeight + nOuterHeight + 8

			local nLeft, nTop, nRight, nBottom = wndMiddleDataBlockContent:GetAnchorOffsets()
			wndMiddleDataBlockContent:SetAnchorOffsets(nLeft, nTop, nRight, nTop + nInnerHeight)

			local nLeft, nTop, nRight, nBottom = wndMiddleDataBlock:GetAnchorOffsets()
			wndMiddleDataBlock:SetAnchorOffsets(nLeft, nTop, nRight, nTop + nOuterHeight)
		end

		-- Size Tooltip
		if wndXpAwardString:IsShown() or wndBreakdownString:IsShown() then
			nHeight = nHeight + wndBottomDataBlock:GetHeight()
		end

		self.wndUnitTooltip:SetAnchorOffsets(fullWndLeft, fullWndTop, fullWndRight, fullWndTop + nHeight)
	end

	if not wndTooltipForm then
		wndTooltipForm = self.wndUnitTooltip
	end

	self.unitTooltip = unitSource

	wndContainer:SetTooltipForm(wndTooltipForm)
	if bHideFormSecondary then
		wndContainer:SetTooltipFormSecondary(nil)
	end
end

-------------------------------------------------------------------------------
-- GetZoneProperties
-------------------------------------------------------------------------------
function LootTable2:GetZoneProperties(tZone, tProperties)
    for k,v in pairs(tZone) do
        if (k=="tProperties") then
            tProperties[#tProperties+1] = v
        else
            return self:GetZoneProperties(v, tProperties)
        end
    end
end

---------------------------------------------------------------------------------------------------
-- LootTable2 Functions
---------------------------------------------------------------------------------------------------
-- create and return session key and table
function LootTable2:CreateSession()
	local tSessionTable = { tDate = tDate, tUnits = {}, tGather = {} }
	local tDate = GameLib.GetServerTime()
	local tARC = GameLib.GetAccountRealmCharacter()
	
	local sSessionKey = string.format("%04d_%02d_%02d_%02d_%02d_%02d_%s_%s",
		tDate.nYear, tDate.nMonth, tDate.nDay, tDate.nHour, tDate.nMinute, tDate.nSecond,
		tARC.strRealm, tARC.strCharacter)
	return sSessionKey, tSessionTable
end

-- Assign dropped loot to correct unit
function LootTable2:AssignUnitLoot(loot)
	local tPinataLoot = loot:GetLoot()
	
	-- get time difference
	local nTimeDiff = nil
	if self.nUnitGameTime ~= nil then
		nTimeDiff = GameLib.GetGameTime()-self.nUnitGameTime
	end
	
	local tUnitLootTable = nil
	local tUnitVirtualLootTable = nil
	-- if time differance is LE 1s and we have a loot target (killed mob)
	if nTimeDiff ~= nil and nTimeDiff <= 1 and self.currentLootTarget then
		-- go deep into the rabbit hole
		local sZoneNames = { GameLib.GetCurrentZoneMap().strName, GetCurrentZoneName(), GetCurrentSubZoneName() }
		local tZone = self.currentLootTarget.tZones
		for _,v in ipairs(sZoneNames) do
			if v ~= nil and v ~= "" then
				tZone[v] = tZone[v] or {}
				tZone = tZone[v]
			end
		end
		tUnitLootTable = tZone.tProperties.tLootTable
		tUnitVirtualLootTable = tZone.tProperties.tVirtualLootTable
	end

	-- Static Item
	if tPinataLoot.eLootItemType == 0 then
		local itemLoot = tPinataLoot.itemLoot
		-- local nItemId = itemLoot:GetItemId() -- removed due to new function GetItemFromTable

		local tItem, nItemId = self:GetItemFromTable(itemLoot)
		
		-- add item to tItems table
		--[[local tItem = self.tSavedData.tItems[nItemId] or {
			sItemName = itemLoot:GetName(),
			nItemId = nItemId,
			sItemCategoryName = itemLoot:GetItemCategoryName(),
			sItemFamilyName = itemLoot:GetItemFamilyName(),
			sItemFlavor = itemLoot:GetItemFlavor(),
			eItemQuality = itemLoot:GetItemQuality(),
			sItemTypeName = itemLoot:GetItemTypeName(),
			nRequiredLevel = itemLoot:GetRequiredLevel(),
			tDetailedInfo = itemLoot:GetDetailedInfo(),
			sIcon = itemLoot:GetIcon(),
			tDroppedBy = {},
			tSalvagedFrom = {}
		}
		self.tSavedData.tItems[nItemId] = tItem]]-- removed due to new function GetItemFromTable
		
		-- add item to unit if there is one
		if tUnitLootTable then
			tItem.tDroppedBy[self.currentLootTarget.sName] = 1
			-- get or create unit item
			local tUnitItem = tUnitLootTable[nItemId] or {
				nItemId = nItemId,
				nDropCount = 0,
				nMinDropCount = tPinataLoot.nCount,
				nMaxDropCount = tPinataLoot.nCount,
				nTotalDropCount = 0
			}
			tUnitLootTable[nItemId] = tUnitItem

			-- increment drop by 1, regardless of how many were dropped
			tUnitItem.nDropCount = tUnitItem.nDropCount + 1
			-- get drop min, max, total drop count
			tUnitItem.nMinDropCount = math.min(tUnitItem.nMinDropCount, tPinataLoot.nCount)
			tUnitItem.nMaxDropCount = math.max(tUnitItem.nMaxDropCount, tPinataLoot.nCount)
			tUnitItem.nTotalDropCount = tUnitItem.nTotalDropCount + tPinataLoot.nCount
		end
	-- Cash
	elseif tPinataLoot.eLootItemType == 2 then
		if tUnitLootTable then
			local tCashItem = tUnitLootTable["Cash"] or {
				nDropCount = 0,
				eLootItemType = tPinataLoot.eLootItemType
			}
			tUnitLootTable["Cash"] = tCashItem
			
			local monCurrency = tPinataLoot.monCurrency
			-- increment drop by 1, regardless of how many were dropped
			tCashItem.nDropCount = tCashItem.nDropCount + 1
			tCashItem["nMinMoney"] = math.min(tCashItem["nMinMoney"] or monCurrency:GetAmount(), monCurrency:GetAmount())
			tCashItem["nMaxMoney"] = math.max(tCashItem["nMaxMoney"] or monCurrency:GetAmount(), monCurrency:GetAmount())
			tCashItem["nTotalMoney"] = (tCashItem["nTotalMoney"] or 0) + monCurrency:GetAmount()
		end
	-- Virtual Item
	elseif tPinataLoot.eLootItemType == 6 then
		-- add virtual item to tVirtualItems table
		local sLootName = loot:GetName()
		local tVirtualItem = self.tSavedData.tVirtualItems[sLootName] or {
			sName = sLootName,
			sFlavor = tPinataLoot.tVirtualItem.strFlavor,
			sIcon = tPinataLoot.tVirtualItem.strIcon,
			nCurrentWorldId = GameLib.GetCurrentWorldId(),
			sCurrentZoneName = GetCurrentZoneName(),
			sCurrentSubZoneName = GetCurrentSubZoneName(),
			nCurrentZoneId = GameLib.GetCurrentZoneId(),
			tCurrentZoneMap = GameLib.GetCurrentZoneMap(),
			arPosition = {},
			tDroppedBy = {}
		}
		self.tSavedData.tVirtualItems[sLootName] = tVirtualItem
		
		-- get distance to decide if location is far away enough to consider it a new item location
		if self:IsFarEnough(loot:GetPosition(), tVirtualItem.arPosition, 20) then
			tVirtualItem.arPosition[#tVirtualItem.arPosition + 1] = loot:GetPosition()
		end
		
		-- add item to unit if there is one
		if tUnitVirtualLootTable then
			tVirtualItem.tDroppedBy[self.currentLootTarget.sName] = 1
			-- get or create unit virtual item
			local sName = loot:GetName()
			local tUnitVirtualItem = tUnitVirtualLootTable[sName] or {
				sName = sName,
				nDropCount = 0,
				nMinDropCount = tPinataLoot.tVirtualItem.nCount,
				nMaxDropCount = tPinataLoot.tVirtualItem.nCount,
				nTotalDropCount = 0
			}
			tUnitVirtualLootTable[sName] = tUnitVirtualItem
			
			-- increment drop by 1, regardless of how many were dropped
			tUnitVirtualItem.nDropCount = tUnitVirtualItem.nDropCount + 1
			-- get drop min, max, total drop count
			tUnitVirtualItem.nMinDropCount = math.min(tUnitVirtualItem.nMinDropCount, tPinataLoot.tVirtualItem.nCount)
			tUnitVirtualItem.nMaxDropCount = math.max(tUnitVirtualItem.nMaxDropCount, tPinataLoot.tVirtualItem.nCount)
			tUnitVirtualItem.nTotalDropCount = tUnitVirtualItem.nTotalDropCount + tPinataLoot.tVirtualItem.nCount
		end
	else
		--[[Print("Unknown eLootItemType")
		for k,v in pairs(tPinataLoot) do
			Print(" + " .. tostring(k) .. " = " ..tostring(v))
		end]]--
	end
end

-- retrieve an item entry from table or create one
function LootTable2:GetItemFromTable(item)
	local nItemId = item:GetItemId()
	-- add item to tItems table
	local tItem = self.tSavedData.tItems[nItemId] or {
		sItemName = item:GetName(),
		nItemId = nItemId,
		sItemCategoryName = item:GetItemCategoryName(),
		sItemFamilyName = item:GetItemFamilyName(),
		sItemFlavor = item:GetItemFlavor(),
		eItemQuality = item:GetItemQuality(),
		sItemTypeName = item:GetItemTypeName(),
		nRequiredLevel = item:GetRequiredLevel(),
		tDetailedInfo = item:GetDetailedInfo(),
		sIcon = item:GetIcon(),
		tDroppedBy = {},
		tSalvagedFrom = {}
	}
	self.tSavedData.tItems[nItemId] = tItem

	return tItem, nItemId
end


function LootTable2:AssignItemLoot(item)

end

-- Update/create & return unit in session table
function LootTable2:UpdateUnit(unit)
	-- skip if unit is nil
	if unit == nil then return nil end
	
	local sName = unit:GetName()
	local tUnit = self.tSessionTable.tUnits[sName]
	local tRewardInfo = unit:GetRewardInfo()

	-- if no unit exists, create it
	if not tUnit then
		tUnit = { sName = unit:GetName(), tZones = {} }
		self.tSessionTable.tUnits[sName] = tUnit -- assign to table
	end

	-- go deep into the rabbit hole
	local sZoneNames = { GameLib.GetCurrentZoneMap().strName, GetCurrentZoneName(), GetCurrentSubZoneName() }
	local tZone = tUnit.tZones
	for _,v in ipairs(sZoneNames) do
		if v ~= nil and v ~= "" then
			tZone[v] = tZone[v] or {}
			tZone = tZone[v]
		end
	end
	
	-- check zone properties
	local tProperties = tZone.tProperties
	if tProperties then
		-- update
		local result, err = pcall(function()
			if (tProperties.sType=="NonPlayer") then
				tProperties.nMinLevel = math.min(tProperties.nMinLevel, unit:GetLevel())
				tProperties.nMaxLevel = math.max(tProperties.nMaxLevel, unit:GetLevel())
				tProperties.nMinHealth = math.min(tProperties.nMinHealth, unit:GetMaxHealth())
				tProperties.nMaxHealth = math.max(tProperties.nMaxHealth, unit:GetMaxHealth())
				tProperties.nMinShield = math.min(tProperties.nMinShield, unit:GetShieldCapacityMax())
				tProperties.nMaxShield = math.max(tProperties.nMaxShield, unit:GetShieldCapacityMax())
			end
		end)

		--[[if (err) then
			Print("Error caught: "..err)
		end]]--

		tProperties.nKillCount = tProperties.nKillCount + 1 -- update kill count
		tProperties.tRewardInfo = tProperties.tRewardInfo or unit:GetRewardInfo()
		
		-- get distance to decide if location is far away enough to consider it a new unit location
		if self:IsFarEnough(unit:GetPosition(), tProperties.arPosition, 20) then
			tProperties.arPosition[#tProperties.arPosition + 1] = unit:GetPosition()
		end
	else
		-- set unit's zone properties
		tZone["tProperties"] = {
			sType = unit:GetType(),
			nClassId = unit:GetClassId(),
			bEliteness = (unit:GetEliteness() == 1),
			nId = unit:GetId(),
			nMinLevel = unit:GetLevel(),
			nMaxLevel = unit:GetLevel(),
			nMinHealth = unit:GetMaxHealth(),
			nMaxHealth = unit:GetMaxHealth(),
			nMinShield = unit:GetShieldCapacityMax(),
			nMaxShield = unit:GetShieldCapacityMax(),
			nCurrentWorldId = GameLib.GetCurrentWorldId(),
			sCurrentZoneName = GetCurrentZoneName(),
			sCurrentSubZoneName = GetCurrentSubZoneName(),
			nCurrentZoneId = GameLib.GetCurrentZoneId(),
			tCurrentZoneMap = GameLib.GetCurrentZoneMap(),
			nKillCount = 1,
			arPosition = { unit:GetPosition() },
			tLootTable = {},
			tVirtualLootTable = {},
			tRewardInfo = unit:GetRewardInfo()
		}
	end

	return tUnit
end


-- Return unit's lootable across all sessions
function LootTable2:GetUnitLoot(unit)
	local sName = unit:GetName()
	local tLootTable = { tItems = {}, nKillCount = 0 }
	-- iterate through sessions
	for k,v in pairs(self.tSessionTable) do
		local tUnit = v.tUnits[sName]
		-- found unit in session
		if tUnit then
			tLootTable.nKillCount = tLootTable.nKillCount + tUnit.nKillCount
			for nItemId, tNewLoot in pairs(tUnit.tLootTable) do
				-- consolidate loot data
				local tLoot = tLootTable.tItems[nItemId]
				if tLoot then
					-- cash and non-cash items
					if nItemId ~= "Cash" then
						tLoot.nMinDropCount = math.min(tLoot.nMinDropCount, tNewLoot.nMinDropCount)
						tLoot.nMaxDropCount = math.max(tLoot.nMaxDropCount, tNewLoot.nMaxDropCount)
						tLoot.nDropCount = tLoot.nDropCount + tNewLoot.nDropCount
						tLoot.nTotalDropCount = tLoot.nTotalDropCount + tNewLoot.nTotalDropCount
					else
						tLoot.nMinMoney = math.min(tLoot.nMinMoney, tNewLoot.nMinMoney)
						tLoot.nMaxMoney = math.max(tLoot.nMaxMoney, tNewLoot.nMaxMoney)
						tLoot.nTotalMoney = tLoot.nTotalMoney + tNewLoot.nTotalMoney
						tLoot.nDropCount = tLoot.nDropCount + tNewLoot.nDropCount
					end
				else
					tNewLoot.tItemInfo = self.tSavedData.tItems[nItemId]
					tLootTable.tItems[nItemId] = tNewLoot
				end
			end
		end
	end
	
	return tLootTable
end

-- Get distance between two points in space
function LootTable2:GetDist(a, b)
	local x = b.x - a.x
	local y = b.y - a.y
	local z = b.z - a.z
	return math.sqrt(x*x+y*y+z*z)	
end

-- Check if tNewPos (x,y,z) is at least 'dist' away from all positions in arOldPos
function LootTable2:IsFarEnough(tNewPos, arOldPos, dist)
	local bFarEnough = true
	for i, v in ipairs(arOldPos) do
		if self:GetDist(tNewPos, v) < dist then
			bFarEnough = false
			break
		end
	end
	return bFarEnough
end

---------------------------------------------------------------------------------------------------
-- LootTable2 Event Handlers
---------------------------------------------------------------------------------------------------
-- UnitCreated is used as a trigger for dropped loot
-- param unit <userdata> Item that was created
function LootTable2:OnUnitCreated(unit)
	if unit and unit:IsValid() then
		local sType = unit:GetType()
		-- switch
		if sType == "PinataLoot" then
			self:AssignUnitLoot(unit)
		end
	end
end

-- CombatDamageLog is a good way to monitor kills
function LootTable2:OnCombatLogDamage(tEventArgs)
	-- something has been killed
	if tEventArgs.bTargetKilled then
		local unit = tEventArgs.unitTarget
		if unit and not unit:IsACharacter() then
			-- set loot target and time stamp
			self.currentLootTarget = self:UpdateUnit(unit)
			self.nUnitGameTime=GameLib.GetGameTime()
		end
	end
end

-- Notice looted items too
function LootTable2:OnLootedItem(item, nCount)
	local nItemId = item:GetItemId()
	local sItemName = item:GetName()
	Print("OnLootedItem, "..sItemName..", "..tostring(nItemId));

	-- also inserts item into the table ;)
	local tLootedItem = self:GetItemFromTable(item)

	if self.currentSalvageableTarget then
		local nTimeDiff = nil
		if self.nSalvageableGameTime ~= nil then
			nTimeDiff = GameLib.GetGameTime()-self.nSalvageableGameTime
		end

		-- if time differance is LE 1s and we have a salvageable target
		if nTimeDiff ~= nil and nTimeDiff <= 1 then
			local nItemId = self.currentSalvageableTarget:GetItemId()
			local sItemName = self.currentSalvageableTarget:GetName()

			-- don't forget to reference the item it was salvaged from
			tLootedItem.tSalvagedFrom = tLootedItem.tSalvagedFrom or {} -- not every entry has tSalvagedFrom
			tLootedItem.tSalvagedFrom[nItemId] = sItemName

			-- get salvageable table entry or create one
			self.tSavedData.tSalvageables[nItemId] = self.tSavedData.tSalvageables[nItemId] or {
				nItemId = nItemId,
				sItemName = sItemName,
				nSalavageCount = 0,
				tLootTable = {}
			}
			local tSalvageable = self.tSavedData.tSalvageables[nItemId]

			-- update item
			tSalvageable.nSalavageCount = tSalvageable.nSalavageCount + 1

			-- get loot table entry or create one
			local nSalavagedItemId = item:GetItemId()
			local nSalavagedItemName = item:GetName()
			tSalvageable.tLootTable[nSalavagedItemId] = tSalvageable.tLootTable[nSalavagedItemId] or {
				nItemId = nSalavagedItemId,
				sItemName = nSalavagedItemName,
				nMinDropCount = nCount,
				nMaxDropCount = nCount,
				nTotalDropCount = 0,
				nDropCount = 0
			}
			local tSalvagedItem = tSalvageable.tLootTable[nSalavagedItemId]

			-- increment drop by 1, regardless of how many were dropped
			tSalvagedItem.nDropCount = tSalvagedItem.nDropCount + 1
			-- get drop min, max, total drop count
			tSalvagedItem.nMinDropCount = math.min(tSalvagedItem.nMinDropCount, nCount)
			tSalvagedItem.nMaxDropCount = math.max(tSalvagedItem.nMaxDropCount, nCount)
			tSalvagedItem.nTotalDropCount = tSalvagedItem.nTotalDropCount + nCount
		end
	end
end

function LootTable2:OnItemRemoved(item)
	if item == nil then return end

	if item:CanSalvage() or item:CanAutoSalvage() then
		local nItemId = item:GetItemId()
		local sItemName = item:GetName()
		Print("OnItemRemoved, "..sItemName..", "..tostring(nItemId));
		self.nSalvageableGameTime = GameLib.GetGameTime()
		self.currentSalvageableTarget = item
	end
end

-- save session data
function LootTable2:OnSave(eType)
	if eType ~= GameLib.CodeEnumAddonSaveLevel.General then return end
	self.tSavedData.REVISION = self.tSavedData.REVISION + 1
	return self.tSavedData
end

-- restore session data
function LootTable2:OnRestore(eType, tSavedData)
	-- restore data
	if self.tSavedData then
		self.tSavedData.REVISION = tSavedData.REVISION or self.tSavedData.REVISION
		self.tSavedData.tSessions = tSavedData.tSessions or self.tSavedData.tSessions
		self.tSavedData.tItems = tSavedData.tItems or self.tSavedData.tItems
		self.tSavedData.tVirtualItems = tSavedData.tVirtualItems or self.tSavedData.tVirtualItems
		self.tSavedData.tSalvagables = tSavedData.tSalvagables or self.tSavedData.tSalvagables
	else
		self.tSavedData = tSavedData or self.tSavedData
	end

	-- create new session
	if self.sSessionKey then
		self.tSavedData.tSessions[self.sSessionKey] = self.tSessionTable
	else
		local sSessionKey, tSessionTable = self:CreateSession()
		self.tSavedData.tSessions[sSessionKey] = tSessionTable
		self.sSessionKey = sSessionKey
		self.tSessionTable = tSessionTable
	end
end


local ToolTipInstance = LootTable2:new()
ToolTipInstance:Init()
