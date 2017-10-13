local class = require("30log")

local Controller = class "Controller"
Controller.init = {
    -- Used here as a filler
    _do_nothing =function() end,
    is_bound = false
}


function Controller:bind_to_handler(--[[handler]])
    self.is_bound = true
end

function Controller:unbind_to_handler(--[[handler]])
    self.is_bound = false
end

function Controller.update(--[[self, dt]])
end

return Controller
