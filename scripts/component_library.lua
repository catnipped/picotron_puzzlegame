--[[pod_format="raw",created="2024-05-12 08:42:14",modified="2024-11-29 11:48:20",revision=67]]
component_library = {
	-- must have:
	-- 	sprite
	-- 	collider
	-- optional:
	--	name
	--	info
	--	price
	--	power
	--	compute
	-- 	max_rot
	-- 	draw(self)
	-- 	onPlace(self) add other unique variables that can be referenced by itself
	-- 	ability_global(self)
	-- 	ability_instance(self)

	{
		name = "Brick",
		info = "Generates " ..
			string_color.yellow ..
			"+1" ..
			string_icon.power ..
			string_color.green ..
			" for \nevery 4 of this \nyou have placed",
		sprite = 7,
		price = 0,
		collider = { { 1 } },
		onPlace = function(self)
			self.sprite_variation = workbench.placed_component_amount[self.type] % 4 + 1
		end,
		draw = function(self)
			spr(self.sprite + self.sprite_variation, self.x, self.y)
		end,
		ability_global = function(self) -- generate 1 power for each 4 of this
			local power = flr(workbench.placed_component_amount[self.type] / 4)
			workbench.power_generated += power
		end
	},
	{
		name = "Pill",
		info = "Generates " .. string_color.yellow .. string_icon.power,
		sprite = 14,
		max_rot = 2,
		price = 1,
		power = 1,
		collider = {
			{ 1, 1 }
		},
	},
	{
		type = 3,
		name = "Discounter",
		info = "Each one reduces \nexpenses by -$1",
		sprite = 16,
		max_rot = 4,
		price = -1,
		collider = {
			{ 1, 1 },
			{ 1, 0 }
		},
	},
	{
		name = "Long",
		info = "Generates " .. string_color.yellow .. string_icon.power,
		sprite = 24,
		max_rot = 2,
		price = 3,
		power = 3,
		collider = {
			{ 1, 1, 1, 1 }
		},
	},
	{
		name = "Compute-a-byte",
		info = "Generates " .. string_color.blue .. "1" .. string_icon.compute,
		sprite = 32,
		price = 3,
		compute = 1,
		collider = {
			{ 1, 1 },
			{ 1, 1 }
		},
	},
	{
		name = "Chain",
		info = "Makes one 1 power when connected to a another Chain",
		sprite = 40,
		max_rot = 2,
		price = 1,
		collider = {
			{ 1, 1 },
		},
		draw = function(self)
			if self.power > 0 then
				pal(0, 10)
			end
			spr(self.sprite + self.rotations, self.x, self.y)
			pal(0, 0)
		end,
		ability_instance = function(self)
			--check if neighbors are the same type, sets power to 1 if so
			local check = false
			for i in all(self.neighbors) do
				local neighbour = getComponentFromCell(i) or { type = 0 } -- placeholder to avoid nil error
				if neighbour.type == self.type then
					check = true
					addModifier(self.power_modifiers, { mod = 1, id = self.id })
				end
			end
			if check == false then
				removeModifier(self.power_modifiers, self.id)
			end
		end,

	},
	{
		name = "Frame",
		sprite = 42,
		price = 9,
		power = 9,
		collider = {
			{ 1, 1, 1 },
			{ 1, 0, 1 },
			{ 1, 1, 1 }
		},

	},
	{
		name = "Attach",
		info = "Boosts the effect of attached component",
		sprite = 43,
		max_rot = 4,
		price = 1,
		collider = { { 1 } },
		draw = function(self)
			local y_offset = 0
			if self.rotations == 2 then y_offset = -2 end
			local x_offset = 0
			if self.rotations == 3 then x_offset = -2 end
			spr(self.sprite + self.rotations, self.x + x_offset, self.y + y_offset)
		end
	},
	{
		name = "Blob",
		sprite = 48,
		max_rot = 2,
		price = 5,
		compute = 1,
		collider = {
			{ 0, 1 },
			{ 1, 0 }
		},

	},
	{
		name = "Displaced",
		sprite = 51,
		max_rot = 4,
		price = 3,
		power = 3,
		collider = {
			{ 0, 0, 1 },
			{ 1, 1, 0 }
		},
	}
}

function initComponentTypes()
	local types = {}
	for i = 1, #component_library do
		local component_type = componentFromTemplate(i)
		component_type.type = i
		add(types, component_type)
	end
	return types
end

