local StackTracePlus = require("StackTracePlus")

local error_font =  love.graphics.newFont(math.floor(love.window.toPixels(10)))

local function error_printer(msg, layer)
    print((StackTracePlus.stacktrace("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\r\n", "\n")))
end

function love.errhand(msg)
    msg = tostring(msg)
    error_printer(msg, 2)

    if not love.window or not love.graphics or not love.event then
        return
    end

    if not love.graphics.isCreated() or not love.window.isOpen() then
        local success, status = pcall(love.window.setMode, 800, 600)
        if not success or not status then
            return
        end
    end

    -- Reset state.
    if love.mouse then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
        love.mouse.setRelativeMode(false)
    end
    if love.joystick then
        -- Stop all joystick vibrations.
        for _,v in ipairs(love.joystick.getJoysticks()) do
            v:setVibration()
        end
    end
    if love.audio then love.audio.stop() end
    love.graphics.reset()
    love.graphics.setFont(error_font)

    love.graphics.setBackgroundColor(118, 10, 15)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.origin()

    local trace = StackTracePlus.stacktrace("Oops! An error occured : "..msg.."\n", 2):gsub("\r\n", "\n")
    local pos = 20
    local p10 = love.window.toPixels(10)
    local dumped = false
    local filename = os.date("error_%Y-%m-%d_%H-%M-%S.log")
    local function draw(pos)
        local p = love.window.toPixels(pos)
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.graphics.printf(trace, p10, p, love.graphics.getWidth() - p10)
        if dumped then
            love.graphics.setColor(118, 10, 15)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), p10 + love.window.toPixels(2))
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.printf(
                "An error log has been dumped at "
                    ..love.filesystem.getRealDirectory(filename)
                    ..filename,
                p10 , 0 , love.graphics.getWidth() - p10 )
        end
        love.graphics.present()
    end

    while true do
        love.event.pump()

        for e, a, _, _ in love.event.poll() do
            if e == "quit" then
                return
            elseif e == "keypressed" then
                if a == "up" then
                    pos = pos + 10
                elseif a == "down" then
                    pos = pos - 10
                elseif a == "escape" then
                    return
                elseif a == "d" and not dumped then
                    dumped = true
                    local f = love.filesystem.newFile(filename)
                    f:open("w")
                    local t = trace:gsub("\n","\r\n")
                    f:write(t)
                    print(t)
                    f:flush()
                    f:close()
                end
            elseif e == "touchpressed" then
                local name = love.window.getTitle()
                if #name == 0 or name == "Untitled" then name = "Game" end
                local buttons = {"OK", "Cancel"}
                local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
                if pressed == 1 then
                    return
                end
            end
        end

        draw(pos)

        if love.timer then
            love.timer.sleep(0.1)
        end
    end

end
