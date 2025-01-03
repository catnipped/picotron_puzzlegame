--[[pod_format="raw",created="2024-05-12 08:42:14",modified="2024-11-29 11:48:20",revision=67]]
component_types = {
	{
		type = 1,
		name = "Brick",
		info = "Generates " ..
			string_color.yellow ..
			"+1" ..
			string_icon.power ..
			string_color.green ..
			" for \nevery 4 of this \nyou have placed",
		width = 1,
		height = 1,
		sprite = 7,
		rotations = 0,
		max_rot = 1,
		price = 0,
		power = 0,
		compute = 0,
		collider = { { 1 }
		},
		onPlace = function(self)
			local sprite_variation = workbench.placed_component_amount[self.type] % 4 + 1
			self.sprite = self.sprite + sprite_variation
		end
		,
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end,
		ability_global = function(self) -- generate 1 power for each 4 of this
			local power = flr(workbench.placed_component_amount[self.type] / 4)
			workbench.power_generated += power
		end
	},
	{
		type = 2,
		name = "Pill",
		info = "Generates " .. string_color.yellow .. string_icon.power,
		width = 2,
		height = 1,
		sprite = 14,
		rotations = 0,
		max_rot = 2,
		price = 1,
		power = 1,
		compute = 0,
		collider = {
			{ 1, 1 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end,
	},
	{
		type = 3,
		name = "Discounter",
		info = "Each one reduces \nexpenses by -$1",
		width = 2,
		height = 2,
		sprite = 16,
		rotations = 0,
		max_rot = 4,
		price = -1,
		power = 0,
		compute = 0,
		collider = {
			{ 1, 1 },
			{ 1, 0 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end
	},
	{
		type = 4,
		name = "Long",
		info = "Generates " .. string_color.yellow .. string_icon.power,
		width = 4,
		height = 1,
		sprite = 24,
		rotations = 0,
		max_rot = 2,
		price = 1,
		power = 3,
		compute = 0,
		collider = {
			{ 1, 1, 1, 1 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end
	},
	{
		type = 5,
		name = "Compute-a-byte",
		info = "Generates " .. string_color.blue .. "1" .. string_icon.compute,
		width = 2,
		height = 2,
		sprite = 32,
		rotations = 0,
		max_rot = 0,
		price = 3,
		power = 0,
		compute = 1,
		collider = {
			{ 1, 1 },
			{ 1, 1 }
		},
		draw = function(self)
			spr(self.sprite, self.x, self.y)
		end
	}
}

component_types_experimental = {
	{
		type = 1,
		name = "Combinator",
		info = "Has " ..
			string_color.yellow ..
			"+1" .. string_icon.power .. string_color.green .. " for each \nneighbour of the \nsame type",
		width = 1,
		height = 1,
		sprite = 7,
		rotations = 0,
		max_rot = 1,
		price = 2,
		power = 0,
		compute = 0,
		collider = { { 1 }
		},
		onPlace = function(self)
			-- self.sprite = self.sprite + ceil(rnd(4))
		end
		,
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
			print(self.power, self.x + 6, self.y + 4, 30)
		end,
		ability_instance = function(self) -- gets +1 power if next to the same type
			self.power = 0
			for i in all(self.neighbors) do
				local id = getCanvasVal(i.x, i.y)

				for p in all(placed_components) do
					if p.id == id and p.type == self.type then
						self.power += 1
					end
				end
			end
		end
	},
	{
		type = 2,
		name = "Battery",
		info = "Generates " .. string_color.yellow .. string_icon.power,
		width = 2,
		height = 1,
		sprite = 14,
		rotations = 0,
		max_rot = 2,
		price = 2,
		power = 2,
		compute = 0,
		collider = {
			{ 1, 1 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end,
		-- ability_global = function(self)
		-- 	workbench.compute_generated += placed_component_amount[self.type]
		-- end
	},
	{
		type = 3,
		name = "Discounter",
		info = "Each one reduces \nexpenses by -$1",
		width = 2,
		height = 2,
		sprite = 16,
		rotations = 0,
		max_rot = 4,
		price = -1,
		power = 0,
		compute = 0,
		collider = {
			{ 1, 1 },
			{ 1, 0 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end
	},
	{
		type = 4,
		name = "Multiplier",
		info = "Generates " ..
			string_color.yellow .. string_icon.power .. string_color.green .. " equal \nto number of my-\nself",
		width = 4,
		height = 1,
		sprite = 24,
		rotations = 0,
		max_rot = 2,
		price = 2,
		power = 0,
		compute = 0,
		collider = {
			{ 1, 1, 1, 1 }
		},
		draw = function(self)
			spr(self.sprite + self.rotations, self.x, self.y)
		end,
		ability_instance = function(self)
			local count = 0
			for i in all(placed_components) do
				if i.type == self.type then
					count += 1
				end
			end
			self.power = count
		end
	},
	{
		type = 5,
		name = "Compute-a-byte",
		info = "Generates " .. string_color.blue .. "1" .. string_icon.compute,
		width = 2,
		height = 2,
		sprite = 32,
		rotations = 0,
		max_rot = 0,
		price = 3,
		power = 0,
		compute = 1,
		collider = {
			{ 1, 1 },
			{ 1, 1 }
		},
		draw = function(self)
			spr(self.sprite, self.x, self.y)
		end
	}
}
