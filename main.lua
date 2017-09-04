local sti = require("sti")
local m = sti("maps/test.lua")
local palette = require("palette")
local Player = require("player")
local Torch = require("torch")

local screen_canvas = nil
local world_canvas = nil
local reflect_shader = nil
local player = nil
local pico8 = nil
local torchs = {}

local shader = [[
    // Why the heck do I have to invert the colors manually like this?...
    vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec3 color = Texel(texture, texture_coords).rgb;
        if (color.r <= 0/255.)
            return vec4(255/255.,255/255.,255/255.,1);
        else if (color.r <= 95/255.)
            return vec4(194/255.,195/255.,199/255.,1);
        else if (color.r <= 194/255.)
            return vec4(95/255.,87/255.,79/255.,1);
        else if (color.r <= 255/255.)
            return vec4(0,0,0,1);
            
        return vec4(color,1);
    }

]]

function love.load()
    screen_canvas = love.graphics.newCanvas(240,128)
    screen_canvas:setFilter("nearest")
    world_canvas = love.graphics.newCanvas(240,64)
    world_canvas:setFilter("nearest")
    love.graphics.setLineStyle("rough")
    reflect_shader = love.graphics.newShader(shader)
    player = Player(64,25)
    pico8 = love.graphics.newFont("fnts/pico8.ttf",4)
    love.graphics.setFont(pico8)

    for _,object in pairs(m.layers.objects.objects) do
        for key,value in pairs(object.properties) do
            local t = value
            if t == true or t == false then t = t and "true" or "false" end
            print(key.."=>"..t)
        end
        if object.type == "torch" then
            torchs[#torchs+1] = Torch(math.floor(object.x+object.width/2), object.y-object.height, object.properties.lit, not object.properties.decorative)
        end
    end
end

function draw_world()
    love.graphics.setCanvas(world_canvas)
    love.graphics.clear(palette[1])
    love.graphics.setColor(palette[4])
    -- m:draw()
    for i,torch in pairs(torchs) do
        torch:draw_backlight()
    end
    love.graphics.setColor(palette[4])
    m:drawLayer(m.layers.bg)
    m:drawLayer(m.layers.objects)
    for i,torch in pairs(torchs) do
        torch:draw()
    end
    -- draw player
    love.graphics.setColor(palette[4])
    player:draw()
    -- draw fg
    love.graphics.setColor(palette[4])
    m:drawLayer(m.layers.fg)
    -- ground
    love.graphics.setLineWidth(1)
    love.graphics.setColor(palette[4])
    love.graphics.line(0,64,240,64)
end

function draw_reflect()
    love.graphics.setCanvas(screen_canvas)
    love.graphics.clear(palette[1])
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(world_canvas, 0,0)
    love.graphics.setShader(reflect_shader)
    love.graphics.draw(world_canvas, 0,128, 0, 1,-1)
    love.graphics.setShader()
end

function love.draw()
    draw_world()

    draw_reflect()

    love.graphics.setCanvas()
    love.graphics.draw(screen_canvas, 0,0, 0, 4,4)
end

function love.update(dt)
    m:update()
    player:update(dt)
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
        player.looking ="up"
    elseif love.keyboard.isDown("down") then
        player.looking ="down"
    else
        player.looking ="normal"
    end
    
end