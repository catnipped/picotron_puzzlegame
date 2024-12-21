--[[pod_format="raw",created="2024-12-17 11:40:19",modified="2024-12-17 11:40:37",revision=1]]
function initProgression(lib)
	local table = {
		cleared_amount = 0,
		cleared_with_blue_amount = 0,
		blueprints = {},
	}
	for i = 1, #lib do
		table.blueprints[i] = {
			clear = false,
			clear_with_blue = false,
		}
	end
	return table
end

function updateProgression()
	progression.cleared_amount = 0
	progression.cleared_with_blue_amount = 0
	for i in all(progression.blueprints) do
		if i.clear then
			progression.cleared_amount += 1
		end
		if i.clear_with_blue then
			progression.cleared_with_blue_amount += 1
		end
	end
end

function saveProgression()
	updateProgression()
	store("/appdata/puzzle/progression.pod", progression)
end
