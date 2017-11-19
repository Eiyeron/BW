local class = require("30log")

local Sequence = class"Sequence"
function Sequence:init(nodes)
    self.started = false
    self.nodes = nodes
    self.finished = false
end

function Sequence:update(dt)
    if not self.started and not self.finished then return end
    for _,node in ipairs(self.nodes) do
        node:update(dt)
        if not node:is_finished() then return end
    end
    self.finished = true
end

return Sequence
