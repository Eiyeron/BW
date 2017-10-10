local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
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
    love.graphics.setNewFont(math.floor(love.window.toPixels(14)))

    love.graphics.setBackgroundColor(118, 10, 15)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.origin()

    -- Going through the stack and files to get the erroring line
    local err = {}

    -- Keeping the same error header for no reason
    table.insert(err, "Error\n")
    table.insert(err, msg.."\n\n")
    table.insert(err, "stack traceback:")

    local add_to_list = false
    -- for each line in the stack trace under the assert and removing the extra line returns
    for line in debug.traceback("", 2):gmatch("([^\n]*)\n?") do
        -- trimming the left space
        line = line:gsub("^(%s+)", "")
        if add_to_list then
            -- getting the line and filename from the line.
            local _,_, file, lineno = string.find(line, "([^:]+):(%d*)")
            -- If the current function wasn't native C, then add it to thje
            if file and file ~= "C" and love.filesystem.exists(file) then
                -- Opening the file and getting the line
                local target_lineno = tonumber(lineno)
                local file_line_number=0
                local result = "<Couldn't load the line>"
                for l in love.filesystem.lines(file) do
                    file_line_number = file_line_number + 1
                    if file_line_number == target_lineno then
                        result = l
                        break
                    end
                end
                table.insert(err, line.." -> "..result)
            else
                table.insert(err, line)
            end

        end
        -- If we went past the
        add_to_list = add_to_list or line == "stack traceback:"
    end

    local p = table.concat(err, "\n")

    p = string.gsub(p, "\t", "")
    p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

    local function draw()
        local pos = love.window.toPixels(70)
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
        -- love.graphics.printf(t, pos, pos, love.graphics.getWidth() - pos)
        love.graphics.present()

    end

    while true do
        love.event.pump()

        for e, a, _, _ in love.event.poll() do
            if e == "quit" then
                return
            elseif e == "keypressed" and a == "escape" then
                return
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

        draw()

        if love.timer then
            love.timer.sleep(0.1)
        end
    end

end
