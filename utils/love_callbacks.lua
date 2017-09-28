--[[
    Small file allowing someone to mapquickly and automatically love's callbacks such as love.draw or other
]]

do
    local major, minor, revision= love.getVersion()
    assert(major == 0 and minor == 10 and revision == 2)
end


local callback_list = {
    -- Commenting out already used callbacks by other systems or things that will likely break everything
    "directorydropped",
    -- "draw",
    -- "errhand",
    "filedropped",
    "focus",
    --"keypressed",
    --"keyreleased",
    -- "load",
    "lowmemory",
    "mousefocus",
    "mousemoved",
    "mousepressed",
    "mousereleased",
    "quit",
    "resize",
    -- "run",
    "textedited",
    "textinput",
    "threaderror",
    "touchmoved",
    "touchpressed",
    "touchreleased",
    -- "update",
    "visible",
    "wheelmoved",
    "gamepadaxis",
    "gamepadpressed",
    "gamepadreleased",
    "joystickadded",
    "joystickaxis",
    "joystickhat",
    "joystickpressed",
    "joystickreleased",
    "joystickremoved",
}

return callback_list
