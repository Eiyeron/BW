--[[
    Game container class.
    Inspired by HaxeFlixel.
]]

local class = require("30log")
local _LoveCallbacks = require("utils.love_callbacks")
local InputHandler = require("input.handler")


local Game = class "Game"
function Game:init(State)
    self.next_state = nil
    self.input_handler = InputHandler()
    love.update = function(dt) self:update(dt) end
    love.draw = function() self:draw() end

    -- Framerate limiter
    self.min_dt = 1/30
    self.next_time = love.timer.getTime()

    self.state = State(self)
    self:register_callbacks()
end

function Game:register_callbacks()
    for _,callback in ipairs(_LoveCallbacks) do
        if self[callback] then
            love[callback] = function(...) self[callback](self, ...) end
        elseif self.state[callback]
            and (type(self.state[callback]) == "function" or getmetatable(self.state[callback]).__call ~= nil) then

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

function Game:keypressed(key, scancode, isrepeat)
    if not self.isrepeat then
        self.input_handler:press(key)
    end
    self.input_handler:down(key)
    if self.state.keypressed then
        self.state:keypressed(key, scancode, isrepeat)
    end
end

function Game:keyreleased(key, scancode)
    self.input_handler:up(key)
    if self.state.keyreleased then
        self.state:keyreleased(key, scancode)
    end
end

-- To be called by GameState
function Game:switch_to(new_state)
    self.new_state = new_state
end

return Game
