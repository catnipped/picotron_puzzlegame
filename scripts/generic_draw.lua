function drawDebug()
	local color = 8
	if can_place then color = 7 end
	local cpu = "CPU:" .. flr(stat(1) * 100)
	print(cpu, 480 - 8 * #cpu, 32, stat(1) + 6)
	print(tooltip, 480 - 8, 40, 30)
	--print(#placed_components,4,12,11)
	--[[
		for y = 1,#held_component.collider do
			for x = 1,#held_component.collider[y] do
				print(held_component.collider[y][x],30+x*12,30+y*12,7)
			end
		end
		]]
	--print("last delete: " .. debug_delete,4,32,57)
end

function stringIcon(icon, color, label, label_after, color_reset)
	local color = color or "b"
	local color_reset = color_reset or "b"
	return "\f" .. color .. label .. icon .. label_after .. "\f" .. color_reset
end

function drawCheckerBoard(offset_x, offset_y, grid_w, grid_h, clr, bg_clr)
	--checkerboard
	rectfill(offset_x, offset_y, offset_x + (grid_w * grid_size) - 1, offset_y + (grid_h * grid_size) - 1, bg_clr)
	for x = 0, grid_w - 1 do
		for y = 0, grid_h - 1 do
			if x % 2 == 0 and y % 2 == 0 or x % 2 ~= 0 and y % 2 ~= 0 then
				rectfill(offset_x + x * grid_size,
					offset_y + y * grid_size,
					offset_x + (x * grid_size) + grid_size - 1,
					offset_y + (y * grid_size) + grid_size - 1,
					clr
				)
			end
		end
	end
end

function drawWindowMetal(x, y, width, height)
	rectfill(x, y + 8, x + width - 1, y + height - 8, 0)
	--the sprite numbers
	local window_sprites = {
		88, 89, 90,
		96, 97, 98
	}
	rect(x, y + 7, x + width - 1, y + height - 8, 5)
	spr(window_sprites[1], x, y)
	sspr(window_sprites[2], 0, 0, 8, 8, x + 8, y, width - 16, 8)
	spr(window_sprites[3], x + width - 8, y)

	spr(window_sprites[4], x, y + height - 8)
	sspr(window_sprites[5], 0, 0, 8, 8, x + 8, y + height - 8, width - 16, 8)
	spr(window_sprites[6], x + width - 8, y + height - 8)
end

function drawWindowMarble(x, y, width, height)
	rectfill(x, y, x + width - 1, y + height - 1, 33)
	--the sprite numbers
	local window_sprites = {
		105, 106,
		113, 114
	}
	--rect(x,y+7,x+width-1,y+height-8,5)
	sspr(window_sprites[1], 4, 0, 4, 8, x + 8, y, width - 16, 8)
	sspr(window_sprites[1], 0, 4, 8, 4, x, y + 8, 8, height - 8)
	sspr(window_sprites[2], 0, 4, 8, 4, x + width - 8, y + 8, 8, height - 8)
	sspr(window_sprites[3], 4, 0, 4, 8, x + 8, y + height - 8, width - 16, 8)

	spr(window_sprites[1], x, y)
	spr(window_sprites[2], x + width - 8, y)

	spr(window_sprites[3], x, y + height - 8)

	spr(window_sprites[4], x + width - 8, y + height - 8)
end

function drawComponentInfo(component, x, y)
	local width = 90
	local height = 56

	rectfill(x + 2, y + 2, x + width + 2, y + height + 2, 1)
	rectfill(x, y, x + width, y + height, 39)
	rect(x, y, x + width, y + height, 38)
	rectfill(x, y, x + width, y + 10, 38)
	print(component.name, x + 3, y + 2, 7)
	print(component.info, x + 3, y + 14, 11)
	print("$" .. component.price .. " " .. string_color.yellow .. string_icon.power .. component.power, x + 3, y + 48, 11)
end

function horizontal_center(s, middle) -- from pico 8 wiki
	-- screen center minus the
	-- string length times the
	-- pixels in a char's width,
	-- cut in half
	return middle - #s * 2
end

function printToWidth(string, x, y, width_in_characters)
	local s = string
	for i = 1, #string do
		if i % width_in_characters == 0 then

		end
	end
end
