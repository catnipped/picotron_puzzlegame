function initLevelSelect()
	buttons = {}
	popups = {}
	level_buttons = {}
	window { cursor = 1 }

	welcome_message =
		"Hi! Click a level twice to \nstart it. \n\nUse QWER and 12345 to change \ntools, LEFT MOUSE to place and \nRIGHT MOUSE to rotate. \nThe goal is to reach a certain \nPOWER (" ..
		string_color.yellow ..
		string_icon.power ..
		string_color.green ..
		") while staying under \nBUDGET ($). \nSee if you can get some \nCOMPUTE (" ..
		string_color.blue .. string_icon.compute .. string_color.green .. ") as well...\n"

	-- list of blueprint select buttons
	local level_select_width = 4
	for i = 1, #blueprint_library do
		local y_offset = (flr((i - 1) / level_select_width) * 64)
		local x_offset = ((i - 1) % level_select_width) * 64
		local level_button = createButton(216 + x_offset, 16 + y_offset, 42, 42)
		level_button.draw = function(self)
			drawBlueprintFile(self.x, self.y + self.y_offset, i, self.hover, self.selected)
		end
		level_button.onClick = function(self)
			if self.selected and progression.blueprints[i].unlocked then
				current_screen = "workbench"
				initWorkbench(i)
			end
		end

		add(level_buttons, level_button)
	end

	--pagination
	level_page = 0
	local page_count = flr(#blueprint_library / (level_select_width * 4))
	local page_up = createButton(16, 216, 16, 16)
	page_up.draw = function(self)
		drawPillButton(self.x, self.y, self.width, self.hover, self.clicked, "<")
	end
	page_up.onClick = function(self)
		level_page -= 1
		level_page = mid(0, level_page, page_count)
	end
	add(buttons, page_up)

	local page_down = createButton(36, 216, 16, 16)
	page_down.draw = function(self)
		drawPillButton(self.x, self.y, self.width, self.hover, self.clicked, ">")
	end
	page_down.onClick = function(self)
		level_page += 1
		level_page = mid(0, level_page, page_count)
	end
	add(buttons, page_down)

	checkComponentUnlock()
end

function checkComponentUnlock()
	if progression.components_unlocks < flr(progression.cleared_amount / 1)
		and progression.components_starting_unlocks + progression.components_unlocks < #component_types
	then
		progression.components_unlocks += 1

		--make a popup!
		local unlock_pop = createButton(64, 32, 200, 150)
		local component_nr = progression.components_starting_unlocks + progression.components_unlocks
		unlock_pop.draw = function(self)
			drawWindowMetal(self.x, self.y, self.width, self.height)
			print("You unlocked a new component!", self.x + 8, self.y + 8, 11)
			drawComponentInfo(component_types[component_nr], self.x + 80, self.y + 24)
			spr(component_types[component_nr].sprite, self.x + 8, self.y + 24)
		end
		unlock_pop.onClick = function(self)
			del(popups, self)
		end

		add(popups, unlock_pop)
	end
end
