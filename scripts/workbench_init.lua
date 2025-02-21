--[[pod_format="raw",created="2024-05-12 07:41:09",modified="2024-12-17 11:41:37",revision=77]]
function initWorkbench(level_number)
	--load the data for the level (blueprint)
	current_level = level_number
	blueprint = blueprint_library[level_number]
	blueprint.ready = false
	blueprint.canvas = setupBlueprint(blueprint.file_name)
	initLineRestrictions(blueprint.restrictions, blueprint.canvas.bitmap[2].bmp)

	-- set up workbench (current solution)
	printh("loading... " .. "/appdata/powertile/blueprint_solutions/" .. blueprint.file_name .. ".pod")
	workbench = fetch("/appdata/powertile/blueprint_solutions/" .. blueprint.file_name .. ".pod")
	if workbench != nil then
		for i in all(workbench.placed_components) do -- add back ability functions
			if component_types[i.type].ability_instance then
				i.ability_instance = component_types[i.type].ability_instance
			end
			if component_types[i.type].ability_global then
				i.ability_global = component_types[i.type].ability_global
			end
		end
	elseif workbench == nil then
		printh("initiating workbench from scratch")
		workbench = {}
		workbench.canvas = initCanvas()
		--table that holds all globals
		workbench.global_abilities = {}

		--placed components is a list of every saved component and their position
		workbench.placed_components = {}
		workbench.placed_component_amount = countComponents(workbench.placed_components)
		--stats
		workbench.cost_of_components = 0
		workbench.costs_modifiers = {}
		workbench.power_generated = 0
		workbench.power_generated_modifiers = {}
		workbench.ichor_generated = 0
		workbench.ichor_generated_modifiers = {}
		workbench.power_target = blueprint.power_target
		workbench.power_target_modifiers = {}
		workbench.sell_target = blueprint.sell_target
		workbench.sell_target_modifiers = {}
		workbench.restrictions = false
		workbench.used_spaces_count = 0
		if blueprint.popups then
			printh("adding popups")
			printh(#blueprint.popups)
			for p in all(blueprint.popups) do
				local title = p.title or nil
				local x = p.x or nil
				local y = p.y or nil
				local width = p.width or nil
				addTutorialPopup(p.content, title, x, y, width)
			end
		end
		--instances a component from the library and gives it an id
		workbench.held_component = tablecopy(component_types[1])
		workbench.held_component_id = 2 --starts on 2, because 1 is reserved for marked empty
	end
	--these two are used to evaluate and visualise if a component can be placed
	proposed_placement = nil
	can_place = false

	mouse_mode = { false, false, false, false } -- info, place, empty, erase
	mouseMode(1)

	--show component values on canvas flag
	show_values = false

	buttons = {}
	initGoBackButton()
	initToolboxButtons(103, 23)
	component_buttons = {
		buttons = {},
		page = 1,
		page_max = 1
	}
	initComponentBoxButtons(12, 12)
	evaluationUpdate()
	evaluationUpdate()
end

function initGoBackButton()
	local goBack_button = createButton(480 - 54, 216, 36, 16)
	goBack_button.draw = function(self)
		local color = 2
		if workbench.ready then color = 11 end
		if self.hover then color = 7 end
		drawPillButton(self.x, self.y, self.width, self.hover, self.clicked)

		if not workbench.ready then
			if self.hover then
				pal(11, 8)
				pal(38, 0)
			else
				pal(11, 51)
				pal(38, 0)
			end
			spr(86, self.x + 2, self.y + 2)
			pal(38, 38)
			pal(11, 11)
		else
			if not self.hover then
				if every(120, 0, 30) then
					pal(11, 38)
					pal(38, 00)
				end
			end
			spr(86, self.x + 2, self.y + 2)
			pal(38, 38)
			pal(11, 11)
		end
	end
	goBack_button.onClick = function(self)
		if workbench.ready then
			progression.blueprints[current_level].clear = true
			if workbench.ichor_generated > 0 then
				progression.blueprints[current_level].clear_with_blue = true
			end
			progression.blueprints[current_level].power_generated = workbench.power_generated
			progression.blueprints[current_level].ichor_generated = workbench.ichor_generated
			progression.blueprints[current_level].cost_of_components = workbench.cost_of_components
		end
		--saving
		printh("saving...")
		saveProgression()

		store("/appdata/powertile/blueprint_solutions/" .. blueprint.file_name .. ".pod", workbench)

		--switch screens
		current_screen = "level select"
		initLevelSelect()
	end
	add(buttons, goBack_button)
end

function initToolboxButtons(x, y)
	local info_button = createButton(x, y, 16, 16)
	info_button.draw = function(self)
		local selected = false
		if mouse_mode[1] or self.hover then
			selected = true
		end
		drawToolButton(self.x, self.y - 1, 115, selected, 124)
	end

	info_button.onClick = function(self)
		mouseMode(1)
	end

	add(buttons, info_button)

	local place_button = createButton(x + 19, y, 16, 16)
	place_button.draw = function(self)
		local selected = false
		if mouse_mode[2] or self.hover then
			selected = true
		end
		drawToolButton(self.x, self.y - 1, 118, selected, 125)
	end

	place_button.onClick = function(self)
		mouseMode(2)
	end
	add(buttons, place_button)

	local erase_button = createButton(x + 38, y, 16, 16)
	erase_button.draw = function(self)
		local selected = false
		if mouse_mode[4] or self.hover then
			selected = true
		end
		drawToolButton(self.x, self.y - 1, 116, selected, 126)
	end

	erase_button.onClick = function(self)
		mouseMode(4)
	end
	add(buttons, erase_button)

	local rotate_button = createButton(x + 57, y, 16, 16)
	rotate_button.draw = function(self)
		local selected = false
		if self.hover then
			selected = true
		end
		drawToolButton(self.x, self.y - 1, 119, selected, 127)
	end

	rotate_button.onClick = function(self)
		rotateComponent(workbench.held_component)
	end
	add(buttons, rotate_button)
end

function initComponentBoxButtons(x, y)
	local y_offset = 0
	local page_count = 1
	local unlocks = min(#component_types, (progression.components_starting_unlocks + progression.components_unlocks))
	for i = 1, unlocks do
		local component_button = createButton(x, y + 10 + y_offset, 73, component_types[i].height * grid_size)
		component_button.draw = function(self)
			if self.visible then
				if self.hover then
					rectfill(self.x, self.y - 1, self.x + self.width, self.y + self.height, 39)
				end
				drawComponentInBox(i, self.x, self.y, self.width)
			end
		end
		component_button.onClick = function(self)
			workbench.held_component = tablecopy(component_types[i])
			mouseMode(2)
		end
		component_button.onHover = function(self)
			tooltip = component_types[i]
		end

		-- offsets button dynamically, if it doesn't fit, put on next page (and up the page count)
		y_offset += 16 + component_types[i].height * grid_size
		if y_offset > 250 then
			component_button.y = y + 10
			y_offset = 16 + component_types[i].height * grid_size
			page_count += 1
		end

		component_button.page = page_count
		if page_count > 1 then component_button.visible = false end -- hide if not on first page
		add(component_buttons.buttons, component_button)
	end
	component_buttons.page_max = page_count
	if page_count > 1 then
		initComponentPaginationButtons(x + 43, y)
	end
end

function initComponentPaginationButtons(x, y)
	local previous_page = createButton(x, y, 16, 8)
	previous_page.onClick = function(self)
		component_buttons.page = max(1, component_buttons.page - 1)
		for b in all(component_buttons.buttons) do
			b.visible = false
			if b.page == component_buttons.page then
				b.visible = true
			end
		end
	end
	previous_page.draw = function(self)
		if component_buttons.page == 1 then
			pal(40, 39)
			spr(138, self.x, self.y)
			pal(40, 40)
		elseif self.hover then
			spr(139, self.x, self.y)
		else
			spr(138, self.x, self.y)
		end
	end
	add(buttons, previous_page)

	local next_page = createButton(x + 16, y, 16, 8)
	next_page.onClick = function(self)
		component_buttons.page = min(component_buttons.page_max, component_buttons.page + 1)
		for b in all(component_buttons.buttons) do
			b.visible = false
			if b.page == component_buttons.page then
				b.visible = true
			end
		end
	end
	next_page.draw = function(self)
		if component_buttons.page == component_buttons.page_max then
			pal(40, 39)
			spr(140, self.x, self.y)
			pal(40, 40)
		elseif self.hover then
			spr(141, self.x, self.y)
		else
			spr(140, self.x, self.y)
		end
	end
	add(buttons, next_page)
end

function setupBlueprint(name)
	local bp = {}
	bp.address = "map/blueprints/" .. name .. ".map"
	bp.bitmap = fetch(bp.address)
	return bp
end

function initCanvas()
	local bmp = blueprint.canvas.bitmap[2].bmp -- the second layer of the tilmap has collision data
	local canvas = {
		x = 0,
		y = 0,
		grid_width = bmp:width(),
		grid_height = bmp:height(),
	}
	--canvas grid is used for storing where components are placed
	canvas.grid = init2dTable(canvas.grid_width, canvas.grid_height)
	canvas.space_count = canvas.grid_height * canvas.grid_width
	--set specific spaces as blocked
	for lx = 1, canvas.grid_width do
		for ly = 1, canvas.grid_height do
			if bmp:get(lx - 1, ly - 1) == 192 then
				canvas.grid[ly][lx] = 1 -- grid id for blocked spaces
				canvas.space_count -= 1
			end
		end
	end

	--set offset based on width and height
	canvas.x = 240 - ((canvas.grid_width * grid_size) / 2) + 44
	canvas.y = 135 - ((canvas.grid_height * grid_size) / 2)
	return canvas
end

function getCellListFromRow(index, width)
	local list = {}
	for col = 1, width do
		add(list, {
			x = col,
			y = index
		})
	end
	return list
end

function getCellListFromCol(index, height)
	local list = {}
	for row = 1, height do
		add(list, {
			x = index,
			y = row
		})
	end
	return list
end

function initLineRestrictions(restrictions, bmp)
	for r in all(restrictions) do
		if r.line_type == "col" then
			r.cells = getCellListFromCol(r.index, bmp:height())
		else -- get row
			r.cells = getCellListFromRow(r.index, bmp:width())
		end
	end
end

function addTutorialPopup(content, title, x, y, width)
	local width = width or 180
	local title = title or nil
	local text_formatted, height = textwrap(content, width - 4)
	local x = x or alignCenter(width, 480)
	local y = y or alignCenter(height, 270)
	if title then height += 12 end
	local pop = createButton(x, y, width, height)

	pop.draw = function(self)
		drawWindowGlass(self.x, self.y, self.width, self.height)
		if title then
			rectfill(x + 1, y + 1, x + width - 2, y + 9, 37)
			print(title, self.x + 3, self.y + 2, 35)
			print(text_formatted, self.x + 3, self.y + 12, 17)
		else
			print(text_formatted, self.x + 3, self.y + 2, 17)
		end
	end
	pop.onClick = function(self)
		del(popups, self)
	end

	add(popups, pop)
end
