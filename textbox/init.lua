local class = require "30log"

--[[
    States
    Disabled (invisible) -------→ Appearing (turning into visible, time for animation)
          ↑                           |
          |                           |
          |                           |
          |                           |
          |                           |
          |                           |
          |                           ↓
    Disappearing ←---------------- Active (Visible, text appearing, waiting for input, etc...)

    Active states
    Printing (one/more chars/tick)
    ↑   |           |
    |   |           |
    |   |           |
    |   |           |
    |   ↓           ↓
    | Full     End of text
    |   |
    |   |
    |   |
    |   |
    |   ↓
    Offset lines

    usage?
    textbox.queue(my_message_list)
    textbox.set_on_finish_callback(clbk)
    textbox.pop()

    Callbacks?
    - Possibly messy code
    - Possibly forgetting to set/unset callbacks?

    Getting a flag
    - Look at how it can get messy on Four
        - TBH, Four's textbox's logic was fscked because of tween overuse

    Coroutines?
    - DOn't try to use them everywhere
    - We've already talked about it.
    - Stop, you know it's no good.

]]
local Textbox = class "Textbox"
Textbox.init = {
    -- Independant from current state
    state = "disabled",
    text_queue = {},

    -- Appearing variables
    appearing_speed = 1, -- Time in seconds
    appearing_progress = 0,

    -- Active variables
    speed = 5, -- Characters per second
    character_timer = 0, -- Time before next character is displayed
    lines = {}, -- Lines to draw
    current_line = 1, -- CUrrent line to append characters to
    current_text_index = 1, -- Current character index in the to-be-displayed current text


    -- Disappearing variables
    disappearing_speed = 1, -- Time in seconds
    disappearing_progress = 0,
    on_finish_callback = nil,

}

function Textbox:update(dt)
end