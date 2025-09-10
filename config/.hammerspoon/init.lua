-- Auto-reload config
hs.pathwatcher.new(hs.configdir, hs.reload):start()

-- Ctrl | Esc
local ctrl_down, send_esc = false, false

hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
    local down = e:getFlags().ctrl
    if down ~= ctrl_down then
        if down then
            ctrl_down, send_esc = true, true
        else
            if send_esc then
                hs.eventtap.event.newKeyEvent({}, "escape", true):post()
                hs.eventtap.event.newKeyEvent({}, "escape", false):post()
            end
            ctrl_down, send_esc = false, false
        end
    end
    return false
end):start()

hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function()
    if ctrl_down then send_esc = false end
    return false
end):start()