function componentFromTemplate(index)
	local lib_component = tablecopy(component_library[index])
	local component = {
		name = lib_component.name or "Untitled",
		info = lib_component.info or "",
		sprite = lib_component.sprite,
		rotations = 0,
		max_rot = lib_component.max_rot or 1, --default is no rotations
		price = lib_component.price or 0,
		power = lib_component.power or 0,
		compute = lib_component.compute or 0,
		collider = lib_component.collider,
		draw = lib_component.draw or function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end,
		onPlace = lib_component.onPlace or nil,
		ability_global = lib_component.ability_global or nil,
		ability_instance = lib_component.ability_instance or nil,
	}
	component.width = #component.collider[1]
	component.height = #component.collider
	return component
end

-- component_types_experimental = {
-- 	{
-- 		type = 1,
-- 		name = "Combinator",
-- 		info = "Has " ..
-- 			string_color.yellow ..
-- 			"+1" .. string_icon.power .. string_color.green .. " for each \nneighbour of the \nsame type",
-- 		width = 1,
-- 		height = 1,
-- 		sprite = 7,
-- 		rotations = 0,
-- 		max_rot = 1,
-- 		price = 2,
-- 		power = 0,
-- 		compute = 0,
-- 		collider = { { 1 }
-- 		},
-- 		onPlace = function(self)
-- 			-- self.sprite = self.sprite + ceil(rnd(4))
-- 		end
-- 		,
-- 		draw = function(self)
-- 			spr(self.sprite + self.rotations, self.x, self.y)
-- 			print(self.power, self.x + 6, self.y + 4, 30)
-- 		end,
-- 		ability_instance = function(self) -- gets +1 power if next to the same type
-- 			self.power = 0
-- 			for i in all(self.neighbors) do
-- 				local id = getCanvasVal(i.x, i.y)

-- 				for p in all(workbench.placed_components) do
-- 					if p.id == id and p.type == self.type then
-- 						self.power += 1
-- 					end
-- 				end
-- 			end
-- 		end
-- 	},
-- 	{
-- 		type = 2,
-- 		name = "Battery",
-- 		info = "Generates " .. string_color.yellow .. string_icon.power,
-- 		width = 2,
-- 		height = 1,
-- 		sprite = 14,
-- 		rotations = 0,
-- 		max_rot = 2,
-- 		price = 2,
-- 		power = 2,
-- 		compute = 0,
-- 		collider = {
-- 			{ 1, 1 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite + self.rotations, self.x, self.y)
-- 		end,
-- 		-- ability_global = function(self)
-- 		-- 	workbench.compute_generated += placed_component_amount[self.type]
-- 		-- end
-- 	},
-- 	{
-- 		type = 3,
-- 		name = "Discounter",
-- 		info = "Each one reduces \nexpenses by -$1",
-- 		width = 2,
-- 		height = 2,
-- 		sprite = 16,
-- 		rotations = 0,
-- 		max_rot = 4,
-- 		price = -1,
-- 		power = 0,
-- 		compute = 0,
-- 		collider = {
-- 			{ 1, 1 },
-- 			{ 1, 0 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite + self.rotations, self.x, self.y)
-- 		end
-- 	},
-- 	{
-- 		type = 4,
-- 		name = "Multiplier",
-- 		info = "Generates " ..
-- 			string_color.yellow .. string_icon.power .. string_color.green .. " equal \nto number of my-\nself",
-- 		width = 4,
-- 		height = 1,
-- 		sprite = 24,
-- 		rotations = 0,
-- 		max_rot = 2,
-- 		price = 2,
-- 		power = 0,
-- 		compute = 0,
-- 		collider = {
-- 			{ 1, 1, 1, 1 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite + self.rotations, self.x, self.y)
-- 		end,
-- 		ability_instance = function(self)
-- 			local count = 0
-- 			for i in all(workbench.placed_components) do
-- 				if i.type == self.type then
-- 					count += 1
-- 				end
-- 			end
-- 			self.power = count
-- 		end
-- 	},
-- 	{
-- 		type = 5,
-- 		name = "Compute-a-byte",
-- 		info = "Generates " .. string_color.blue .. "1" .. string_icon.compute,
-- 		width = 2,
-- 		height = 2,
-- 		sprite = 32,
-- 		rotations = 0,
-- 		max_rot = 0,
-- 		price = 3,
-- 		power = 0,
-- 		compute = 1,
-- 		collider = {
-- 			{ 1, 1 },
-- 			{ 1, 1 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite, self.x, self.y)
-- 		end
-- 	}
-- }
