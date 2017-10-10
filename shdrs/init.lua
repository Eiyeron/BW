local class = require( "30log" )

local Shader = class "Shader"

function Shader:init( filename )

    self.filename = filename
    self.shaderProgram = nil
    self.ok = false
    self:reload()
end

function Shader:reload()
    xpcall(function()
        local shader = love.filesystem.read(self.filename)
        self.shaderProgram = love.graphics.newShader(shader)
        self.ok = true
    end, function(err)
        print(string.format("Error loading shader %s : %s", self.filename, err))
    end)
end

function Shader:send(...)
    local args = {...}
    xpcall( function ()
        self.shaderProgram:send(unpack(args))
    end, function(err)
        print(string.format("Error setting shader variable %s : %s", self.filename, err))
        self.ok = false
    end)
end

function Shader:use(send_elements)
    if not self.ok then love.graphics.setShader(Shader.fallback.shaderProgram) return end
    for _,arg in ipairs(send_elements) do
        self:send(unpack(arg))
    if not self.ok then love.graphics.setShader(Shader.fallback.shaderProgram) return end
    end
    love.graphics.setShader(self.shaderProgram)
end

Shader.fallback = Shader("shdrs/fallback.glsl")

return Shader
