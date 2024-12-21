--[[pod_format="raw",created="2024-05-12 09:10:20",modified="2024-11-26 15:07:47",revision=16]]
function updateWorkbench()
	if keyp("q") then
		mouseMode(1) --info
	end
	if keyp("w") then
		mouseMode(2) --place
	end
	if keyp("e") then
		mouseMode(4) --erase
	end
	if keyp("r") and mouse_mode[2] then
		rotateComponent(workbench.held_component)
	end

	-- get tooltip info from placed component
	if mouse_mode[1] and mouseWithinCanvas() then
		local mouse_x, mouse_y = mouse_val.x - workbench.canvas.x, mouse_val.y - workbench.canvas.y
		local mouse_cell_x = ceil(mouse_x / grid_size)
		local mouse_cell_y = ceil(mouse_y / grid_size)
		local cell_id = getCanvasVal(mouse_cell_x, mouse_cell_y)
		if cell_id > 1 then --ignore if marked empty
			for i in all(workbench.placed_components) do
				if i.id == cell_id then
					tooltip = i
				end
			end
		end
	end

	if mouse_mode[2] and mbtnp(1) then --rotate
		rotateComponent(workbench.held_component)
	end

	for i = 1, #component_types do --hot switch component
		if keyp("" .. i) then
			workbench.held_component = tablecopy(component_types[i])
			mouseMode(2)
		end
	end

	if mouse_mode[4] and mbtn(0) and mouseWithinCanvas() then --erase
		eraseComponent()
	end

	if mouse_mode[2] and workbench.held_component then --place
		checkPlacement()
		if can_place and mbtn(0) then
			placeComponent()
		end
	end
end

function checkPlacement()
	-- only bother if within canvas bounds
	if mouseWithinCanvas() then
		--offset to canvas origo
		local mouse_x, mouse_y = mouse_val.x - workbench.canvas.x, mouse_val.y - workbench.canvas.y
		local mouse_cell_x = flr(mouse_x / grid_size)
		local mouse_cell_y = flr(mouse_y / grid_size)

		local component = nil
		if mouse_mode[2] then
			component = workbench.held_component
		end
		if component == nil then return end

		--creates a table based on canvas
		local proposed_placement_collider = init2dTable(workbench.canvas.grid_width, workbench.canvas.grid_height)
		--places the held component on it offset by where the mouse is
		can_place = true
		for x = 1, component.width do
			for y = 1, component.height do
				local held_cell = component.collider[y][x]
				local canvas_cell = 0
				if mouse_cell_y + y <= workbench.canvas.grid_height and
					mouse_cell_x + x <= workbench.canvas.grid_width then
					canvas_cell = workbench.canvas.grid[mouse_cell_y + y][mouse_cell_x + x]
					if held_cell > 0 and canvas_cell > 0 then
						--can't place if held cell is not empty and canvas cell is not empty
						can_place = false
						--2 means overlap
						proposed_placement_collider[mouse_cell_y + y][mouse_cell_x + x] = 2
					elseif held_cell > 0 then
						--1 means ok!
						proposed_placement_collider[mouse_cell_y + y][mouse_cell_x + x] = 1
					end
				else
					--can't place if outside of bounds
					can_place = false
				end
			end
		end
		--set proposed placement
		proposed_placement = {
			x = mouse_cell_x,
			y = mouse_cell_y,
			collider = proposed_placement_collider
		}
		--checks if there is collision and sets can_place
	else
		proposed_placement = nil
		can_place = false
	end
end

function getCanvasVal(x, y)
	local val = nil
	val = workbench.canvas.grid[y][x]
	return val
end

function mouseWithinCanvas()
	if mouse_val.x > workbench.canvas.x
		and mouse_val.x < workbench.canvas.x + grid_size * workbench.canvas.grid_width
		and mouse_val.y > workbench.canvas.y
		and mouse_val.y < workbench.canvas.y + grid_size * workbench.canvas.grid_height then
		return true
	else
		return false
	end
end

function evaluationUpdate()
	for i in all(workbench.placed_components) do
		if i.ability_instance then
			component_types[i.type].ability_instance(i)
		end
		if i.ability_global then -- set flags for each component type placed
			workbench.global_abilities[i.type] = true
		end
	end

	workbench.cost_of_components = evaluateCost(workbench.placed_components)
	workbench.power_generated = evaluatePower(workbench.placed_components)
	workbench.compute_generated = evaluateCompute(workbench.placed_components)
	workbench.placed_component_amount = countComponents(workbench.placed_components)
	workbench.restrictions = evaluateRestrictions(blueprint.restrictions)

	for i = 1, #component_types do
		if workbench.global_abilities[i] then
			component_types[i].ability_global(component_types[i])
		end
	end

	if workbench.restrictions
		and workbench.power_generated >= blueprint.power_target
		and workbench.cost_of_components <= blueprint.sell_target then
		blueprint.ready = true
	end
