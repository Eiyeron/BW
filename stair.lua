local class = require("30log")

local Stair = class "Stair"

function Stair:init(start_x, end_x, bottom_y, orientation)
    self.start_x, self.end_x = start_x, end_x
    self.bottom_y = bottom_y
    self.orientation = orientation
end

-- DEBUG
function Stair:draw()
    love.graphics.setColor(255, 0, 0, 255)
    if self.orientation == "left" then
        love.graphics.line(
            self.start_x,
            self.bottom_y,
            self.end_x,
            self.bottom_y - (self.end_x - self.start_x)
        )
    elseif self.orientation == "right" then
        love.graphics.line(
            self.start_x,
            self.bottom_y - (self.end_x - self.start_x),
            self.end_x,
            self.bottom_y
        )
    end
end

return Stair
