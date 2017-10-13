local class = require "30log"

local InputHandler = class "InputHandler"
InputHandler.init = {
    -- key -> function(self_object)
    press_commands = {},
    down_commands = {},
    up_commands = {}
}

function InputHandler:bind_press( button, func, target )
    self.press_commands[button] = {func = func, target = target}
end

function InputHandler:bind_down( button, func, target )
    self.down_commands[button] = {func = func, target = target}
end

function InputHandler:bind_up( button, func, target )
    self.up_commands[button] = {func = func, target = target}
end
function InputHandler:unbind_press( button )
    self.press_commands[button] = nil
end

function InputHandler:unbind_down( button )
    self.down_commands[button] = nil
end

function InputHandler:unbind_up( button )
    self.up_commands[button] = nil
end

function InputHandler:press(button)
    local bind = self.press_commands[button]
    if bind then
        bind.func(bind.target)
    end
end

function InputHandler:down(button)
    local bind = self.down_commands[button]
    if bind then
        bind.func(bind.target)
    end
end

function InputHandler:up(button)
    local bind = self.up_commands[button]
    if bind then
        bind.func(bind.target)
    end
end

return InputHandler
