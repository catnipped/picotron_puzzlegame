--[[pod_format="raw",created="2024-05-12 07:45:28",modified="2024-11-27 14:19:37",revision=94]]
function drawWorkbench()
    drawCanvas(workbench.canvas)
    drawLineRestrictions()
    drawComponentBox(8, 8, 82, 254)
    drawToolbox(98, 8, 82, 42)
    drawTotal(98, 237)

    --draws the component under the mouse if one is held

    if mouse_mode[2] then
        cursor.draw = function()
            spr(workbench.held_component.sprite + workbench.held_component.rotations, mouse_val.x - 4, mouse_val.y - 4)
        end
        drawComponentInfo(workbench.held_component, 98, 58)
    end
    if mouse_mode[1] and tooltip then
        cursor.draw = function()
            drawComponentInfo(tooltip, mouse_val.x + 6, mouse_val.y)
        end
    end
    drawLevelInfo(200, 8)
end

function drawLevelInfo(x, y)
    print("\#2" .. "level:" .. blueprint.name, x, y, 0)
end

function drawCanvas(canvas)
    local offset_x, offset_y = canvas.x + grid_size, canvas.y + grid_size

    rectfill(
        offset_x - 4,
        offset_y - 4,
        offset_x + ((canvas.grid_width - 2) * grid_size) + 3,
        offset_y + ((canvas.grid_height - 2) * grid_size) + 3,
        40
    )
    drawCheckerBoard(offset_x, offset_y, canvas.grid_width - 2, canvas.grid_height - 2, 40, 38)
    --rounded corners
    spr(144, offset_x - 4, offset_y - 4)
    spr(145, offset_x + ((canvas.grid_width - 2) * grid_size) - 4, offset_y - 4)
    spr(152, offset_x - 4, offset_y + ((canvas.grid_height - 2) * grid_size) - 4)
    spr(153, offset_x + ((canvas.grid_width - 2) * grid_size) - 4, offset_y + ((canvas.grid_height - 2) * grid_size) - 4)

    drawBlueprint(offset_x, offset_y)

    drawPlacedComponents(workbench.placed_components)
    if show_values then
        drawPlacedValues(workbench.placed_components)
    end
    drawPlacementPreview()
end

function drawPlacedValues(components)
    for i in all(components) do
        if i.produces_power then
            local str = string_icon.power .. i.power
            rectfill(i.x + 3, i.y + 3, i.x + 13, i.y + 11, 0)
            print(str,
                i.x + 4,
                i.y + 4,
                10
            )
        elseif i.produces_compute then
            local string = string_icon.compute .. i.compute
            rectfill(i.x + 3, i.y + 3, i.x + 13, i.y + 11, 0)
            print(string,
                i.x + 4,
                i.y + 4,
                62
            )
        end
    end
end

function drawPlacementPreview()
    if proposed_placement and mouse_mode[2] then
        for x = 1, workbench.canvas.grid_width - 2 do
            for y = 1, workbench.canvas.grid_height - 2 do
                local cell = proposed_placement.collider[y + 1][x + 1]

                if cell > 0 then
                    local color = 7
                    if cell == 2 then
                        color = 8
                    elseif can_place == false then
                        color = 32
                    end
                    pal(7, color)
                    spr(0, workbench.canvas.x + x * grid_size, workbench.canvas.y + y * grid_size)
                    --	print(held_component_id,offset_x+x*grid_size,offset_y+y*grid_size,18)
                end
            end
        end
        pal(7, 7)
    end
end

function drawBlueprint(x, y)
    map(blueprint.canvas.bitmap[1].bmp, 1, 1, x, y, workbench.canvas.grid_width - 2, workbench.canvas.grid_height - 2)
end

function drawPlacedComponents(placed_components)
    for i in all(placed_components) do
        component_types[i.type].draw(i)
    end
end

