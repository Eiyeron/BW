local class = require("30log")
local sti = require("sti")
local palette = require("palette")

-- Find a way to automatically register objects?
local Torch = require("objs.torch")
local Stair = require("objs.stair")

local object_assert_message_format = "%s : Object #%d (%s) %s"

local Room = class "Room"

function Room:init(tileset_path)
    self.torchs = {}
    self.stairs = {}
    self.transitions = {}

    self.map = sti(tileset_path)
    for _, layer in ipairs(self.map.layers) do
        assert(layer.name == "bg" or layer.name == "fg" or layer.name == "objects")
    end

    -- object loading. Dumb but works
    for _, object in ipairs(self.map.layers.objects.objects) do
        assert(
            object.type ~= nil and object.type ~= "",
            string.format(object_assert_message_format, tileset_path, object.id, object.name or "<unnamed>", "doesn't have a type.")
        )
        local otype = string.lower(object.type)
        -- Torch
        if otype == "torch" then
            self.torchs[#self.torchs + 1] = Torch(
                math.floor(object.x + object.width / 2),
                object.y - object.height,
                object.properties.lit,
                object.properties.backlight
            )
        elseif otype == "stair" then
            assert(object.shape == "polyline", string.format(object_assert_message_format, tileset_path, object.id, object.name or "<unnamed>", "isn't a polyline."))
            -- Making sure to not see the polyline
            object.visible = false

            -- Creating the object
            local lowest_point = object.polyline[1].y > object.polyline[2].y and object.polyline[1] or object.polyline[2]
            local highest_point = object.polyline[1].y < object.polyline[2].y and object.polyline[1] or object.polyline[2]

            local start_x = object.polyline[1].x
            local end_x = object.polyline[2].x
            local bottom_y = lowest_point.y
            local orientation = lowest_point.x > highest_point.x and "right" or "left"
            
            self.stairs[#self.stairs + 1] = Stair(start_x, end_x, bottom_y, orientation)
        end
    end

    for key,value in pairs(self.map.properties) do
        local normalized_key = string.lower(key)
        if normalized_key == "left" or normalized_key == "right" then
            self.transitions[normalized_key] = value
        end
    end
end

function Room:update(dt)
    for i, torch in ipairs(self.torchs) do
        torch:update(dt)
    end
end

function Room:draw_bg()
    love.graphics.setColor(255,255,255)
    for i, torch in pairs(self.torchs) do
        torch:draw_backlight()
    end
    love.graphics.setColor(255,255,255)
    self.map:drawLayer(self.map.layers.bg)
    love.graphics.setColor(255,255,255)
    self.map:drawLayer(self.map.layers.objects)
    for i, torch in pairs(self.torchs) do
        torch:draw()
    end

    for i, stair in pairs(self.stairs) do
        stair:draw()
    end    
end

function Room:draw_fg()
    love.graphics.setColor(255,255,255)
    self.map:drawLayer(self.map.layers.fg)
end

return Room
