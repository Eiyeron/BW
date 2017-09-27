local class = require("30log")
local Particle = require("particle")

ParticleManager = class "ParticleManager"
function ParticleManager:init()
    self.parts = {}
end

function ParticleManager:update(dt)
    for _, part in ipairs(self.parts) do
        part:update(dt)
    end
    -- Dead particle removal
    -- Done after the update iteration to avoid skipping elements
    for i = #self.parts, 1, -1 do
        if not self.parts[i].alive then
            table.remove(self.parts, i)
        end
    end
end

function ParticleManager:draw()
    for _, part in pairs(self.parts) do
        part:draw(dt)
    end
end

function ParticleManager:add(part)
    self.parts[#self.parts + 1] = part
end

local pm = ParticleManager()

return pm
