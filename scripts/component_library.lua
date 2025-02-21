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
    --	ichor
    -- 	max_rot
    -- 	draw(self)
    -- 	onPlace(self) add other unique variables that can be referenced by itself
    -- 	ability_global(self)
    -- 	ability_instance(self)
    {
        name = "Pink",
        info = "Generates 1 power",
        sprite = 7,
        max_rot = 1,
        price = 3,
        power = 1,
        collider = {
            { 1 }
        },
    },
    {
        name = "Pink Discount",
        info = "Reduces the cost of Pink neighbors by 1",
        sprite = 12,
        max_rot = 2,
        price = 0,
        power = 0,
        collider = {
            { 1, 1 }
        },
        onPlace = function(self)
            for i in all(component_types) do
                if i.name == "Pink" then
                    component_types[self.type].basic_type = i.type
                    break
                end
            end
        end,
        ability_instance = function(self)
            for i in all(self.neighbors) do
                local neighbour = getComponentFromCell(i) or { type = 0 } -- placeholder to avoid nil error
                if neighbour.type == component_types[self.type].basic_type then
                    addModifier(neighbour.price_modifiers, { mod = -1, id = self.id })
                end
            end
        end
    },
    {
        name = "Pill",
        info = "Generates 1 power",
        sprite = 20,
        max_rot = 2,
        price = 2,
        power = 1,
        collider = {
            { 1, 1 }
        },
    },
    {
        name = "Long",
        info = "Generates 3 power",
        sprite = 24,
        max_rot = 2,
        price = 5,
        power = 3,
        collider = {
            { 1, 1, 1, 1 }
        },
    },
    {
        type = 3,
        name = "Advanced Discount",
        info = "Reduces component prices of neighbours by 1 for each empty neighbour space",
        sprite = 16,
        max_rot = 4,
        price = 0,
        collider = {
            { 1, 1 },
            { 1, 0 }
        },
        ability_instance = function(self)
            self.empty_neighbor_cells = {}
            for i in all(self.neighbors) do
                if getCanvasVal(i.x, i.y) == 0 then
                    add(self.empty_neighbor_cells, i)
                end
            end
            self.discount_value = #self.empty_neighbor_cells
            for i in all(self.neighbors) do
                local neighbor = getComponentFromCell(i) -- placeholder to avoid nil error
                if neighbor then
                    removeModifier(neighbor.price_modifiers, self.id)
                    addModifier(neighbor.price_modifiers, { mod = -self.discount_value, id = self.id })
                end
            end
        end,
        draw = function(self)
            spr(self.sprite + self.rotations, self.x, self.y)
            for i in all(self.empty_neighbor_cells) do
                local x, y = workbench.canvas.x + ((i.x - 1) * grid_size), workbench.canvas.y + ((i.y - 1) * grid_size)
                spr(3, x, y)
            end
        end
    },
    {
        name = "Ambrosia",
        info = "The 4th placed generates 1 power. The 8th generates 1 ichor.",
        sprite = 4,
        price = 0,
        collider = { { 1 } },
        onPlace = function(self)
            self.sprite_variation = 0
        end,

        draw = function(self)
            spr(self.sprite + self.sprite_variation, self.x, self.y)
        end,
        ability_global = function(self)
            local count = 0
            for i in all(workbench.placed_components) do
                if i.type == self.type then
                    removeModifier(i.power_modifiers, 1000)
                    removeModifier(i.ichor_modifiers, 1000)
                    i.produces_power = false
                    i.produces_ichor = false
                    i.sprite_variation = 0
                    count += 1
                    if workbench.placed_component_amount[self.type] >= 4 and count == 4 then
                        i.sprite_variation = 1
                        i.produces_power = true
                        addModifier(i.power_modifiers, { mod = 1, id = 1000 })
                    elseif workbench.placed_component_amount[self.type] >= 8 and count == 8 then
                        i.sprite_variation = 2
                        i.produces_ichor = true
                        addModifier(i.ichor_modifiers, { mod = 1, id = 1000 })
                    end
                end
            end
        end
    },
    {
        name = "Diversity Engine",
        info = "Generates 1 power per different type of neighbour",
        sprite = 34,
        max_rot = 2,
        price = 5,
        power = 0,
        collider = {
            { 1, 1, 0 },
            { 0, 1, 1 }
        },
        ability_instance = function(self)
            removeModifier(self.power_modifiers, self.id)
            self.produces_power = false
            self.list_of_unique_neighbor_types = {}
            for n in all(self.neighbors) do
                local neighbor = getComponentFromCell(n) -- placeholder to avoid nil error
                if neighbor then
                    local uniquness = true
                    for i in all(self.list_of_unique_neighbor_types) do
                        if neighbor.type == i then
                            uniquness = false
                        end
                    end
                    if uniquness then
                        add(self.list_of_unique_neighbor_types, neighbor.type)
                    end
                end
            end
            local type_count = #self.list_of_unique_neighbor_types or 0
            if type_count > 0 then
                self.produces_power = true
                addModifier(self.power_modifiers, { mod = type_count, id = self.id })
            end
        end
    },
    {
        name = "Impossible Engine",
        info = "Generates 1 ichor",
        sprite = 32,
        price = 3,
        ichor = 1,
        collider = {
            { 1, 1 },
            { 1, 1 }
        },
    },
    {
        name = "Chain",
        info = "Generates one 1 power when connected to 1 or 2 other Chains",
        sprite = 40,
        max_rot = 2,
        price = 1,
        collider = {
            { 1, 1 },
        },
        draw = function(self)
            if self.produces_power then
                pal(0, 10)
            end
            spr(self.sprite + self.rotations, self.x, self.y)
            pal(0, 0)
        end,
        ability_instance = function(self)
            --check if neighbors are the same type, sets power to 1 if so
            self.produces_power = false
            local chain_count = 0
            local chained_ids = {}
            for i in all(self.neighbors) do
                local neighbour = getComponentFromCell(i) or { type = 0 } -- placeholder to avoid nil error
                if neighbour.type == self.type then
                    chained_ids[neighbour.id] = neighbour.id
                end
            end
            for k, v in pairs(chained_ids) do
                chain_count += 1
            end
            if chain_count > 0 and chain_count <= 2 then
                self.produces_power = true
                addModifier(self.power_modifiers, { mod = 1, id = self.id })
            end
            if self.produces_power == false then
                removeModifier(self.power_modifiers, self.id)
            end
        end,

    },
    {
        name = "Frame",
        info = "Generates 6 power",
        sprite = 42,
        price = 8,
        power = 6,
        collider = {
            { 1, 1, 1 },
            { 1, 0, 1 },
            { 1, 1, 1 }
        },

    },
    {
        name = "Booster",
        info = "Boosts the generation of attached component",
        sprite = 43,
        max_rot = 4,
        price = 2,
        collider = { { 1 } },
        draw = function(self)
            local y_offset = 0
            if self.rotations == 2 then y_offset = -2 end
            local x_offset = 0
            if self.rotations == 3 then x_offset = -2 end
            spr(self.sprite + self.rotations, self.x + x_offset, self.y + y_offset)
        end,
        onPlace = function(self)
            self.boosted_neighbour = nil
            for y = 1, workbench.canvas.grid_height do
                for x = 1, workbench.canvas.grid_width do
                    if workbench.canvas.grid[y][x] == self.id then
                        if self.rotations == 0 then     --south
                            self.boosted_neighbour = vec(x, y + 1)
                        elseif self.rotations == 1 then --east
                            self.boosted_neighbour = vec(x + 1, y)
                        elseif self.rotations == 2 then --north
                            self.boosted_neighbour = vec(x, y - 1)
                        elseif self.rotations == 3 then --west
                            self.boosted_neighbour = vec(x - 1, y)
                        end
                    end
                end
            end
            self.ability_instance(self)
        end,
        ability_instance = function(self)
            local id = getCanvasVal(self.boosted_neighbour.x, self.boosted_neighbour.y)
            if id > 1 then
                for i in all(workbench.placed_components) do
                    if i.id == id then
                        addModifier(i.power_modifiers, { mod = 1, id = self.id })
                        addModifier(i.ichor_modifiers, { mod = 1, id = self.id })
                    end
                end
            end
        end,
    },
    {
        name = "Blob",
        info = "Generates 1 ichor",
        sprite = 48,
        max_rot = 2,
        price = 5,
        ichor = 1,
        collider = {
            { 0, 1 },
            { 1, 0 }
        },

    },
    {
        name = "Alone",
        info = "Generates 1 power, reduces power generation of neighbours by 1",
        sprite = 14,
        price = 1,
        power = 1,
        collider = {
            { 1 }
        },
        draw = function(self)
            spr(self.sprite, self.x, self.y)
            for i in all(self.neighbors) do
                if getCanvasVal(i.x, i.y) == 0 then
                    local x, y = workbench.canvas.x + ((i.x - 1) * grid_size),
                        workbench.canvas.y + ((i.y - 1) * grid_size)
                    spr(15, x, y)
                end
            end
        end,
        ability_instance = function(self)
            for i in all(self.neighbors) do
                if getCanvasVal(i.x, i.y) > 1 then
                    local neighbor = getComponentFromCell(i) or {}
                    addModifier(neighbor.power_modifiers, { mod = -1, id = self.id })
                end
            end
        end

    },
    {
        name = "Displaced",
        info = "Generates 2 power",
        sprite = 51,
        max_rot = 4,
        price = 3,
        power = 2,
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
        ichor = lib_component.ichor or 0,
        collider = lib_component.collider,
        draw = lib_component.draw or function(self)
            spr(self.sprite + self.rotations, self.x, self.y)
        end,
        onPlace = lib_component.onPlace or nil,
        onErase = lib_component.onErase or nil,
        ability_global = lib_component.ability_global or nil,
        ability_instance = lib_component.ability_instance or nil,
    }
    if component.power > 0 then
        component.produces_power = true
    else
        component.produces_power = false
    end
    if component.ichor > 0 then
        component.produces_ichor = true
    else
        component.produces_ichor = false
    end
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
-- 		ichor = 0,
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
-- 		ichor = 0,
-- 		collider = {
-- 			{ 1, 1 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite + self.rotations, self.x, self.y)
-- 		end,
-- 		-- ability_global = function(self)
-- 		-- 	workbench.ichor_generated += placed_component_amount[self.type]
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
-- 		ichor = 0,
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
-- 		ichor = 0,
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
-- 		name = "ichor-a-byte",
-- 		info = "Generates " .. string_color.blue .. "1" .. string_icon.ichor,
-- 		width = 2,
-- 		height = 2,
-- 		sprite = 32,
-- 		rotations = 0,
-- 		max_rot = 0,
-- 		price = 3,
-- 		power = 0,
-- 		ichor = 1,
-- 		collider = {
-- 			{ 1, 1 },
-- 			{ 1, 1 }
-- 		},
-- 		draw = function(self)
-- 			spr(self.sprite, self.x, self.y)
-- 		end
-- 	}
-- }
