local array = include("modules/array")
local util = include("client_util")
local mathutil = include( "modules/mathutil" )
local agentdefs = include("sim/unitdefs/agentdefs")
local skilldefs = include( "sim/skilldefs" )
local simdefs = include( "sim/simdefs" )
local serverdefs = include( "modules/serverdefs" )

local function createGeneralMissionObj( txt, txt2 )
	return string.format("> %s\n> %s", txt, txt2 or STRINGS.MISSIONS.ESCAPE.OBJECTIVE)
end

local function createGeneralSecondaryMissionObj()
	return string.format("<c:777777>> %s</>", STRINGS.MISSIONS.ESCAPE.SECONDARY_OBJECTIVE)
end

local ESCAPE_MISSION_TAGS = {}

local SITUATIONS =
{
	holostudio =
	{
        ui = {
			insetImg = "gui/mission_debrief/unknown.png",
			icon = "gui/mission_previews/unknown.png",
			objectives = createGeneralMissionObj( STRINGS.MISSIONS.ESCAPE.OBJ_SECURITY ),
		},
	},
	assassination =
	{
        ui = {
			insetImg = "gui/icons/mission_icons/mission_assassination.png",
			icon = "gui/icons/mission_icons/mission_assassination_small.png",
			objectives = createGeneralMissionObj( STRINGS.MOREMISSIONS.MISSIONS.ASSASSINATION.OBJ_KILL ),
		},
	},
	landfill =
	{
        ui = {
			insetImg = "gui/mission_debrief/unknown.png",
			icon = "gui/mission_previews/unknown.png",
			objectives = createGeneralMissionObj( STRINGS.MISSIONS.ESCAPE.OBJ_NANO_FAB ),
		},
	},
	ea_hostage =
	{
        ui = {
			insetImg = "gui/icons/mission_icons/mission_EA_hostage.png",
			icon = "gui/icons/mission_icons/mission_EA_hostage_small.png",
			objectives = createGeneralMissionObj( STRINGS.MISSIONS.ESCAPE.OBJ_RESCUE_HOSTAGE ),
		},
	},
	weapons_expo =
	{
        ui = {
			insetImg = "gui/menu pages/corp_select/New_mission_icons/10002.png", -- vault case (same as Vault mission, for now)
			icon = "gui/icons/mission_icons/mission_weapons_expo_small.png",
			objectives = createGeneralMissionObj( STRINGS.MOREMISSIONS.UI.WEAPONS_EXPO_OBJECTIVE ),
		},
	},	
	
	distress_call =
	{
        ui = {
			insetImg = "gui/icons/mission_icons/mission_distress_call_v5.png",
			icon = "gui/icons/mission_icons/mission_distress_call_small.png",
			objectives = createGeneralMissionObj( STRINGS.MOREMISSIONS.UI.DISTRESS_OBJECTIVE ),
			secondary_objectives = createGeneralSecondaryMissionObj(STRINGS.MOREMISSIONS.UI.DISTRESS_OBJECTIVE_SECONDARY),
		},
	},		

	level_test =
	{
		levelFile = "lvl_safehouse_test",
        ui = {
			insetImg = "gui/icons/mission_icons/mission_distress_call_v5.png",
			icon = "gui/icons/mission_icons/mission_distress_call_small.png",
			objectives = createGeneralMissionObj( STRINGS.MOREMISSIONS.UI.DISTRESS_OBJECTIVE ),
			secondary_objectives = createGeneralSecondaryMissionObj(STRINGS.MOREMISSIONS.UI.DISTRESS_OBJECTIVE_SECONDARY),
		},
		scripts = { "safehouse_script" },
	},		
}

