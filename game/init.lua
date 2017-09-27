--[[
    Game container class.
    Inspired by HaxeFlixel.
]]

local class = require("30log")
local _LoveCallbacks = require("utils.love_callbacks")


local Game = class "Game"
function Game:init(state)
    self.state = state
    self:register_callbacks()
    self.next_state = nil
    love.update = function(dt) self:update(dt) end
    love.draw = function() self:draw() end

    -- Framerate limiter
    self.min_dt = 1/30
    self.next_time = love.timer.getTime()

end

function Game:register_callbacks()
    for i,callback in ipairs(_LoveCallbacks) do
        if self.state[callback] and (type(self.state[callback]) == "function" or getmetatable(self.state[callback]).__call ~= nil) then
            love[callback] = function(...) self.state[callback](self.state, ...) end
        else
            love[callback] = nil
        end
    end
end

function Game:update(dt)
    if self.state then self.state:update(dt) end
    -- State switch
    if self.next_state then
        self.state:on_exit(self.next_state)
        self.state = self.next_state
        self.next_state = nil
        self:register_callbacks()
    end

    self.next_time = self.next_time + self.min_dt
end

function Game:draw()
    if self.state then self.state:draw() end

    local cur_time = love.timer.getTime()
    if self.next_time <= cur_time then
        self.next_time = cur_time
        return
    end
    love.timer.sleep(self.next_time - cur_time)
end

-- To be called by GameState
function Game:switch_to(new_state)
    self.new_state = new_state
end

return Game
