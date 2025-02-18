--[[pod_format="raw",created="2024-12-17 11:40:19",modified="2024-12-17 11:40:37",revision=1]]
function initProgression(bp_lib)
    cheat = true
    local table = {
        cleared_amount = 0,
        cleared_with_blue_amount = 0,
        blueprints_starting_unlocks = 3,
        blueprints = {},
        components_starting_unlocks = 3,
        components_unlocks = 0
    }
    if cheat then
        table.blueprints_starting_unlocks = #bp_lib
        table.components_starting_unlocks = #component_library
    end
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
    --store("/appdata/powertile/progression.pod", progression)
end
