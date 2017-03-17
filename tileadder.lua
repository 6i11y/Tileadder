--Reqs---------------------------
local _G = GLOBAL
local require = GLOBAL.require
local Asset = _G.Asset
local error = _G.error
local unpack = _G.unpack
local GROUND = _G.GROUND
local GROUND_NAMES = _G.GROUND_NAMES
local resolvefilepath = _G.resolvefilepath
local softresolvefilepath = _G.softresolvefilepath

require 'map/terrain'
local tiledefs = require 'worldtiledefs'

modimport 'tiledescription.lua'

local new_tile_description = SetInfo() --Loading data from tiledescription.lua
local min_start_id = 50 --Setted to avoid conflict with the standard tiles

if generated_grounds_num_id ~= nil then
	print ("ho-ho generated_grounds_num_id was called")
	local generated_grounds_num_id
end

--Defaults-----------------------------------

local tile_spec_defaults = {
	noise_texture = "images/square.tex",
	runsound = "dontstarve/movement/run_dirt",
	walksound = "dontstarve/movement/walk_dirt",
	snowsound = "dontstarve/movement/run_ice",
	mudsound = "dontstarve/movement/run_mud",
	flashpoint_modifier = 0,
}

--Logic. It works, I think. It is not necessary to change anything
-----------------------------------------

local function ValidateId(num_id)
	if num_id >= GROUND.UNDERGROUND then
		return error(("Numerical id %d is to hight"):format(num_id, GROUND.UNDERGROUND), 3)
	end
	for k, v in pairs(GROUND) do
		if v == num_id then
			return error(("The numerical id %d is already used by GROUND.%s!"):format(v, tostring(k)), 3)
		end
	end
end

local function GroundTextures( name )		return "levels/textures/noise_" .. name .. ".tex"			end
local function MiniGroundTextures( name )	return "levels/textures/mini_noise_" .. name .. ".tex" 		end
local function GroundImage( name )			return "levels/tiles/" .. name .. ".tex"					end
local function GroundAtlas( name )			return "levels/tiles/" .. name .. ".xml"					end
local function FirstToUpper( str )	    	return ( str:gsub("^%l", string.upper) )					end

local function AddTile(name, mapspecs)

	_G.assert( _G.type(name) == "string" )

	local num_id = min_start_id --calculate an unique numerical id for the tile
	for val, val2 in pairs (tiledefs.ground) do
		if val2[1] ~= nil and val2[1] >= num_id then
			num_id = val2[1] + 1 
		end
	end

	mapspecs = mapspecs or {}
	mapspecs.noise_texture = GroundTextures(name)
	ValidateId(num_id) --checking for id duplicates
	
	table.insert ( generated_grounds_num_id,  num_id  )
	print ("ho-ho-ho start")
	for i = 1, #generated_grounds_num_id do
		print ("ho-ho-ho", generated_grounds_num_id[i])
	end
	
	GROUND[string.upper(name)] = num_id
	GROUND_NAMES[num_id] = name
	
	local real_mapspecs = { name = name }
	
	for k, default in pairs(tile_spec_defaults) do --adding defaults, if not setted
		if mapspecs[k] == nil then
			real_mapspecs[k] = default
		else
			real_mapspecs[k] = mapspecs[k]
		end
	end

	table.insert( tiledefs.ground, { num_id, real_mapspecs } )
	table.insert( tiledefs.assets, Asset( "IMAGE", 	real_mapspecs.noise_texture ) )
	table.insert( tiledefs.assets, Asset( "IMAGE", 	GroundImage( real_mapspecs.name ) ) )
	table.insert( tiledefs.assets, Asset( "FILE", 	GroundAtlas( real_mapspecs.name ) ) )

	return nil

end

function CallAddTile()
	generated_grounds_num_id = {}
	for _, cont in pairs (new_tile_description) do
		AddTile ( cont[1], cont[2], cont[4] )
	end
end

