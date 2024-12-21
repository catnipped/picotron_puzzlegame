--[[pod_format="raw",created="2024-12-03 10:50:52",modified="2024-12-03 10:50:52",revision=0]]

function drawLevelSelect()
	drawWindowMetal(64, 8, 250, 100)
	print(welcome_message, 72, 16, 11)
end

function drawBlueprintFile(x, y, level_number, hover, selected)
	if hover then
		rectfill(x - 3, y - 3, x + 33, y + 41, 0)
	end
	spr(160, x, y)
	print(level_number, x + 18, y + 3, 36)
	local bp = blueprint_library[level_number]
	print(bp.sell_target, x + 10, y + 15, 11)
	print(bp.power_target, x + 10, y + 29, 9)

	local name_colors = { 0, 7 }
	if selected then name_colors = { 7, 0 } end
	rectfill(horizontal_center(bp.name, x + 10) - 2, y + 44, horizontal_center(bp.name, x + 10) + #bp.name * 5 + 2,
		y + 53, name_colors[1])
	print(bp.name, horizontal_center(bp.name, x + 10), y + 45, name_colors[2])

	--checkmark
	if progression.blueprints[level_number].clear then
		if progression.blueprints[level_number].clear_with_blue then
			pal(3, 16)
			pal(11, 62)
		end
		spr(91, x - 3, y - 3)
		pal(3, 3)
		pal(11, 11)
	end
end
