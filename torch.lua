local class = require("30loc")
local palette = require("palette")

local Torch = class()

function Torch:init(x,y,lit,backlight)
    self.x,self.y = x,y
    self.lit = lit
    self.backlight = backlight
end

function Torch:draw_backlight()
    print(self.backlight)
    if not self.lit or not self.backlight then return end
    love.graphics.setColor(palette[2])
    love.graphics.circle("fill",self.x,self.y, 10)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line",self.x,self.y, 13)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line",self.x,self.y, 17)
end

function Torch:draw()
    if not self.lit then return end
    love.graphics.setColor(255,0,0,255)
    love.graphics.circle("line",self.x,self.y,6)
end

return Torch
