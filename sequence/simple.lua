local Action = require("sequence.action")
local InputHandler = require("input.handler")

local function sign(x)
    if x<0 then
      return -1
    elseif x>0 then
      return 1
    else
      return 0
    end
 end


local function Wait(state, time, player_input_blocking)
    local function wait(action)
        if player_input_blocking then
            state.player_controller:unbind_to_handler(state.game.input_handler)
        end
        local dt = 0
        while dt <= time do
            coroutine.yield()
            dt = dt + love.timer.getDelta()
            action.progress = dt / time
        end
        if player_input_blocking then
            state.player_controller:bind_to_handler(state.game.input_handler)
        end
    end
    local action = Action(coroutine.create(wait))
    action.name = "Wait "..time.." seconds"
    return action
end

local function Look(state, direction, duration)
    local function look(action)
        local handler = InputHandler()
        local player = state.player
        local player_controller = state.player_controller
        player_controller:unbind_to_handler(state.game.input_handler)
        player_controller:bind_to_handler(handler)

        player_controller[direction] = true

        local dt = 0
        while dt <= duration do
            coroutine.yield()
            dt = dt + love.timer.getDelta()
            action.progress = dt / duration
        end
        player_controller[direction] = false

        player_controller:unbind_to_handler(handler)
        player_controller:bind_to_handler(state.game.input_handler)

    end
    local action = Action(coroutine.create(look))
    action.name = "Look "..direction.."for "..duration.." seconds"
    return action
end

local function Move(state, direction, distance)
    local function move(action)
        local handler = InputHandler()
        local player = state.player
        local player_controller = state.player_controller
        player_controller:stopLeft()
        player_controller:stopRight()
        player_controller:unbind_to_handler(state.game.input_handler)
        player_controller:bind_to_handler(handler)

        local start_x = player.x
        local target_x = player.x + (direction == "right" and distance or -distance)
        local pdx = sign(target_x - start_x)
        local walked_delta_x = 0
        player_controller[direction] = true
        repeat
            coroutine.yield()
            walked_delta_x = math.abs(player.x - start_x)
            if walked_delta_x > math.abs(distance) then
                player.x = target_x
                walked_delta_x = distance
            end
            local px = walked_delta_x/math.abs(distance) or 0
            action.progress = px
        until walked_delta_x == distance
        player_controller[direction] = false

        player_controller:unbind_to_handler(handler)
        player_controller:bind_to_handler(state.game.input_handler)

    end
    local action = Action(coroutine.create(move))
    action.name = "Move "..distance.." pixels "..direction
    return action
end

local function Textbox(state, text, player_input_blocking)
    local function textbox(action)
        if type(text) == "string" then
            state.textbox:enqueue(text)
        elseif type(text) == "table" then
            state.textbox:enqueue(unpack(text))
        end
        state.textbox_controller:bind_to_handler(state.game.input_handler)
        state.textbox.state = "appearing"
        while state.textbox.state ~= "disabled" do
            if player_input_blocking then
                state.player_controller:unbind_to_handler(state.game.input_handler)
            end
                coroutine.yield()
        end
        state.textbox_controller:unbind_to_handler(state.game.input_handler)
        if player_input_blocking then
            state.player_controller:bind_to_handler(state.game.input_handler)
        end

    end
    local action = Action(coroutine.create(textbox))
    action.name = "Textbox"
    return action
end

return {
    Wait = Wait,
    Move = Move,
    Look = Look,
    Textbox = Textbox
}
