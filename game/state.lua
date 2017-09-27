--[[
    State class inspired by Haxeflixel's FlxState
]]--

local Layer = require("game.layer")

local State = Layer:extend("State")


function State:on_exit(next_state)
end

return State
