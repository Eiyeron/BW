local Game = require("game")
local GameState = require("gamestate")

game = nil

require( "errhandler" )

function love.load()
    game = Game(GameState())
end
