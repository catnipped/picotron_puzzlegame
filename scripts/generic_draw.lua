function drawDebug()
    local memory = "M:" .. stat(0)
    local cpu = "CPU:" .. flr(stat(1) * 100)
    print(cpu, 480 - 5 * #cpu, 9, stat(1) + 6)
    print(memory, 480 - 5 * #memory, 1, stat(0) + 6)
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

function drawWindowGlass(x, y, width, height)
    rectfill(x, y, x + width - 1, y + height - 1, 0)
    --the sprite numbers
    local window_sprites = {
        164, 165,
        166, 167
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

function drawPillButton(x, y, width, hover, clicked, label)
    width = max(16, width)
    if clicked then
        sspr(159, 0, 0, 4, 16, x + 8, y, width - 16, 16)
        spr(157, x, y)             --left corner
        spr(158, x + width - 8, y) --right corner
    else
        sspr(151, 0, 0, 4, 16, x + 8, y, width - 16, 16)
        spr(149, x, y)             --left corner
        spr(150, x + width - 8, y) --right corner
    end
    if label then
        if clicked then y += 1 end
        print(label, x + 6, y + 4, 0)
        local color = 7
        if hover and clicked == false then color = 14 end
        print(label, x + 6, y + 3, color)
    end
end

function drawGetInfo(title, text, x, y, w)
    local width = w or 100
    local height = 16
    local longest_text = max(#title * 6, #text * 6)
    if longest_text < width then width = longest_text end
    local text_formatted, text_height = textwrap(text, width - 4)
    height += text_height


    x = mid(0, x, 474 - width)
    y = mid(0, y, 264 - height)

    --[[  rectfill(x + 2, y + 2, x + width + 2, y + height + 2, 1)
    rectfill(x, y, x + width, y + height, 39)
    rect(x, y, x + width, y + height, 38)
    ) ]]
    drawWindowGlass(x, y, width, height)
    rectfill(x + 1, y + 1, x + width - 2, y + 9, 37)
    print(title, x + 3, y + 2, 35)
    print(text_formatted, x + 3, y + 12, 17)
    return height --returns the calculated height
end

function drawComponentInfo(i, x, y, w)
    local w = w or 100
    local calculated_height = drawGetInfo(i.name, i.info, x, y, w)
    local y = y - 3
    local x = x + 1
    if i.produces_power then
        local string_for_calc = "$" .. i.price .. "#" .. i.power
        local calculated_width = #string_for_calc * 6
        drawWindowMetal(x, y + calculated_height, calculated_width + 6, 14)
        local str = "$" .. i.price
        local x2 = print(str, x + 4, y + 3 + calculated_height, 11)
        local str = string_icon.power .. i.power
        print(str, x2 + 2, y + 3 + calculated_height, 10)
    elseif i.produces_ichor then
        local string_for_calc = "$" .. i.price .. "#" .. i.ichor
        local calculated_width = #string_for_calc * 6
        drawWindowMetal(x, y + calculated_height, calculated_width + 6, 14)
        local str = "$" .. i.price
        local x2 = print(str, x + 4, y + 3 + calculated_height, 11)
        local str = string_icon.ichor .. i.ichor
        print(str, x2 + 2, y + 3 + calculated_height, 62)
    else
        local string_for_calc = "$" .. i.price
        local calculated_width = #string_for_calc * 6
        drawWindowMetal(x, y + calculated_height, calculated_width + 6, 14)
        local str = "$" .. i.price
        print(str, x + 4, y + 3 + calculated_height, 11)
    end
end

function horizontalCenter(s, middle) -- from pico 8 wiki
    -- screen center minus the
    -- string length times the
    -- pixels in a char's width,
    -- cut in half
    return middle - #s * 2
end

--from rosetta code, added conversion from line width in characters to pixels, and returns number of height of text in pixels
function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res + 1] = w
    end
    return res
end

function textwrap(text, width_in_pixels)
    linewidth = width_in_pixels / 5
    local spaceleft = linewidth
    local res = {}
    local line = {}

    for _, word in ipairs(splittokens(text)) do
        if #word + 1 > spaceleft then
            table.insert(res, table.concat(line, ' '))
            line = { word }
            spaceleft = linewidth - #word
        else
            table.insert(line, word)
            spaceleft = spaceleft - (#word + 1)
        end
    end

    table.insert(res, table.concat(line, ' '))
    return table.concat(res, '\n'), #res * 11
end