--automated processing
for k, v in pairs(SITUATIONS) do
	--assume mission ID as tag for mission picker
	if not v.tags then
		table.insert(ESCAPE_MISSION_TAGS, k)
		v.tags = {k}
	end
	--scripts
	-- v.scripts = v.scripts or { "mission_".. k }
	v.scripts = v.scripts or {k}
	v.levelFile = v.levelFile or "lvl_procgen"
	--strings
	local location_str = STRINGS.MOREMISSIONS.LOCATIONS[string.upper(k)]
	v.ui.moreInfo = v.ui.moreInfo or location_str.MORE_INFO
	v.ui.insetTitle = v.ui.insetTitle or location_str.INSET_TITLE
	v.ui.insetTxt = v.ui.insetTxt or location_str.INSET_TXT
	v.ui.locationName = v.ui.locationName or location_str.NAME
	v.ui.playerdescription = v.ui.playerdescription or location_str.DESCRIPTION
	v.ui.reward = v.ui.reward or location_str.REWARD
	v.ui.insetVoice = v.ui.insetVoice or location_str.INSET_VO
	v.ui.secondary_objectives = v.ui.secondary_objectives or serverdefs.createGeneralSecondaryMissionObj()
	v.ui.tip = v.ui.tip or location_str.LOADING_TIP
	v.strings = v.strings or STRINGS.MISSIONS.ESCAPE --unused, except for the MISSION_TITLE on the scoring screen
end


local BLOB_NEPTUNE = {
	{
		size = 2,
		anims = { 'c5','b5', },
	},
	{
		size = 3,
		anims = { 'c5','b5',},
	},
	{
		size = 4,
		anims = { 'c5','b5' },
	},
	{
		size = 5,
		anims = { 'c5','b5' },
	},
}


	
local MAP_LOCATIONS = {
	--[[{ x=122, y=568, name="Antarctic Base", corpName="neptune" },
	{ x=297, y=569, name="Antarctic Base", corpName="neptune" },
	{ x=502, y=585, name="Antarctic Base", corpName="neptune" },
	{ x=634, y=547, name="Antarctic Base", corpName="neptune" },
	{ x=850, y=578, name="Antarctic Base", corpName="neptune" },
	{ x=1083, y=553, name="Antarctic Base", corpName="neptune" },]]
	{ x=378, y=495, name="Antarctic Base", corpName="agency" },
	{ x=615, y=521, name="Antarctic Base", corpName="agency" },
	{ x=824, y=512, name="Antarctic Base", corpName="agency" },
	{ x=956, y=500, name="Antarctic Base", corpName="agency" },
	{ x=1090, y=522, name="Antarctic Base", corpName="agency" },
	
	{ x=118, y=472, name="Aquatic Base", corpName="agency" },
	{ x=238, y=507, name="Aquatic Base", corpName="agency" },
	{ x=530, y=440, name="Aquatic Base", corpName="agency" },
	{ x=825, y=383, name="Aquatic Base", corpName="agency" },
	{ x=1159, y=442, name="Aquatic Base", corpName="agency" },
}

for i, location in ipairs(MAP_LOCATIONS) do
	location.x  = location.x + 86 - 592
	location.y = 305 - 16 - location.y - 139
	table.insert(serverdefs.MAP_LOCATIONS,location)
end


serverdefs.CORP_DATA.agency = 
{
	stringTable = STRINGS.CORP.FTM, --STRINGS.CORP.NEPTUNE,
	shortname = "AGENCY", -- Not a UI string, used for debug and path concatenation purposes.
	logo = "gui/corp_preview/logo_sankaku.png",
	
	imgs = {shop="gui/store/STORE_FTM_bg.png",logo="gui/menu pages/corp_select/CP_FTMLogo1.png",logoLarge = "gui/corps/logo_FTM.png"},
	music = "SpySociety/Music/music_Sankaku",
	region = "agency",
	world = "agency",
	overlayBlobStyles = BLOB_NEPTUNE,--What does it do?
}



	
return {
	SITUATIONS = SITUATIONS,
	ESCAPE_MISSION_TAGS = ESCAPE_MISSION_TAGS,
}
