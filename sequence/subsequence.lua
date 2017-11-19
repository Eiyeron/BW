local Node = require("sequence.node")

local Subsequence = Node:extend"Subsequence"

local default_routine = function() return true end
local and_routine = function(accumulator, current_node) return accumulator and current_node:is_finished() end
local or_routine = function(accumulator, current_node) return accumulator or current_node:is_finished() end


function Subsequence:init(nodes)
    Node.init(self)
    self.nodes = nodes
    self.num_done = 0
end

function Subsequence:update(dt)
    if self:is_finished() then return end
    for _,node in ipairs(self.nodes) do
        node:update(dt)
        if not node:is_finished() then return end
    end

end

function Subsequence:is_finished()
    if #self.nodes == 0 then return true end
    self.num_done = 0
    for _,node in ipairs(self.nodes) do
        if not node:is_finished() then
            return false
        end
    end
    return true
end

function Subsequence:draw_debug()
    local selected_node = nil
    local is_finished = self:is_finished()
    local alpha = is_finished and 0.1 or 0.3
    local color = {0,0,1}
    imgui.PushStyleColor("Header",color[1],color[2],color[3], alpha)
    imgui.PushStyleColor("HeaderHovered",color[1],color[2],color[3], alpha+0.1)
    imgui.PushStyleColor("HeaderActive",color[1],color[2],color[3], alpha+0.2)
    if imgui.TreeNodeEx("Subsequence "..self.id, {"Framed"}) then
        if #self.nodes > 0 and self.num_done > 0 and not is_finished then
            imgui.SameLine()
            imgui.ProgressBar((self.num_done+0.0)/#self.nodes)
        end
        -- imgui.Text("Finished "..tostring(self:is_finished()))
        for k,node in ipairs(self.nodes) do
            local current_selected_node = node:draw_debug()
            if current_selected_node then
                selected_node = current_selected_node
            end
        end
        imgui.TreePop()
    elseif #self.nodes > 0 and self.num_done > 0 and not is_finished then
        imgui.SameLine()
        imgui.ProgressBar(self.num_done/#self.nodes)
    end
    imgui.PopStyleColor(3)

    if imgui.IsItemClicked() then
        selected_node = self
    end
    return selected_node
end

return Subsequence
