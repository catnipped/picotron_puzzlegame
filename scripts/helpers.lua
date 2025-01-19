--[[pod_format="raw",created="2024-05-12 07:37:40",modified="2024-05-12 09:16:38",revision=83]]
function every(duration, offset, period)
    local frames = flr(time() * 60)
    local offset = offset or 0
    local period = period or 1
    local offset_frames = frames + offset
    return offset_frames % duration < period
end

function lerp(a, b, t)
    return a + t * (b - a)
end

function getComponentFromCell(cell)
    local id = getCanvasVal(cell.x, cell.y)

    if id > 1 then
        for i in all(workbench.placed_components) do
            if i.id == id then
                return i
            end
        end
    end
end

function tableContainsVal(table, value)
    for y = 1, #table do
        if count(table[y], value) > 0 then
            return true
        end
    end
    return nil
end

function init2dTable(w, h, val)
    local val = val or 0
    local table = {}
    for y = 1, h do
        table[y] = {}
        for x = 1, w do
            table[y][x] = val
        end
    end
    return table
end

function rotateMatrix(m)
    local rotated = {}
    for c, m_1_c in ipairs(m[1]) do
        local col = { m_1_c }
        for r = 2, #m do
            col[r] = m[r][c]
        end
        table.insert(rotated, 1, col)
    end
    return rotated
end

--helper function to copy a whole table (recursively)
function tablecopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[tablecopy(orig_key)] = tablecopy(orig_value)
        end
        setmetatable(copy, tablecopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function updateMouse()
    mbtn_update()
    mouse_val.x, mouse_val.y, mouse_val.button, mouse_val.wheel_x, mouse_val.wheel_y = mouse()
end

function mouseWithinRect(x, y, w, h)
    if mouse_val.x > x
        and mouse_val.x < x + w
        and mouse_val.y > y
        and mouse_val.y < y + h then
        return true
    else
        return false
    end
end

function alignCenter(object_length, rectangle_length)
    return flr((rectangle_length / 2) - (object_length / 2))
end
