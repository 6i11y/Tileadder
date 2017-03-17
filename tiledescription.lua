function SetInfo()

--To add a new tile, you should set some parameters in the table below.
--First [STRING] - name of your tile (in lower case, should match the texture and atlas in levels/tiles/) .
--Second [TABLE] (not necessary) - run/walk/snow/mud sounds and flashpoint_modifier for your tile.
--Third [BOOLEAN] (not necessary, false by default) - enable autogen for turfs if true. You need to add a prefab for the turf called *tilename*_turf (without *, where tilename is the name of your tile in the table).

--For example: tile1 = { "whitetest" } - simplest way, without turf and with default sounds
--You can add several tiles by adding a new row. Like: 
--[[
tile1 = { "bluetest",  {	runsound = "dontstarve/movement/run_tallgrass",	
							walksound = "dontstarve/movement/walk_tallgrass",	
							snowsound = "dontstarve/movement/run_ice",	
							mudsound = "dontstarve/movement/run_mud",	
							flashpoint_modifier = 0 },
							true,				
						},
tile2 = { "redtest", {} }
]]--
--tile1 is called "bluetest" and has assigned sounds and automatically generated turf, tile2 is called "redtest", has default sounds and hasn't a turf.
--
--Textures for the map must be placed in levels/textures/, have a name "noise_*tilename*.tex"(global map) 
--and "mini_noise_*tilename*.tex" (minimap; without *, where *tilename* is the name of your tile in the table).

	local NEW_TILE_DESCRIPTION =
	{
		tile1 = { "exampleblue", 	{}, 	true }, --example tile
		tile2 = { "examplered", 	{}, 	true }, --example tile
		tile3 = { "examplewhite",	{}, 	true },
		tile4 = { "FireOne",	{}, 	true }, --example tile
	}

	return NEW_TILE_DESCRIPTION

end