local Game = require("game")
local GameState = require("gamestate")

game = nil

require( "errhandler" )

function love.load()
    game = Game(GameState())
    game:register_callbacks()
end


function love.draw()
    game:draw()
end

function love.update(dt)
    game:update(dt)

end
