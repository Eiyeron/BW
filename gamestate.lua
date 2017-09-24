local State = require("game.state")
local palette = require("palette")
local Player = require("player")
local Torch = require("objs.torch")
local RoomStorage = require("room.storage")
local Shader = require("shdrs")
local Layer = require("game.layer")

local hsluv = require("hsluv")

local GameState = State:extend("GameState")
function GameState:init()
	self.super.init(self)

    self.screen_canvas = love.graphics.newCanvas(240, 128)
    self.screen_canvas:setFilter("nearest")

    love.graphics.setLineStyle("rough")
    -- Putting colored limits to the reflection to avoid strange result
    self.effects_shader = Shader("shdrs/palette_reflect.glsl")
    local test = {}
    for i=1,4 do
        test[i] = palette[i]
    end
    test[5] = {0,0,0}
    self.effects_shader:send("palette", unpack(test))
    self.palette = test
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

function GameState:randomPalette()
    local pal = {}
    for i=0,3 do
        local a = hsluv.hsluv_to_rgb({math.random( 0,360 ), math.random( 0,100 ), math.random( i/4 * 100, (i+1)/4 * 100 )})
        pal[i+1] = {math.floor(a[1]*255), math.floor(a[2]*255), math.floor(a[3]*255)}
    end
    pal[5] = {0,0,0}
    self.effects_shader:send("palette",
        unpack(pal)
    )
    self.palette = pal
end

function GameState:keypressed(key)
    if key == "f1" then
        local screenshot = love.graphics.newScreenshot();
        screenshot:encode('png', os.time() .. '.png');
    elseif key == "f2" then
        self.effects_shader:reload()
        self.effects_shader:send("palette", unpack(self.palette))
    elseif key == "f3" then
        self:addPaletteToSelection()
    elseif key == "f4" then
        self:randomPalette()
    end
end

function GameState:drawPalette()
    love.graphics.print("-Palette-", 0, 30)
    love.graphics.rectangle("line", 1, 64, 34, 34)
    for i=1,4 do
        love.graphics.setColor(255,255,255)
        love.graphics.print(string.format(
                "#%02X%02X%02X",
                self.palette[i][1],
                self.palette[i][2],
                self.palette[i][3]
            ),
            4, 30+6*i
        )
        love.graphics.setColor(unpack(self.palette[i]))
        love.graphics.rectangle("fill", 1 + 8*(i-1), 65, 8, 31)
    end
end

function GameState:addPaletteToSelection()
    local file = love.filesystem.newFile("palettes.txt", "a")
    local colors = {}
    for i=1,4 do
        colors[i] = string.format("#%02X%02X%02X", self.palette[i][1], self.palette[i][2], self.palette[i][3])
    end
    file:write(string.format("%s\n", table.concat(colors, ", ")))
    file:close()
end

function GameState:draw()
    love.graphics.setCanvas(self.screen_canvas)
    love.graphics.push()
        love.graphics.clear(0,0,0)

        self.effects_shader:use({
            {"time", love.timer.getTime()},
            {"sampling_factor", 0.5},
            {"amplitude", {0,0}},
            {"inverse", false}
        })
        self.room:draw()
        -- Reflect
        self.effects_shader:use({
            {"time", love.timer.getTime()},
            {"sampling_factor", 0.5},
            {"amplitude", {0,8/128}},
            {"inverse", true}
        })
        love.graphics.draw(self.room.canvas,0,128,0,1,-1)
        love.graphics.setShader()

    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.screen_canvas,0,0, 0, 4,4)

    love.graphics.print(love.timer.getFPS(), 0, 1)
    love.graphics.print(self.player.state.."("..self.player.x..")", 0, 7)
    love.graphics.print(love.timer.getDelta(),0,13)

    self:drawPalette()
end

return GameState