local class = require("30log")

local Particle = class "Particle"
function Particle:init(x,y, life, dx, dy)
    self.alive = true
    self.x = x
    self.y = y
    self.life = life
    self.life_origin = life
    self.dx, self.dy = dx,dy
end

-- Do not manage yourself the particle speed, it's already done here.
-- Just tweak with dx/dy
function Particle:update(dt)
    if not self.alive then return end
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.life = self.life - dt
    if self.life < 0 then
        self.alive = false
    end
end

-- Override this function with the drawing you want.
function Particle:draw(dt)
end

return Particle