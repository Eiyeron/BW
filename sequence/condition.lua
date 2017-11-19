local Node = require("sequence.node")

local Condition = Node:extend"Condition"

local default_routine = function() return true end
local and_routine = function(accumulator, current_node) return accumulator and current_node:is_finished() end
local or_routine = function(accumulator, current_node) return accumulator or current_node:is_finished() end


function Condition:init(condition, nodes)
    Node.init(self)
    self.nodes = nodes
    self.condition = condition
    self.selected_condition = default_routine
    self.num_done = 0
    if self.condition == "or" then self.selected_condition = or_routine
    elseif self.condition == "and" then self.selected_condition = and_routine end

end

function Condition:update(dt)
    if self:is_finished() then return end
    for _,node in ipairs(self.nodes) do
        node:update(dt)
    end

end

function Condition:is_finished()
    if #self.nodes == 0 then return true end
    self.num_done = 0
    local accumulator = self.nodes[1]:is_finished()
    if self.nodes[1]:is_finished() then self.num_done = self.num_done + 1 end
    local i = 2
    while i <= #self.nodes do
        accumulator = self.selected_condition(accumulator, self.nodes[i])
        if self.nodes[i]:is_finished() then self.num_done = self.num_done + 1 end
        i = i + 1
    end
   return accumulator
end

function Condition:draw_debug()
    local selected_node = nil
    local is_finished = self:is_finished()
    local alpha = is_finished and 0.1 or 0.3
    local color = {0,0,0}
    if self.condition == "or" then
        color = {1,0,0}
    elseif self.condition == "and" then
        color = {0,1,0}
    end
    imgui.PushStyleColor("Header",color[1],color[2],color[3], alpha)
    imgui.PushStyleColor("HeaderHovered",color[1],color[2],color[3], alpha+0.1)
    imgui.PushStyleColor("HeaderActive",color[1],color[2],color[3], alpha+0.2)
    if imgui.TreeNodeEx(string.upper(self.condition).." Condition "..self.id, {"Framed"}) then
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

return Condition
