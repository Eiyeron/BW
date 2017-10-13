local Controller = require("input.controller")

local PlayerController = Controller:extend("PlayerController")
function PlayerController:init(player)
    self.player = player
    self.up,self.down, self.left, self.right = false, false, false, false
    self.axis_x = 0
    self.axis_y = 0
end

function PlayerController:startLeft()
    self.left = true
end

function PlayerController:startRight()
    self.right = true
end

function PlayerController:stopRight()
    self.right = false
end

function PlayerController:stopLeft()
    self.left = false
end


function PlayerController:startUp()
    self.up = true
end

function PlayerController:startDown()
    self.down = true
end

function PlayerController:stopDown()
    self.down = false
end

function PlayerController:stopUp()
    self.up = false
end



function PlayerController:bind_to_handler(handler)
    self.super.bind_to_handler(self, handler)
    handler:bind_down("left", self.startLeft, self)
    handler:bind_down("right", self.startRight, self)
    handler:bind_up("left", self.stopLeft, self)
    handler:bind_up("right", self.stopRight, self)

    handler:bind_down("up", self.startUp, self)
    handler:bind_down("down", self.startDown, self)
    handler:bind_up("up", self.stopUp, self)
    handler:bind_up("down", self.stopDown, self)
end

function PlayerController:unbind_to_handler(handler)
    self.super.unbind_to_handler(self, handler)
    handler:unbind_down("left")
    handler:unbind_down("right")
    handler:unbind_up("left")
    handler:unbind_up("right")

    handler:unbind_down("up")
    handler:unbind_down("down")
    handler:unbind_up("up")
    handler:unbind_up("down")
end

function PlayerController:reset()
    self.up,self.down, self.left, self.right = false, false, false, false
    self.axis_x = 0
    self.axis_y = 0
end

function PlayerController:update()
    self.axis_x = 0
    self.axis_y = 0
    if self.up then self.axis_y = self.axis_y - 1 end
    if self.down then self.axis_y = self.axis_y + 1 end
    if self.left then self.axis_x = self.axis_x - 1 end
    if self.right then self.axis_x = self.axis_x + 1 end

    self.player.dx = 30 * self.axis_x
    if self.axis_x ~= 0 then
        self.player.walking = true
        self.player.facing = self.axis_x < 0 and "left" or "right"
    else
        self.player.walking = false
    end

    if self.axis_y == 0 then
        self.player.looking = "normal"
    elseif self.axis_y > 0 then
        self.player.looking = "down"
    else
        self.player.looking = "up"
    end

end

return PlayerController
