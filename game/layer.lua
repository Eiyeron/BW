--[[
    Similar to a FlxGroup.
]]

local class = require("30log")

local Layer = class "Layer"
function Layer:init(canvas)
    self.objects = {}
    self.canvas = canvas
end

function Layer:add(object)
    table.insert( self.objects,object )
end

function Layer:remove(obj)
    for i,v in ipairs(self.objects) do
        if v == obj then
            table.remove(self.objects, i)
            return
        end
    end
end

function Layer:update(dt)
    for _,object in ipairs(self.objects) do
        object:update(dt)
    end
end

function Layer:draw()
    local previous_canvas = love.graphics.getCanvas()

    if self.canvas then
        love.graphics.setCanvas(self.canvas)
        for _,object in ipairs(self.objects) do
            if object.draw then
                object:draw()
            end
        end
        love.graphics.setCanvas(previous_canvas)
        love.graphics.draw(self.canvas)
    else
        for _,object in ipairs(self.objects) do
            if object.draw then
                object:draw()
            end
        end
    end
end

function Layer:foreach(unary)
    for _,object in ipairs(self.objects) do
        unary(object)
    end
end

return Layer
