--[[ usage:
include "pancelor-mouse.lua"

function _update()
    mbtn_update()

    if mbtnp(0) then notify("LMB pressed "..time()) end
    if mbtnr(1) then notify("RMB released "..time()) end
    if mbtn(2) then notify("MMB held "..time()) end

    -- advanced: examine full bitfield:
    if mbtnp()&3==3 then notify("LMB+RMB simul-press :O "..time()) end
end
]]

-- mouse state bitfields
local _mbtn,_mbtnp,_mbtnr = 0,0,0

local function mbtn_helper(bits, n)
    -- "not" required b/c "or" branch can be false
    return not n
        and bits
        or bits&(1<<n)~=0
end

-- n: mouse button index; 0=LMB, 1=RMB, 2=MMB.
-- if called with no params, returns bitfield
function mbtn( n) return mbtn_helper(_mbtn,n) end
function mbtnp( n) return mbtn_helper(_mbtnp,n) end
function mbtnr( n) return mbtn_helper(_mbtnr,n) end

-- call this at the start of _update()
function mbtn_update()
    local _,_,now = mouse()
    _mbtnp,_mbtnr = now&~_mbtn,~now&_mbtn
    _mbtn = now
end