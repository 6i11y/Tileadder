local require = GLOBAL.require
require("map/lockandkey")
require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")
local blockersets = require("map/blockersets")
local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS
local GROUND = GLOBAL.GROUND

------------------------------------------------
--Start of Tile Adder. Copy this code to your modworldgenmain.lua for use.
--The following will create new tile type: GROUND.EXAMPLETILE. 
--See tiledescription.lua and tileadder.lua for more details.
modimport 'tileadder.lua'
CallAddTile()
--End if Tile Adder.
---------------------------------------------------

--Creating Test Zone
AddTask("TA_Example_Task",	{
					locks = {LOCKS.NONE},
					keys_given = {KEYS.NONE},
					room_choices =
						{
							["ExampleBlue_Area"] = 1,
							["ExampleRed_Area"] = 1,
							["ExampleWhite_Area"] = 1,
							["FireOne_Area"] = 2,
						},
					room_bg = GROUND.EXAMPLETILE,
					background_room = "ExampleBlue_Area",
					colour = {r=1,g=0,b=0.6,a=1},
				}
	)

AddRoom("ExampleBlue_Area",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.EXAMPLEBLUE,
			contents =	{
				distributepercent = 0.1,
					distributeprefabs =
						{
							bishop = 0.01,
							knight = 0.01,
							marbletree_4 = 0.1,
							statueharp = 0.05,
							flower_evil = 0.05,
							blue_mushroom = 0.03,
						}
					}
				}
	)

AddRoom("ExampleRed_Area",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.EXAMPLERED,
			contents =	{
				distributepercent = 0.1,
					distributeprefabs =
						{
							bishop_nightmare = 0.01,
							knight_nightmare = 0.01,
							marbletree_2 = 0.1,
							marbletree_1 = 0.1,
							flower_evil = 0.05,
							red_mushroom = 0.03
						}
					}
				}
	)
	
AddRoom("ExampleWhite_Area",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.EXAMPLEWHITE,
			contents =	{
				distributepercent = 0.1,
					distributeprefabs =
						{
							rook = 0.001,
							marbletree_3 = 0.03,
							marblepillar = 0.1,
							flower_evil = 0.05,
							green_mushroom = 0.03
						}
					}
				}
	)
	
	AddRoom("FireOne_Area",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.FIREONE,
			contents =	{
				distributepercent = 0.1,
					distributeprefabs =
						{
							lava_pond = 0.03,
							Charcoal = 0.1,
							Rocks = 0.05,
							evergreen_burnt = 0.09,
						      twiggy_burnt  = 0.09
						
						}
					}
				}
	)
local LEVELTYPE = GLOBAL.LEVELTYPE

local function AddTaskTest(level)
	table.insert(level.tasks, "TA_Example_Task")
end

AddLevelPreInit("SURVIVAL_TOGETHER", AddTaskTest)
AddLevelPreInit("SURVIVAL_TOGETHER_CLASSIC", AddTaskTest)
AddLevelPreInit("SURVIVAL_DEFAULT_PLUS", AddTaskTest)
AddLevelPreInit("COMPLETE_DARKNESS", AddTaskTest)
--AddLevelPreInit("SURVIVAL_CAVEPREVIEW", AddTaskTest)