function AddMinimapAndTurf()

	print ("ho-ho-ho start")
	for i = 1, #generated_grounds_num_id do
		print ("ho-ho-ho", generated_grounds_num_id[i])
	end

	local tile_adder_turf_info = {}
	local minimap_ground_properties = {}
	local curr_max_id = min_start_id
	local num_of_new_tiles = 0

	for val, val2 in pairs (tiledefs.ground) do --calculate id for the added tile
		if val2[1] ~= nil and val2[1] >= curr_max_id then
			curr_max_id = val2[1] + 1 
		end
	end

	for val, _ in pairs(new_tile_description) do
		num_of_new_tiles = num_of_new_tiles + 1
	end

	curr_max_id = curr_max_id - num_of_new_tiles --still calculating...

	for _, cont in pairs(new_tile_description) do
			table.insert( Assets, Asset( "IMAGE", GroundTextures (cont[1])))
			table.insert( Assets, Asset( "IMAGE", MiniGroundTextures (cont[1])))
			table.insert( Assets, Asset( "IMAGE", GroundImage (cont[1])))
			table.insert( Assets, Asset( "FILE", GroundImage (cont[1])))
			table.insert( minimap_ground_properties, { curr_max_id, {name = "map_edge",  noise_texture = MiniGroundTextures(cont[1])}} )
			
			-- if cont[4] ~= nil then
				-- table.insert( minimap_ground_properties, { cont[4], {name = "map_edge",  noise_texture = MiniGroundTextures(cont[1])}} )
			-- else 
				-- table.insert( minimap_ground_properties, { curr_max_id, {name = "map_edge",  noise_texture = MiniGroundTextures(cont[1])}} )
			-- end
			
			if cont[3] then --to turf or not to turf?
				table.insert( PrefabFiles,  cont[1] .. "_turf") --set turf prefab
				tile_adder_turf_info[curr_max_id] = cont[1] .. "_turf" --add info for terraform
				
				--if cont[4] ~= nil then
					-- tile_adder_turf_info[cont[4]] = cont[1] .. "_turf"
				-- else	
					-- tile_adder_turf_info[curr_max_id] = cont[1] .. "_turf" --add info for terraform
				-- end
				
				GLOBAL.STRINGS.NAMES[string.upper(cont[1]) .. "_TURF"] = FirstToUpper(cont[1]) .. " Turf" --set an inventory name for the turf
			end
			curr_max_id = curr_max_id + 1
	end

	local curr_max_id = 0

	--Adding layers info for the minimap. The tile will work without it, but the minimap will have an empty spaces.

	AddPrefabPostInit("minimap", function(inst)
		for _, data in pairs( minimap_ground_properties ) do
			local tile_type, layer_properties = unpack( data )
			local handle = _G.MapLayerManager:CreateRenderLayer(
				tile_type,
				resolvefilepath(GroundAtlas( layer_properties.name )),
				resolvefilepath(GroundImage( layer_properties.name )),
				resolvefilepath(layer_properties.noise_texture)
			)
			inst.MiniMap:AddRenderLayer( handle )
		end
	end)
	
	AddComponentPostInit("terraformer", function(self) --overload terraformer component
	
		local function SpawnTurf(turf, pt)
			if turf ~= nil then
				local loot = GLOBAL.SpawnPrefab(turf)
				loot.Transform:SetPosition(pt:Get())
				if loot.Physics ~= nil then
					local angle = math.random() * 2 * GLOBAL.PI
					loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
				end
			end
		end
		
		local _Terraform = self.Terraform	
		self.Terraform = function(self, pt)
			
			local world = GLOBAL.TheWorld
			local map = world.Map

			if not map:CanTerraformAtPoint(pt:Get()) then
				return false
			end

			local original_tile_type = map:GetTileAtPoint(pt:Get())
			local x, y = map:GetTileCoordsAtPoint(pt:Get())

			map:SetTile(x, y, GROUND.DIRT)
			map:RebuildLayer(original_tile_type, x, y)
			map:RebuildLayer(GROUND.DIRT, x, y)

			local minimap = world.minimap.MiniMap
			minimap:RebuildLayer(original_tile_type, x, y)
			minimap:RebuildLayer(GROUND.DIRT, x, y)

			local overloaded = _Terraform(self, pt)
			if  overloaded == true then			
				local turf_prefab = tile_adder_turf_info[original_tile_type] 
				if turf_prefab == nil then
					turf_prefab = GROUND_TURFS[original_tile_type]
					if turf_prefab ~= nil then
						SpawnTurf(turf_prefab, pt) 
					end
				end
				return true
			end
			return false
		end
	end)
end