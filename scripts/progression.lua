--[[pod_format="raw",created="2024-12-17 11:40:19",modified="2024-12-17 11:40:37",revision=1]]
function initProgression(bp_lib)
	local table = {
		cleared_amount = 0,
		cleared_with_blue_amount = 0,
		blueprints_starting_unlocks = 4,
		blueprints = {},
		components_starting_unlocks = 10,
		components_unlocks = 0

	}
	for i = 1, #bp_lib do
		table.blueprints[i] = {
			unlocked = false,
			clear = false,
			clear_with_blue = false,
		}
	end
	return table
end

function updateLevelProgression()
	progression.cleared_amount = 0
	progression.cleared_with_blue_amount = 0
	for i = 1, #progression.blueprints do
		if progression.blueprints[i].clear then
			progression.cleared_amount += 1
		end
		if progression.blueprints[i].clear_with_blue then
			progression.cleared_with_blue_amount += 1
		end
		if i <= progression.blueprints_starting_unlocks + progression.cleared_amount then
			progression.blueprints[i].unlocked = true
		end
	end
end

function saveProgression()
	updateLevelProgression()
	store("/appdata/puzzle/progression.pod", progression)
end
