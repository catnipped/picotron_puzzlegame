function initLevelSelect()
	buttons = {}
	window { cursor = 1 }

	welcome_message =
		"Hi! Click a level twice to start it. \n\nUse QWER and 12345 to change tools,\nLEFT MOUSE to place and RIGHT MOUSE to rotate. \nThe goal is to reach a certain POWER (" ..
		string_color.yellow ..
		string_icon.power ..
		string_color.green ..
		") while \nstaying under BUDGET ($). \nSee if you can get some COMPUTE (" ..
		string_color.blue .. string_icon.compute .. string_color.green .. ") as well...\n"

	-- list of blueprint select buttons

	for i = 1, #blueprint_library do
		local level_button = createButton(i * 64, 128, 42, 42)
		level_button.draw = function(self)
			drawBlueprintFile(self.x, self.y, i, self.hover, self.selected)
		end
		level_button.onClick = function(self)
			if self.selected then
				current_screen = "workbench"
				initWorkbench(i)
			end
		end

		add(buttons, level_button)
	end
end
