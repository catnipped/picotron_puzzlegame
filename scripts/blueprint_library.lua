include("scripts/line_restrictions.lua")

blueprint_library = {
	{
		file_name = "tutorial",
		name = "introduction",
		sell_target = 10,
		power_target = 4
	},
	{
		file_name = "test2",
		name = "blueprint 1",
		sell_target = 15,
		power_target = 7,
		-- restrictions = {
		-- 	createLineRestriction("col", 2, line_restrictions_lib.exact_power, 1),
		-- 	createLineRestriction("col", 3, line_restrictions_lib.forbidden_type, 1),
		-- }
	},
	{
		file_name = "test",
		name = "blueprint 2",
		sell_target = 14,
		power_target = 8
	},
	{
		file_name = "test3",
		name = "two legs",
		sell_target = 13,
		power_target = 10
	},
	{
		file_name = "mega",
		name = "mega",
		sell_target = 10,
		power_target = 13
	},
	{
		file_name = "open",
		name = "open space",
		sell_target = 20,
		power_target = 15
	},
--[[ 	{
		file_name = "spiral",
		name = "spiral",
		sell_target = 20,
		power_target = 15
	}, ]]
	{
		file_name = "butterfly",
		name = "butterfly",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "circle",
		name = "circle",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "columns",
		name = "columns",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12A",
		name = "wed12A",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12B",
		name = "wed12B",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12C",
		name = "wed12C",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12D",
		name = "wed12D",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12E",
		name = "wed12E",
		sell_target = 20,
		power_target = 15
	},
	{
		file_name = "wed12F",
		name = "wed12F",
		sell_target = 20,
		power_target = 15,
		restrictions = {
			createLineRestriction("row", 4, line_restrictions_lib.exact_power, 1),
			createLineRestriction("col", 6, line_restrictions_lib.exact_power, 3)
		}
	},
	{
		file_name = "wed12G",
		name = "wed12G",
		sell_target = 20,
		power_target = 15
	},

}
