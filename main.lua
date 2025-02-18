--[[pod_format="raw",created="2024-05-12 07:37:40",modified="2024-05-12 09:16:38",revision=93]]

include("scripts/game_init.lua")
include("scripts/ui.lua")
include("scripts/progression.lua")
include("scripts/blueprint_library.lua")
include("scripts/component_library.lua")
include("scripts/generic_draw.lua")
include("scripts/level_select_draw.lua")
include("scripts/level_select_update.lua")
include("scripts/level_select_init.lua")
include("scripts/workbench_init.lua")

include("scripts/workbench_draw.lua")
include("scripts/workbench_update.lua")
include("scripts/helpers.lua")
include("includes/pancelor_mouse.lua")


function _init()
    --set palette
    poke4(0x5000, get(fetch "/ram/cart/pal/0.pal"))
    palt(0, false)
    palt(15, true)

    --set font
    poke(0x4000, get(fetch "/system/fonts/lil_mono.font"))
    --poke(0x4000, get(fetch("includes/enias_font.font")))

    component_types = initComponentTypes() -- generates exhaustive table of each type of component, using the library

    --tile size of the canvas, components etc
    grid_size = 16

    --for storing the mouse position and whether the a component is picked up
    mouse_val = {
        x = 0,
        y = 0,
        button = 0
    }

    -- for all clickable buttons
    buttons = {}
    popups = {}
    cursor = {}

    -- load progression save file or init if nil
    --progression = fetch("/appdata/powertile/progression.pod")
    if progression == nil then
        mkdir("/appdata/powertile")
        mkdir("/appdata/powertile/blueprint_solutions")
        progression = initProgression(blueprint_library)
        updateLevelProgression()
        store("/appdata/powertile/progression.pod", progression)
    end

    -- set start screen
    current_screen = "level select"
    initLevelSelect()

    tooltip = nil
end

function _update()
    tooltip = nil
    cursor = {}
    updateMouse()
    if current_screen == "level select" then
        updateLevelSelect()
    end
    if current_screen == "workbench" then
        updateWorkbench()
    end
    if #popups > 0 then
        buttonUpdate(popups[#popups]) --only update the last one if multiples
    else
        for b in all(buttons) do
            buttonUpdate(b)
        end
    end
end

function _draw()
    if current_screen == "level select" then
        cls(21)
        drawLevelSelect()
    end
    if current_screen == "workbench" then
        cls(21)
        drawWorkbench()
    end


    for b in all(buttons) do
        if b.visible then
            b.draw(b)
        end
    end

    if #popups > 0 then
        local p = popups[#popups] --only draw the last one if multiples
        p.draw(p)
    end

    if cursor.draw then
        cursor.draw()
    end
    --debug
    --drawDebug()
end

--error explorer thing for debugging
include("includes/error_explorer.lua")
