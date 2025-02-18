include("scripts/line_restrictions.lua")

blueprint_library = {
    {
        file_name = "tutorial",
        name = "introduction",
        sell_target = 10,
        power_target = 4,
        popups = {
            {
                x = 330,
                y = 150,
                width = 130,
                content =
                "Once your solution meets the level goals, the button below will turn green. You can click it any time to go back."
            },
            {
                x = 116,
                y = 170,
                width = 300,
                title = "The status bar",
                content =
                "Below you can see the current status for your solution. Your placed tiles' combined cost have to total below the current BUDGET goal, and you have to generate enough POWER to meet the current quota."
            },
            {
                x = 94,
                y = 64,
                title = "The Tiles",
                content =
                "To the left you can find the different tiles you can place. You can place as many as you want, but they each have a cost. Once you select a tile, you LEFT CLICK to place, and RIGHT CLICK, SCROLL or press R to rotate."
            },
            {
                x = 100,
                y = 52,
                width = 100,
                title = "The Toolbar",
                content =
                "Above you can select between the INFO, PLACE, ERASE tools, and the fourth button lets you rotate your currently held tile. They are also assigned to QWER."
            },

            {
                x = 330,
                y = 100,
                width = 100,
                title = "The Canvas",
                content =
                "This is where you place tiles. The gray spaces are already occupied"
            },
            {
                x = 220,
                y = 20,
                title = "Welcome to POWERTILE",
                content =
                "In this game you will place tiles of various shapes on the board. Some generate POWER, while others might have other abilities. (Click a popup to continue)"
            },

        }
    },
    {
        file_name = "test2",
        name = "nano",
        sell_target = 15,
        power_target = 7,
        -- restrictions = {
        -- 	createLineRestriction("col", 2, line_restrictions_lib.exact_power, 1),
        -- 	createLineRestriction("col", 3, line_restrictions_lib.forbidden_type, 1),
        -- }
    },
    {
        file_name = "test",
        name = "plugin",
        sell_target = 14,
        power_target = 8
    },
    {
        file_name = "test3",
        name = "two legs",
        sell_target = 12,
        power_target = 8
    },
    {
        file_name = "wed12F",
        name = "restricted",
        sell_target = 14,
        power_target = 14,
        restrictions = {
            createLineRestriction("row", 4, line_restrictions_lib.exact_power, 1),
            createLineRestriction("col", 6, line_restrictions_lib.exact_power, 3)
        },
        popups = { {
            title = "More tiles...",
            content = "If you have unlocked more tile types than can fit in the box, you can find them on the next page, use the +/- buttons to navigate, or use 123 on your keyboard."
        }, {
            title = "Restrictions",
            content = "Some levels have restrictions! Use the info tool to inspect each restriction."
        } }
    },
    {
        file_name = "mega",
        name = "mega",
        sell_target = 8,
        power_target = 10
    },
    {
        file_name = "wed12A",
        name = "gravel",
        sell_target = 11,
        power_target = 12
    },
    {
        file_name = "butterfly",
        name = "butterfly",
        sell_target = 20,
        power_target = 20,
        restrictions = {
            createLineRestriction("col", 4, line_restrictions_lib.exact_power, 2),
            createLineRestriction("col", 12, line_restrictions_lib.exact_power, 4),
        },
    },
    {
        file_name = "open",
        name = "open space",
        sell_target = 17,
        power_target = 15,
        restrictions = {
            createLineRestriction("row", 3, line_restrictions_lib.exact_power, 0),
            createLineRestriction("row", 6, line_restrictions_lib.exact_power, 0),
            createLineRestriction("row", 8, line_restrictions_lib.exact_power, 1),
        },
    },
    {
        file_name = "wed12B",
        name = "landsquid",
        sell_target = 20,
        power_target = 12
    },
    --[[ 	{
		file_name = "spiral",
		name = "spiral",
		sell_target = 20,
		power_target = 15
	}, ]]



    {
        file_name = "wed12C",
        name = "offshore",
        sell_target = 14,
        power_target = 23,
        restrictions = {
            createLineRestriction("col", 8, line_restrictions_lib.exact_power, 1),
            createLineRestriction("col", 10, line_restrictions_lib.exact_power, 2),
            createLineRestriction("col", 12, line_restrictions_lib.exact_power, 3),
        },
    },
    {
        file_name = "wed12D",
        name = "symbol",
        sell_target = 20,
        power_target = 15
    },

    {
        file_name = "columns",
        name = "columns",
        sell_target = 30,
        power_target = 20,
        restrictions = {
            createLineRestriction("row", 5, line_restrictions_lib.exact_power, 0),
            createLineRestriction("row", 6, line_restrictions_lib.exact_power, 0),
        },
    },
    {
        file_name = "wed12E",
        name = "kite",
        sell_target = 10,
        power_target = 15,
        restrictions = {
            createLineRestriction("col", 3, line_restrictions_lib.exact_power, 5),
            createLineRestriction("col", 8, line_restrictions_lib.exact_power, 0),
            createLineRestriction("row", 8, line_restrictions_lib.exact_power, 3),
        },
    },
    {
        file_name = "wed12G",
        name = "canister",
        sell_target = 20,
        power_target = 15,
        restrictions = {
            createLineRestriction("col", 4, line_restrictions_lib.exact_power, 0),
            createLineRestriction("col", 5, line_restrictions_lib.exact_power, 9),
        },
    },
    {
        file_name = "circle",
        name = "iris",
        sell_target = 20,
        power_target = 25,
        restrictions = {
            createLineRestriction("row", 6, line_restrictions_lib.exact_power, 6),
            createLineRestriction("col", 7, line_restrictions_lib.exact_power, 4),
        },
    },

}
