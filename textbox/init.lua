local class = require "30log"
local mathutil = require("mathutil")

local TextBoxState = {
    -- Should be invisible
    DISABLED = "disabled",
    -- Should be appearing, probably empty
    APPEARING = "appearing",
    -- Drawign text and stuff
    ACTIVE = "active",
    -- Should progressively disappear
    DISAPPEARING = "disappearing"
}

local TextBoxSubState = {
    PRINTING = "printing",
    FULL = "full",
    END_OF_LINE = "end_of_line",
    DONE = "done"
}

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
    |   |      |      |
    |   |      |      |
    |   |      |      |
    |   |      |      |
    |   ↓      ↓      ↓
    Offset lines    STOP

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

local common_canvas = love.graphics.newCanvas(240, 16)
common_canvas:setFilter("nearest")
common_canvas:setWrap("clamp", "clamp")
local font = love.graphics.newFont("fnts/pico8.ttf", 4)

Textbox.init = {
    -- Independant from current state
    state = TextBoxState.DISABLED,
    text_queue = {},
    canvas = common_canvas,

    -- Appearing variables
    appearing_speed = 0.25, -- Time in seconds
    appearing_progress = 0,

    -- Active variables
    substate = TextBoxSubState.PRINTING,
    speed = 10, -- Characters per seconds
    character_timer = 0, -- Time before next character is displayed
    lines = {
        love.graphics.newText(font)
    }, -- Lines to draw
    current_line = 1, -- CUrrent line to append characters to
    current_text_index = {0}, -- Current character index in the to-be-displayed current text
    current_text_start = {1}, -- Current character start in the current text for partial line displays


    -- Disappearing variables
    disappearing_speed = 0.25, -- Time in seconds
    disappearing_progress = 0,
    on_finish_callback = nil,

}

function Textbox:enqueue(...)
    for _,text in ipairs({...}) do
        self.text_queue[#self.text_queue + 1] = text
    end
end

function Textbox:update(dt)
    if self.state == TextBoxState.DISABLED then
        return
    elseif self.state == TextBoxState.APPEARING then
        self.appearing_progress = self.appearing_progress + dt
        if self.appearing_progress >= self.appearing_speed then
            self.appearing_progress = 0
            self.state = TextBoxState.ACTIVE
        end
    elseif self.state == TextBoxState.ACTIVE then
        if self.substate == TextBoxSubState.PRINTING then
            self.character_timer = self.character_timer + dt
            if self.character_timer >= 1/self.speed then
                self.character_timer = self.character_timer - 1/self.speed
                self.current_text_index[self.current_line] = self.current_text_index[self.current_line] + 1
                self.lines[self.current_line]:set(string.sub( self.text_queue[1], self.current_text_start[self.current_line], self.current_text_index[self.current_line] ))

                if self.current_text_index[self.current_line] >= #self.text_queue[1] then
                    self.substate = TextBoxSubState.END_OF_LINE
                elseif self.lines[self.current_line]:getWidth() >= 238-4 then
                    if self.current_line < #self.lines then
                        self.current_line = self.current_line + 1
                        self.current_text_start[self.current_line] = self.current_text_index[self.current_line - 1]+1
                        self.current_text_index[self.current_line] = self.current_text_index[self.current_line - 1]+1
                    else
                        self.substate = TextBoxSubState.FULL
                    end
                end
            end
        elseif self.substate == TextBoxSubState.FULL then
            if love.keyboard.isDown("space") then
                -- TODO : correct text offset logic
                self.character_timer = 0
                self.current_text_start[1] = self.current_text_index[self.current_line]+1
                self.current_text_index[1] = self.current_text_index[self.current_line]+1
                self.current_text_start = self.current_text_index+1
                self.current_line = 1
                for i=1,#self.lines do
                    self.lines[i]:set("")
                end
                self.substate = TextBoxSubState.PRINTING
            end
        elseif self.substate == TextBoxSubState.END_OF_LINE then
            if love.keyboard.isDown("space") then
                -- TODO : correct text offset logic
                self.character_timer = 0
                self.current_text_start[1] = 0
                self.current_text_index[1] = 1
                self.current_line = 1
                for i=1,#self.lines do
                    self.lines[i]:set("")
                end
                table.remove(self.text_queue, 1)
                if #self.text_queue == 0 then
                    self.substate = TextBoxSubState.DONE
                else
                    self.substate = TextBoxSubState.PRINTING
                end
                print(self.substate)
            end
        elseif self.substate == TextBoxSubState.DONE then
            self.character_timer = 0
            self.current_text_start[1] = 0
            self.current_text_index[1] = 1
            self.current_line = 1
            for i=1,#self.lines do
                self.lines[i]:set("")
            end
            self.text_queue = {}
            self.state = TextBoxState.DISAPPEARING
            self.substate = TextBoxSubState.PRINTING
        end
    elseif self.state == TextBoxState.DISAPPEARING then
        self.disappearing_progress = self.disappearing_progress + dt
        if self.disappearing_progress >= self.disappearing_speed then
            self.disappearing_progress = 0
            self.state = TextBoxState.DISABLED
        end
    end
end


-- Returns the opacity the textbox should have based on its state.
function Textbox:calculate_transition_progress()
    local opacity = 1
    -- Basic linear fade.
    if self.state == TextBoxState.DISABLED then
        opacity = 0
    elseif self.state == TextBoxState.ACTIVE then
        opacity = 1
    elseif self.state == TextBoxState.APPEARING then
        opacity = self.appearing_progress / self.appearing_speed
    elseif self.state == TextBoxState.DISAPPEARING then
        opacity = 1 - (self.disappearing_progress / self.disappearing_speed)
    end
    return opacity
end

function Textbox:draw()
    if self.state == TextBoxState.DISABLED then
        return
    end
    --
    local progress = self:calculate_transition_progress()

    local previous_canvas = love.graphics.getCanvas()
    local previous_shader = love.graphics.getShader()
    love.graphics.setCanvas(common_canvas)
    love.graphics.setShader()
    love.graphics.push()
        love.graphics.origin()
        love.graphics.translate(0,mathutil.lerp(-10,0,progress))
        love.graphics.clear(0,0,0,0)
        -- Background
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0,0, 240, 9)
        -- Bottom border
        love.graphics.setColor(255,255,255)
        love.graphics.line(0,9, 240, 9)
        -- Text

        if self.state == TextBoxState.ACTIVE then
            for i=1,#self.lines do
                love.graphics.draw(self.lines[i], 1, 2 + 8*(i-1))
            end
        end

    love.graphics.pop()
    love.graphics.setShader(previous_shader)
    love.graphics.setCanvas(previous_canvas)

    love.graphics.setColor(255,255,255)
    love.graphics.draw(common_canvas)


    -- Drawing the background
end

return Textbox
