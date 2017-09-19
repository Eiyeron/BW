local State = require("game.state")
local palette = require("palette")
local Player = require("player")
local Torch = require("objs.torch")
local RoomStorage = require("room.storage")
local Shader = require("shdrs")
local Layer = require("game.layer")

local GameState = State:extend("GameState")
function GameState:init()
	self.super.init(self)

    self.screen_canvas = love.graphics.newCanvas(240, 128)
    self.screen_canvas:setFilter("nearest")

    love.graphics.setLineStyle("rough")
    -- Putting colored limits to the reflection to avoid strange result
    self.reflect_shader = Shader("shdrs/reflect.glsl")
    self.player = Player(64, 25)
    self.pico8 = love.graphics.newFont("fnts/pico8.ttf", 4)
    love.graphics.setFont(self.pico8)

    self.room_storage = RoomStorage()
    self.room = self.room_storage:get("test")
    self.room.player = self.player

    self:add(self.room)

end

function GameState:update(dt)
    self.super.update(self, dt)
    -- self.room:update(dt)
    -- self.player:update(dt, self.room)
    if love.keyboard.isDown("left") then
        self.player.dx = -30
        self.player.facing = "left"
        self.player.walking = true
    elseif love.keyboard.isDown("right") then
        self.player.dx = 30
        self.player.facing = "right"
        self.player.walking = true
    else
        self.player.dx = 0
        self.player.walking = false
    end
    if love.keyboard.isDown("up") then
        self.player.looking = "up"
    elseif love.keyboard.isDown("down") then
        self.player.looking = "down"
    else
        self.player.looking = "normal"
    end

    if self.player.x < -8 then
        if self.room.transitions.down_left and self.player.y<=128 then
            self.room = self.room_storage:get(self.room.transitions.down_left)
            self.player.x = 247
        elseif self.room.transitions.left and self.player.y<=63 then
            self.room = self.room_storage:get(self.room.transitions.left)
            self.player.x = 247
        elseif self.room.transitions.up_left and self.player.y<=0 then
            self.room = self.room_storage:get(self.room.transitions.up_left)
            self.player.x = 247
        else
            self.player.x = -8
        end
    elseif self.player.x > 248 then
        if self.room.transitions.down_right and self.player.y<=128 then
            self.room = self.room_storage:get(self.room.transitions.down_right)
            self.player.x = 247
        elseif self.room.transitions.right and self.player.y<=63 then
            self.room = self.room_storage:get(self.room.transitions.right)
            self.player.x = -7
        elseif self.room.transitions.up_right and self.player.y<=0 then
            self.room = self.room_storage:get(self.room.transitions.up_right)
            self.player.x = -7
        else
            self.player.x = 248
        end
    end

end

function GameState:keypressed(key)
    if key == "f1" then
        local screenshot = love.graphics.newScreenshot();
        screenshot:encode('png', os.time() .. '.png');
    elseif key == "f2" then
        self.reflect_shader:reload()
    elseif key == "f3" then
        assert(false, "Test")
    end
end

function GameState:draw()
    love.graphics.setCanvas(self.screen_canvas)
    love.graphics.push()
        love.graphics.clear(palette[1])

        self.room:draw()
        -- Reflect
        self.reflect_shader:use({
            {"time", love.timer.getTime()},
            {"sampling_factor", 0.5}
        })
        love.graphics.draw(self.room.canvas,0,128,0,1,-1)
        love.graphics.setShader()

    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(self.screen_canvas,0,0, 0, 4,4)

    love.graphics.print(love.timer.getFPS(), 0, 1)
    love.graphics.print(self.player.state.."("..self.player.x..")", 0, 7)
    love.graphics.print(love.timer.getDelta(),0,13)

end

return GameState