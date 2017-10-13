--[[
    State class inspired by Haxeflixel's FlxState
]]--

local Layer = require("game.layer")

local State = Layer:extend("State")

function State.on_exit(--[[self, next_state]])
end

function State.keypressed(--[[self, key, scancode, isrepeat]])
end

return State