end

function evaluateRestrictions(restrictions)
	local check = true
	for r in all(restrictions) do
		r.check = r.eval_fun(r)
		if not r.check then
			check = r.check
		end
	end
	return check
end

function evaluatePower(placed_components)
	local total = 0
	for i in all(placed_components) do
		total += i.power
	end
	return total
end

function evaluateCompute(placed_components)
	local total = 0
	for i in all(placed_components) do
		total += i.compute
	end
	return total
end

function evaluateCost(placed_components)
	local total = 0
	for i in all(placed_components) do
		total += i.price
	end
	return total
end

function placeComponent()
	--offset to canvas origin
	local mouse_x, mouse_y = mouse_val.x - workbench.canvas.x, mouse_val.y - workbench.canvas.y
	local mouse_cell_x = flr(mouse_x / grid_size)
	local mouse_cell_y = flr(mouse_y / grid_size)

	--sets canvas grid cells to held component
	for x = 1, workbench.held_component.width do
		for y = 1, workbench.held_component.height do
			local cell = workbench.held_component.collider[y][x]
			if cell > 0 then
				workbench.canvas.grid[mouse_cell_y + y][mouse_cell_x + x] = workbench.held_component_id
			end
		end
	end
	local neighbors = {}
	for y = 1, workbench.canvas.grid_height do
		for x = 1, workbench.canvas.grid_width do
			if workbench.canvas.grid[y][x] == workbench.held_component_id then
				if workbench.canvas.grid[y - 1][x] ~= workbench.held_component_id then
					add(neighbors, vec(x, y - 1))
				end
				if workbench.canvas.grid[y + 1][x] ~= workbench.held_component_id then
					add(neighbors, vec(x, y + 1))
				end
				if workbench.canvas.grid[y][x - 1] ~= workbench.held_component_id then
					add(neighbors, vec(x - 1, y))
				end
				if workbench.canvas.grid[y][x + 1] ~= workbench.held_component_id then
					add(neighbors, vec(x + 1, y))
				end
			end
		end
	end

	local placed_component = tablecopy(workbench.held_component)
	placed_component.x = mouse_cell_x * grid_size + workbench.canvas.x
	placed_component.y = mouse_cell_y * grid_size + workbench.canvas.y
	placed_component.id = workbench.held_component_id
	placed_component.neighbors = neighbors
	if placed_component.onPlace ~= nil then
		placed_component.onPlace(placed_component)
	end
	add(workbench.placed_components, placed_component)
	workbench.held_component_id += 1
	evaluationUpdate()
end

function rotateComponent(held_component)
	held_component.width, held_component.height = held_component.height, held_component.width
	held_component.rotations = (held_component.rotations + 1) % held_component.max_rot
	held_component.collider = rotateMatrix(held_component.collider)
end

function eraseComponent()
	--offset to canvas origin
	local mouse_x, mouse_y = mouse_val.x - workbench.canvas.x, mouse_val.y - workbench.canvas.y
	local mouse_cell_x = ceil(mouse_x / grid_size)
	local mouse_cell_y = ceil(mouse_y / grid_size)

	local id = getCanvasVal(mouse_cell_x, mouse_cell_y)

	if id > 1 then
		deleteCellsFromCanvas(id)
		deleteComponentFromPlacedComponents(id)
	end

	evaluationUpdate()
end

function deleteCellsFromCanvas(id)
	for y = 1, workbench.canvas.grid_height do
		for x = 1, workbench.canvas.grid_width do
			if workbench.canvas.grid[y][x] == id then
				workbench.canvas.grid[y][x] = 0
			end
		end
	end
end

function deleteComponentFromPlacedComponents(id)
	--find the component with the right id, then delete it
	for i in all(workbench.placed_components) do
		if i.id == id then
			del(workbench.placed_components, i)
			return
		end
	end
end

function mouseMode(m) --info, place, mark empty, erase
	local cursor_id = 119 + m
	local cur = get_spr(cursor_id)
	window { cursor = cur }
	for i = 1, #mouse_mode do
		local v = false
		if i == m then v = true end
		mouse_mode[i] = v
	end
end

function countComponents(placed_components)
	local list = {}
	for i = 1, #component_types do
		local count = 0
		for j = 1, #placed_components do
			if placed_components[j].name == component_types[i].name then
				count += 1
			end
		end
		list[i] = count
		if count < 1 then
			workbench.global_abilities[i] = false
		end
	end
	return list
end
