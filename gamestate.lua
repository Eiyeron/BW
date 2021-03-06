local State = require("game.state")
local palette = require("palette")
local Player = require("player")
local RoomStorage = require("room.storage")
local Shader = require("shdrs")
local Textbox = require("textbox")
local Sequence = require("sequence")
local Subsequence = require("sequence.subsequence")
local Condition = require("sequence.condition")
local SimpleActions = require("sequence.simple")

local hsluv = require("hsluv")
local mathutil = require("mathutil")

local PaletteExport = require( "utils.palette_export" )

local GameState = State:extend("GameState")

local PlayerController = require( "input.playerController" )
local TextboxController = require( "input.textboxController" )

function GameState:init(game)
    self.super.init(self)
    self.game = game

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
    self.previous_palette = {}
    for i=1,4 do
        self.previous_palette[i] = {}
        for c=1,3 do
            self.previous_palette[i][c] = test[i][c]
        end
    end

    self.next_palette = nil
    self.palette_transition = 0
    self.palette_duration = 1 -- seconds

    self.player = Player(64, 128)
    self.player_controller = PlayerController(self.player)
    self.player_controller:bind_to_handler(game.input_handler)
    self.pico8 = love.graphics.newFont("fnts/pico8.ttf", 4)
    love.graphics.setFont(self.pico8)

    self.room_storage = RoomStorage()
    self.room = self.room_storage:get("test")
    self.room.player = self.player

    self.textbox = Textbox()
    self.textbox_controller = TextboxController(self.textbox)

    self:add(self.room)
    self:add(self.textbox)

    self.shader_time = 0
    self.sequence = Sequence({
        SimpleActions.Textbox(self,"Action sequence test", true),
        Subsequence({
            SimpleActions.Wait(self, .2, true),
            SimpleActions.Look(self, "down", .5),
            SimpleActions.Wait(self, .2, true),

        }),
        Condition("and", {
            SimpleActions.Textbox(self,{"This is a sequence", "The player only can make the textbox advance"}, true),
            Subsequence({
                SimpleActions.Move(self, "right", 96),
                SimpleActions.Wait(self, .2, true),
                SimpleActions.Look(self, "up", 1),
                SimpleActions.Wait(self, .2, true),
                SimpleActions.Move(self, "left", 96),
                SimpleActions.Wait(self, .2, true),
                SimpleActions.Look(self, "up", 1),
                SimpleActions.Wait(self, .2, true),
                SimpleActions.Move(self, "right", 48),
                SimpleActions.Look(self, "down", 2),
            })
        })
    })
end

function GameState:update(dt)
    self.shader_time = (self.shader_time + dt) % (math.pi * 2)
    self.super.update(self, dt)

    self.sequence:update(dt)
    if not self.sequence.started or  self.sequence.finished then
        if self.textbox_controller.is_bound and self.textbox.state == "disabled" then
            self.textbox_controller:unbind_to_handler(self.game.input_handler)
            self.player_controller:bind_to_handler(self.game.input_handler)
            self.player_controller:reset()
        end
    end
    self.player_controller:update(dt)

    if self.next_palette then
        self.palette_transition = self.palette_transition + dt
        if self.palette_transition > self.palette_duration then
            self.palette = self.next_palette
            self.next_palette = nil
            self.palette_transition = 0
        else
            local progress = self.palette_transition / self.palette_duration
            -- Sine interpolation = x:-> sin(x *π -π/2 )/2+0.5, x∈[0,1]
            progress = math.sin(progress*math.pi-math.pi/2)/2+0.5
            for i=1,4 do
                for c=1,3 do
                    self.palette[i][c] = mathutil.lerp(self.previous_palette[i][c], self.next_palette[i][c], progress)
                end
            end
        end
        self.effects_shader:send("palette",
            unpack(self.palette)
        )
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
        local a = hsluv.hsluv_to_rgb({
            math.random( 0,360 ),
            math.random( 0,100 ),
            math.random( i/4 * 100, (i+1)/4 * 100 )
        })
        pal[i+1] = {math.floor(a[1]*255), math.floor(a[2]*255), math.floor(a[3]*255)}
    end
    pal[5] = {0,0,0}
    for i=1,4 do
        for c=1,3 do
            self.previous_palette[i][c] = self.palette[i][c]
        end
    end
    self.next_palette = pal
    self.palette_transition = 0
end

function GameState:keypressed(key, scancode, isrepeat)
    self.super.keypressed(self, key, scancode, isrepeat)
    if key == "f1" then
        local screenshot = love.graphics.newScreenshot()
        screenshot:encode('png', os.time() .. '.png')
    elseif key == "f2" then
        self.effects_shader:reload()
        self.effects_shader:send("palette", unpack(self.palette))
    elseif key == "f3" then
        PaletteExport.drawPaletteToCanvas(self.palette):newImageData():encode('png', "palette"..os.time()..'.png')
        PaletteExport.addToSelection(self.palette)
    elseif key == "f4" then
        self:randomPalette()
    elseif key == "f5" then
        self.textbox:enqueue("The Game.","The Game (bis).")
        -- Stop the character
        self.player_controller:stopLeft()
        self.player_controller:stopRight()
        self.player_controller:unbind_to_handler(self.game.input_handler)
        self.textbox_controller:bind_to_handler(self.game.input_handler)
        self.textbox.state = "appearing"
    elseif key == "f6" then
        self.player_controller:reset()
        self.sequence.started = true
    elseif key == "f12" then
        error("Error handler test")
    end
end

function GameState:drawPalette()
    local pic = PaletteExport.drawPaletteToCanvas(self.palette)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(pic, 0,30)
end

function GameState:drawTextboxDebug()
    love.graphics.print("-Textbox-",0,120)
    if self.textbox.state == "active" then
        love.graphics.print("State: "..self.textbox.state.." ("..self.textbox.substate..")",0,127)
    else
        love.graphics.print("State: "..self.textbox.state,0,127)
    end
    love.graphics.print("Apearing: "..self.textbox.appearing_progress .. "/" .. self.textbox.appearing_speed,0,134)
    love.graphics.print("Dispearing: "..self.textbox.disappearing_progress .. "/" .. self.textbox.disappearing_speed,
        0,141)
    love.graphics.print("Index: "..self.textbox.current_text_index[1].."=>"..self.textbox.current_text_start[1],0,150)
    love.graphics.print("Timer: "..self.textbox.character_timer, 0, 157)
end

function GameState:draw()
    love.graphics.setCanvas(self.screen_canvas)
    love.graphics.push()
        love.graphics.clear(0,0,0)

        self.effects_shader:use({
            {"time", self.shader_time},
            {"sampling_factor", 0.5},
            {"amplitude", {0,0}},
            {"inverse", false}
        })
        self.room:draw()
        self.textbox:draw()
        -- Reflect
        self.effects_shader:use({
            {"time", self.shader_time},
            {"sampling_factor", 0.5},
            {"amplitude", {0,8/128}},
            {"inverse", true}
        })
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self.room.canvas,0,128,0,1,-1)
        love.graphics.draw(self.textbox.canvas,0,128,0,1,-1)
        love.graphics.setShader()

    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.screen_canvas,0,0, 0, 4,4)

    -- love.graphics.print(love.timer.getFPS(), 0, 1)
    -- love.graphics.print(self.player.state.."("..self.player.x..")", 0, 7)
    -- love.graphics.print(love.timer.getDelta(),0,13)

    -- self:drawTextboxDebug()
    -- self:drawPalette()
end

return GameState
