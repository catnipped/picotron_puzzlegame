--[[pod_format="raw",created="2024-12-03 10:50:52",modified="2024-12-03 10:50:52",revision=0]]

function drawLevelSelect()
    drawWindowMetal(16, 16, 172, 172)
    print(welcome_message, 22, 22, 11)
    print(level_page + 1, 16, 250)

    -- progression stats
    local prog_x = 70
    local prog_y = 250
    spr(91, prog_x, prog_y - 4)
    print(progression.cleared_amount .. "/" .. #blueprint_library, prog_x + 20, prog_y, 7)
    prog_x = 120
    pal(3, 16)
    pal(11, 62)
    spr(91, prog_x, prog_y - 4)
    pal(3, 3)
    pal(11, 11)
    print(progression.cleared_with_blue_amount .. "/" .. #blueprint_library, prog_x + 20, prog_y, 7)

    drawLevelButtons(level_buttons)
end

function drawLevelButtons(buttons)
    for b in all(buttons) do
        b.draw(b)
    end
end

function drawBlueprintFile(x, y, level_number, hover, selected)
    if hover then
        rectfill(x - 3, y - 3, x + 33, y + 41, 0)
    end
    if progression.blueprints[level_number].unlocked then
        spr(160, x, y)
        print(level_number, x + 18, y + 3, 36)
        local bp = blueprint_library[level_number]
        print(bp.sell_target, x + 10, y + 15, 11)
        print(bp.power_target, x + 10, y + 29, 9)

        local name_colors = { 0, 7 }
        if selected then name_colors = { 7, 0 } end
        rectfill(horizontalCenter(bp.name, x + 10) - 2, y + 44, horizontalCenter(bp.name, x + 10) + #bp.name * 5 + 2,
            y + 53, name_colors[1])
        print(bp.name, horizontalCenter(bp.name, x + 10), y + 45, name_colors[2])

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
    else -- if not unlocked
        spr(161, x, y)
    end
end