function drawTotal(x, y)
    drawWindowMetal(x, y, 372, 25)

    --costs
    local cost = "" .. max(flr(workbench.cost_of_components), 0)
    local sell_target = "" .. workbench.sell_target
    local cost_x = x + 7
    local cost_y = y + 3
    line(cost_x - 2, cost_y, cost_x - 2, cost_y + 17, 39)
    spr(75, cost_x, cost_y)
    for i = 1, #cost do
        local nr = 0 .. sub(cost, i, i)
        spr(65 + nr, cost_x + (7 * i), cost_y)
    end
    if workbench.cost_of_components > workbench.sell_target then
        pal(11, 8)
        pal(38, 54)
        pal(39, 51)
        spr(155, cost_x, cost_y + 13)
    end
    spr(78, cost_x + ((#cost + 2) * 7), cost_y)
    for i = 1, #sell_target do
        local nr = 0 .. sub(sell_target, i, i)
        spr(65 + nr, cost_x + ((#cost + 2) * 7) + (7 * i), cost_y)
    end

    pal(11, 10)
    pal(38, 49)
    pal(39, 48)

    --power
    local power = "" .. flr(workbench.power_generated)
    local power_target = "" .. workbench.power_target
    local power_x = cost_x + 70
    local power_y = cost_y
    line(power_x - 2, power_y, power_x - 2, power_y + 17, 39)
    spr(77, power_x, power_y)

    for i = 1, #power do
        local nr = 0 .. sub(power, i, i)
        spr(65 + nr, power_x + (7 * i), power_y)
    end

    if workbench.power_generated < workbench.power_target then
        pal(11, 8)
        pal(38, 54)
        pal(39, 51)
        spr(154, power_x, power_y + 13)
    end
    spr(78, power_x + ((#power + 2) * 7), power_y)
    for i = 1, #power_target do
        local nr = 0 .. sub(power_target, i, i)
        spr(65 + nr, power_x + ((#power + 2) * 7) + (7 * i), power_y)
    end


    -- alien resource
    local compute = "" .. flr(workbench.compute_generated)
    local compute_x = power_x + 70
    local compute_y = power_y

    pal(11, 62)
    pal(38, 16)
    pal(39, 63)
    line(compute_x - 2, compute_y, compute_x - 2, compute_y + 17, 39)
    spr(79, compute_x, compute_y)
    for i = 1, #compute do
        local nr = 0 .. sub(compute, i, i)
        spr(65 + nr, compute_x + (7 * i), compute_y)
    end

    --restrictions
    if blueprint.restrictions then
        pal(11, 7)
        pal(38, 5)
        pal(39, 1)
        local rest_number = 0
        for r in all(blueprint.restrictions) do
            if r.check then
                rest_number += 1
            end
        end
        local rest_string = "" .. flr(rest_number)
        local rest_target = "" .. flr(#blueprint.restrictions)
        local rest_x = compute_x + 24
        local rest_y = compute_y
        line(rest_x - 2, rest_y, rest_x - 2, rest_y + 17, 39)
        spr(162, rest_x, rest_y)
        for i = 1, #rest_string do
            local nr = 0 .. sub(rest_string, i, i)
            spr(65 + nr, rest_x + (7 * i), rest_y)
        end
        spr(78, rest_x + ((#rest_string + 2) * 7), rest_y)
        for i = 1, #rest_target do
            local nr = 0 .. sub(rest_target, i, i)
            spr(65 + nr, rest_x + ((#rest_string + 2) * 7) + (7 * i), rest_y)
        end
    end


    --reset colors
    pal(38, 38)
    pal(39, 39)
    pal(11, 11)

    if not blueprint.ready then
        pal(11, 51)
        pal(38, 0)
        spr(86, x + 24, y + 42)
        pal(38, 38)
        pal(11, 11)
    else
        if every(120, 0, 30) then
            pal(11, 38)
            pal(38, 00)
        end
        spr(86, x + 24, y + 42)
        pal(38, 38)
        pal(11, 11)
    end
end

function drawComponentBox(x, y, width, height)
    drawWindowMetal(x, y, width, height)

    local x, y = x + 5, y + 5
    spr(142, x, y)
    spr(128 + component_buttons.page, x + 24, y)
    spr(143, x + 29, y)
    spr(128 + component_buttons.page_max, x + 35, y)

    for b in all(component_buttons.buttons) do
        if b.visible then
            b.draw(b)
        end
    end
end

function drawComponentInBox(i, x, y, w)
    local h = component_types[i].height * grid_size
    local info_string = workbench.placed_component_amount[i] .. " x " .. "$" .. component_types[i].price
    drawCheckerBoard(x + 4, y, component_types[i].width, component_types[i].height, 38, 39)
    spr(component_types[i].sprite, x + 4, y)

    --spr(111, x - 1, y)
    --pal(11, 39)
    --spr(128 + i, x, y + 1)
    --pal(11, 11)
    print(info_string, 1 + x + w - (#info_string * 5), y + h + 2, 40)
    line(x, y + h + 11, x + w, y + h + 11, 40)
end

function drawToolbox(x, y, width, height)
    drawWindowMetal(x, y, width, height)
    local current_tool = nil
    if mouse_mode[1] then
        current_tool = "Info"
    elseif mouse_mode[2] then
        current_tool = "Place"
    elseif mouse_mode[4] then
        current_tool = "Erase"
    end
    print("Tool:" .. current_tool, x + 3, y + 5, 11)
end

function drawToolButton(x, y, sprite, mode, key)
    local button_sprite = 102
    if mode then button_sprite = 104 end
    spr(button_sprite, x, y)
    if mode then
        pal(11, 39)
        pal(39, 11)
    end
    spr(sprite, x + 4, y + 4)
    pal(11, 11)
    pal(39, 39)
    spr(key, x, y + 17)
    --print(key,x-1,y+15,11)
end

function drawLineRestrictions()
    for r in all(blueprint.restrictions) do
        r.draw_fun(r)
    end
end

function drawLineRestrictionIcon(line_type, index, sprite, check, description, value)
    local pos = vec(workbench.canvas.x, workbench.canvas.y)
    if line_type == "col" then
        pos.x = pos.x + ((index - 1) * grid_size)
        pos.y = pos.y - 6
    end
    if line_type == "row" then
        pos.y = pos.y + ((index - 1) * grid_size)
        pos.x = pos.x - 6
    end
    spr(168, pos.x, pos.y)
    spr(sprite, pos.x, pos.y)
    if value then
        print(value, pos.x + 8, pos.y + 4, 10)
    end
    if check then
        spr(169, pos.x + 10, pos.y + 12)
    end
    if mouseWithinRect(pos.x, pos.y, 16, 16) then
        cursor.draw = function()
            drawGetInfo("Restriction", description, mouse_val.x + 6, mouse_val.y)
        end
    end
end

function drawGetInfo(title, description, x, y)
    local width = 90
    local height = 56

    rectfill(x + 2, y + 2, x + width + 2, y + height + 2, 1)
    rectfill(x, y, x + width, y + height, 39)
    rect(x, y, x + width, y + height, 38)
    rectfill(x, y, x + width, y + 10, 38)
    print(title, x + 3, y + 2, 7)
    print(description, x + 3, y + 14, 11)
end
