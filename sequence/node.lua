local class = require("30log")

local Node = class"Node"
Node.id = 0
function Node:init()
    self.id = Node.id
    Node.id = Node.id + 1
end

function Node:update(dt)
end

function Node:is_finished()
    return false
end

function Node:draw_debug()
end

return Node
