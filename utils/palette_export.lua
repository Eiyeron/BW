local picture_canvas = love.graphics.newCanvas(37,68)

local function drawPaletteToCanvas(palette)
    local previous_canvas = love.graphics.getCanvas()
    local previous_shader = love.graphics.getShader()
    love.graphics.setCanvas(picture_canvas)
    love.graphics.setShader()
    love.graphics.push()
        love.graphics.clear(255,0,0,0)
        love.graphics.setColor(0,0,0)
        for x=-1,1 do
            for y=-1,1 do
                love.graphics.print("-Palette-", 1+x, 2+y)
            end
        end
        love.graphics.setColor(255,255,255)
        love.graphics.print("-Palette-", 1, 2)

        love.graphics.rectangle("line", 2, 34, 34, 34)
        for i=1,4 do
            local str = string.format(
                    "#%02X%02X%02X",
                    palette[i][1],
                    palette[i][2],
                    palette[i][3]
                )
            love.graphics.setColor(0,0,0)
            for x=-1,1 do
                for y=-1,1 do
                    love.graphics.print(str, 5+x, 6*i + 2+y)
                end
            end
            love.graphics.setColor(255,255,255)
            love.graphics.print(str, 5, 6*i + 2)
            love.graphics.setColor(unpack(palette[i]))
            love.graphics.rectangle("fill", 2 + 8*(i-1), 35, 8, 31)
        end
    love.graphics.pop()
    love.graphics.setShader(previous_shader)
    love.graphics.setCanvas(previous_canvas)

    return picture_canvas
end

local function addToSelection(palette)
    local file = love.filesystem.newFile("palettes.txt", "a")
    local colors = {}
    for i=1,4 do
        colors[i] = string.format("#%02X%02X%02X", palette[i][1], palette[i][2], palette[i][3])
    end
    file:write(string.format("%s\n", table.concat(colors, ", ")))
    file:close()
end

return {
    drawPaletteToCanvas=drawPaletteToCanvas,
    addToSelection=addToSelection
}
