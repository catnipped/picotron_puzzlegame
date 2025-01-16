--[[pod_format="raw",created="2024-05-12 07:41:09",modified="2024-12-17 11:41:37",revision=77]]
function initWorkbench(level_number)
	--load the data for the level (blueprint)
	current_level = level_number
	blueprint = blueprint_library[level_number]
	blueprint.ready = false
	blueprint.canvas = setupBlueprint(blueprint.file_name)
	initLineRestrictions(blueprint.restrictions, blueprint.canvas.bitmap[2].bmp)

	-- set up workbench (current solution)
	printh("loading... " .. "/appdata/puzzle/blueprint_solutions/" .. blueprint.file_name .. ".pod")
	workbench = fetch("/appdata/puzzle/blueprint_solutions/" .. blueprint.file_name .. ".pod")
	if workbench == nil then
		workbench = {}
		workbench.canvas = initCanvas()
		--table that holds all globals
		workbench.global_abilities = {}

		--placed components is a list of every saved component and their position
		workbench.placed_components = {}
		workbench.placed_component_amount = countComponents(workbench.placed_components)
		--stats
		workbench.cost_of_components = 0
		workbench.power_generated = 0
		workbench.compute_generated = 0
		workbench.restrictions = false

		--instances a a component from the library and gives it an id
		workbench.held_component = tablecopy(component_types[1])
		workbench.held_component_id = 2 --starts on 2, because 1 is reserved for marked empty
	end
	--these two are used to evaluate and visualise if a component can be placed
	proposed_placement = nil
	can_place = false

	mouse_mode = { false, false, false, false } -- info, place, empty, erase
	mouseMode(1)

	buttons = {}

	initToolboxButtons(13, 31)
	initComponentBoxButtons(12, 68)
	initGoBackButton()
	evaluationUpdate()
end

function initGoBackButton()
	local goBack_button = createButton(400, 250, 64, 16)
	goBack_button.draw = function(self)
		local color = 2
		if blueprint.ready then color = 11 end
		if self.hover then color = 7 end
		drawPillButton(self.x, self.y, self.width, self.hover, self.clicked)
		--	rectfill(self.x, self.y, self.x + self.width, self.y + self.height, color)
		print("<- go back", self.x + 4, self.y + 4, 0)
	end
	goBack_button.onClick = function(self)
		if blueprint.ready then
			progression.blueprints[current_level].clear = true
			if workbench.compute_generated > 0 then
				progression.blueprints[current_level].clear_with_blue = true
			end
		end
		--saving
		printh("saving...")
		saveProgression()
		store("/appdata/puzzle/blueprint_solutions/" .. blueprint.file_name .. ".pod", workbench)

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
		rotateComponent()
	end
	add(buttons, rotate_button)
end

function initComponentBoxButtons(x, y)
	local y_offset = 0
	for i = 1, #component_types do
		local component_button = createButton(x, y + y_offset, 73,
			component_types[i].height * grid_size)
		component_button.draw = function(self)
			if self.hover then
				rectfill(self.x, self.y, self.x + self.width, self.y + self.height, 38)
			end
			drawComponentInBox(i, self.x, self.y, self.width)
		end
		component_button.onClick = function(self)
			workbench.held_component = tablecopy(component_types[i])
			mouseMode(2)
		end
		component_button.onHover = function(self)
			tooltip = component_types[i]
		end

		add(buttons, component_button)
		y_offset += 16 + component_types[i].height * grid_size
	end
end

function setupBlueprint(name)
	local bp = {}
	bp.address = "/ram/cart/map/blueprints/" .. name .. ".map"
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

	--set specific spaces as blocked
	for lx = 1, canvas.grid_width do
		for ly = 1, canvas.grid_height do
			if bmp:get(lx - 1, ly - 1) == 192 then
				canvas.grid[ly][lx] = 1
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
