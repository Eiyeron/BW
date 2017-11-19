local Node = require("sequence.node")

local Action = Node:extend"Action"

function Action:init(coro)
    Node.init(self)
    self.coroutine = coro
    self.progress = nil -- progress ∈ [0;1]
end

function Action:update(dt)
    if self:is_finished() then return end
    local res,error = coroutine.resume( self.coroutine, self)
    if error then print(error) end
end

function Action:is_finished()
    if not self.coroutine then return true end
    return coroutine.status(self.coroutine) == "dead"
end

function Action:draw_debug()
    local selected_node = nil
    local is_finished = self:is_finished()
    local alpha = is_finished and 0.1 or 0.3
    imgui.PushStyleColor("Header", 1,1,1, alpha)
    imgui.PushStyleColor("HeaderHovered", 1,1,1, alpha + 0.1)
    imgui.PushStyleColor("HeaderActive", 1,1,1, alpha + 0.2)
    local name = self.name or "Action "..self.id
    if imgui.TreeNodeEx(name, {"Framed"}) then
        if self.progress and not is_finished then
            imgui.SameLine()
            imgui.ProgressBar(self.progress)
        end
        --[[
            if self.coroutine then
                imgui.Text(coroutine.status(self.coroutine))
            else
                imgui.Text("-No action-")
            end
        ]]
        imgui.TreePop()
    elseif self.progress and not is_finished then
        imgui.SameLine()
        imgui.ProgressBar(self.progress)
    end
    imgui.PopStyleColor(3)

    return selected_node
end

return Action
