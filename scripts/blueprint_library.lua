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
		sell_target = 15,
		power_target = 13
	},
	{
		file_name = "mega",
		name = "mega",
		sell_target = 10,
		power_target = 15
	},
	{
		file_name = "open",
		name = "open space",
		sell_target = 20,
		power_target = 15
	}

}
