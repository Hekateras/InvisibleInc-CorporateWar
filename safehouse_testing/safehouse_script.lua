local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include( "sim/simdefs" )
local simquery = include( "sim/simquery" )
local mission_util = include( "sim/missions/mission_util" )
local escape_mission = include( "sim/missions/escape_mission" )
local unitdefs = include( "sim/unitdefs" )
local simfactory = include( "sim/simfactory" )
local itemdefs = include( "sim/unitdefs/itemdefs" )
local serverdefs = include( "modules/serverdefs" )
local cdefs = include( "client_defs" )

local SCRIPTS = include('client/story_scripts')



local mission = class( escape_mission )

function mission:init( scriptMgr, sim )

    escape_mission.init( self, scriptMgr, sim )
	
	for i, unit in pairs(sim:getPC():getUnits()) do
		if not unit:getTraits().isDrone then
			unit:getTraits().walk = true
			unit:getTraits().hidesInCover = false
		end
	end
 	
		
end


function mission.pregeneratePrefabs( cxt, tagSet )

    escape_mission.pregeneratePrefabs( cxt, tagSet )

end

function mission.generatePrefabs( cxt, candidates )
    local prefabs = include( "sim/prefabs" )   
	escape_mission.generatePrefabs( cxt, candidates )
end

return mission
