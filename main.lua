local Game = require("game")
local GameState = require("gamestate")


require( "errhandler" )

function love.load()
    Game(GameState())
end
