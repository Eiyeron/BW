local class = require("30log")
local palette = require("palette")

local Torch = class "Torch"

local ParticleManager = require("particle.manager")
local Particle = require("particle")

-- [[ Torch particle ]] --

local TorchParticle = Particle:extend("TorchParticle")

function TorchParticle:init(x,y)
    self.super.init(self, x,y, 1/3, 0,-24-math.random(14))
    self.color = palette[math.random(3,4)]
    self.radius = math.random(2, 3)
end

function TorchParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x,self.y,self.radius*(self.life / self.life_origin))
end

-- [[ Torch ]] -- 

function Torch:init(x,y,lit,backlight)
    self.x,self.y = x,y
    self.lit = lit
    self.backlight = backlight

    self.particle_accumulator = 0

    self.random = love.math.newRandomGenerator()
    self.random_timer = self.random:random(0.3,0.6)

    self.backlight_radius = self.random:random(10, 12)

end

function Torch:draw_backlight()
    if not self.lit or not self.backlight then return end
    love.graphics.setColor(palette[2])
    love.graphics.circle("fill",self.x,self.y, self.backlight_radius)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line",self.x,self.y, self.backlight_radius + 3)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line",self.x,self.y, self.backlight_radius + 7)

end

function Torch:update(dt)
    if self.lit then
        self.particle_accumulator = self.particle_accumulator + dt
        while self.particle_accumulator >= 1/60 do
            self.particle_accumulator = self.particle_accumulator - 1/60
            ParticleManager:add(TorchParticle(self.x+math.random(-3,3),self.y +math.random(-3,0)))
        end
    end

    if self.backlight then
        self.random_timer = self.random_timer - dt
        if self.random_timer < 0 then
            self.random_timer = self.random:random(0.3,0.6)
            self.backlight_radius = self.random:random(10, 12)
        end
    end
end

function Torch:draw()
end

return Torch
