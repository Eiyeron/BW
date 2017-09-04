local class = require("30loc")
local palette = require("palette")

local Torch = class "Torch"

local ParticleManager = require("particle.manager")
local Particle = require("particle")

local TorchParticle = Particle:extend("TorchParticle")

function TorchParticle:init(x,y)
    self.super:init(x,y,1/3,0,-24-math.random(14))
    self.color = palette[math.random(3,4)]
    self.radius = math.random(2, 3)
end

function TorchParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x,self.y,self.radius*(self.life / self.life_origin))
end

function Torch:init(x,y,lit,backlight)
    self.x,self.y = x,y
    self.lit = lit
    self.backlight = backlight
    self.particle_accumulator = 0
end

function Torch:draw_backlight()
    if not self.lit or not self.backlight then return end
    love.graphics.setColor(palette[2])
    love.graphics.circle("fill",self.x,self.y, 10)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line",self.x,self.y, 13)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line",self.x,self.y, 17)

end

function Torch:update(dt)
    self.particle_accumulator = self.particle_accumulator + dt
    while self.particle_accumulator > 1/60 do
        self.particle_accumulator = self.particle_accumulator - 1/60
        ParticleManager(TorchParticle(self.x+math.random(-3,3),self.y - 2+math.random(-2,2)))
    end
end

function Torch:draw()
    if not self.lit then return end
    -- TODO : debug, replace with particles
    love.graphics.setColor(255,0,0,255)
    love.graphics.circle("line",self.x,self.y,6)
end

return Torch
