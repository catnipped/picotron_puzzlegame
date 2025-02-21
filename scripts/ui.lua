function buttonUpdate(b)
    b.clicked = false
    if mouseWithinRect(b.x + b.x_offset, b.y + b.y_offset, b.width, b.height) and b.visible then
        b.hover = true
        b.onHover(b)
        if mbtnp(0) then
            b.onClick(b)
            b.selected = true
        end
        if mbtn(0) then
            b.clicked = true
        end
    else
        b.hover = false
    end
    if not mouseWithinRect(b.x + b.x_offset, b.y + b.y_offset, b.width, b.height) and mbtnp(0) then
        b.selected = false
    end
end

function createButton(x, y, width, height)
    local button = {
        x = x,
        y = y,
        x_offset = 0,
        y_offset = 0,
        width = width,
        height = height,
        visible = true,
        hover = false,
        selected = false,
        onClick = function(self)
        end,
        onHover = function(self)
        end,
        draw = function(self)
        end
    }
    return button
end

