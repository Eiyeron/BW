local Controller = require("input.controller")

local TextboxController = Controller:extend("TextboxController")
function TextboxController:init(textbox)
    self.textbox = textbox
end


function TextboxController:press()
    self.textbox:asks_for_next()
end

function TextboxController:bind_to_handler(handler)
    self.super.bind_to_handler(self, handler)
    handler:bind_down("space", self.press, self)
end

function TextboxController:unbind_to_handler(handler)
    self.super.unbind_to_handler(self, handler)
    handler:unbind_down("space")
end

return TextboxController
