local palette = require("palette")
local Player = require("player")
local Torch = require("objs.torch")
local ParticleManager = require("particle.manager")
local RoomStorage = require("room.storage")

local screen_canvas = nil
local world_canvas = nil
local reflect_shader = nil
local player = nil
local pico8 = nil

local room = nil
local roomStorage = RoomStorage()

local Shader = require("shdrs")

local sampling_factor = 0

function love.load()
    screen_canvas = love.graphics.newCanvas(240, 128)
    screen_canvas:setFilter("nearest")
    world_canvas = love.graphics.newCanvas(240, 64)
    world_canvas:setFilter("nearest")
    love.graphics.setLineStyle("rough")
    -- Putting colored limits to the reflection to avoid strange result
    reflect_shader = Shader("shdrs/reflect.glsl")
    world_canvas:setWrap( "clamp", "clamp" )
    player = Player(64, 25)
    pico8 = love.graphics.newFont("fnts/pico8.ttf", 4)
    love.graphics.setFont(pico8)
    room = roomStorage:get("test")
end

function draw_world()
    love.graphics.setCanvas(world_canvas)
    -- Unable to use map draw because placing objects between layers.
    love.graphics.clear(palette[1])

    -- room draw bg
    room:draw_bg()

    love.graphics.setColor(palette[4])
    -- particles
    ParticleManager:draw()
    -- draw player
    player:draw()

    -- draw fg
    room:draw_fg()
    -- ground
    love.graphics.setLineWidth(1)
    love.graphics.setColor(palette[4])
    love.graphics.line(0, 64, 240, 64)
end

function draw_reflect()
    love.graphics.setCanvas(screen_canvas)
    love.graphics.clear(palette[1])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(world_canvas, 0, 0)
    reflect_shader:use({
        {"time", love.timer.getTime()},
        {"sampling_factor", sampling_factor}
    })
    love.graphics.draw(world_canvas, 0, 128, 0, 1, -1)
    love.graphics.setShader()
end

function love.draw()
    draw_world()

    draw_reflect()

    love.graphics.setCanvas()
    love.graphics.draw(screen_canvas, 0, 0, 0, 4, 4)

    love.graphics.print(love.timer.getFPS(), 0, 1)
    love.graphics.print(player.state, 0, 7)
    love.graphics.print(player.x.." "..player.y.."("..(player.y+16)..")", 0, 13)
    love.graphics.print("Sampling factor : "..sampling_factor, 0, 19)
end

function love.keypressed(key)
    if key == "space" then
        sampling_factor = 0.33 - sampling_factor
    elseif key == "f1" then
        local screenshot = love.graphics.newScreenshot();
        screenshot:encode('png', os.time() .. '.png');
    elseif key == "f2" then
        reflect_shader:reload()
    end
end

function love.update(dt)
    room:update(dt)
    player:update(dt, room)
    if love.keyboard.isDown("left") then
        player.dx = -30
        player.facing = "left"
        player.walking = true
    elseif love.keyboard.isDown("right") then
        player.dx = 30
        player.facing = "right"
        player.walking = true
    else
        player.dx = 0
        player.walking = false
    end
    if love.keyboard.isDown("up") then
        player.looking = "up"
    elseif love.keyboard.isDown("down") then
        player.looking = "down"
    else
        player.looking = "normal"
    end

    if player.x < -8 then
        if room.transitions.down_left and player.y<=128 then
            room = roomStorage:get(room.transitions.down_left)
            player.x = 247
        elseif room.transitions.left and player.y<=63 then
            room = roomStorage:get(room.transitions.left)
            player.x = 247
        elseif room.transitions.up_left and player.y<=0 then
            room = roomStorage:get(room.transitions.up_left)
            player.x = 247
        else
            player.x = -8
        end
    elseif player.x > 248 then
        if room.transitions.down_right and player.y<=128 then
            room = roomStorage:get(room.transitions.down_right)
            player.x = 247
        elseif room.transitions.right and player.y<=63 then
            room = roomStorage:get(room.transitions.right)
            player.x = -7
        elseif room.transitions.up_right and player.y<=0 then
            room = roomStorage:get(room.transitions.up_right)
            player.x = -7
        else
            player.x = 248
        end
    end

    ParticleManager:update(dt)
end
