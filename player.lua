local class = require("30log")

local Player = class "Player"
local head_y_frames = {0, 8, 16, 8}

function Player:init(x, y)
    self.x, self.y = x, y
    self.dx, self.dy = 0, 0
    self.tex = love.graphics.newImage("imgs/sheet.png")
    self.tex:setFilter("nearest")
    self.head_quad = love.graphics.newQuad(0, 0, 8, 8, self.tex:getWidth(), self.tex:getHeight())
    self.body_quad = love.graphics.newQuad(4 * 8, 0, 8, 8, self.tex:getWidth(), self.tex:getHeight())

    self.facing = "right"
    self.looking = "normal"
    self.state = "ground"
    self.stair = nil

    self.blinking_timer = 3
    self.blinking_progress = 0
    self.blinking = false

    self.walking = false
    self.walk_cycle_progress = 0

    self.blink_sound = love.audio.newSource("snds/blink.wav")
    self.blink_sound:setVolume(0.05)
end

function Player:update(dt, room)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.state == "ground" then
        self.dy = self.dy + 1
        if self.y >= 63 - 16 then
            self.dy = 0
            self.y = 63 - 16
        end
    elseif self.state == "stair" then
        self.dy = 0
    end


    local middle_x = self.x + 4
    if self.state == "ground" then
        for _,stair in ipairs(room.stairs) do
            if math.floor(self.y + 16) == stair.bottom_y and self.looking == "up" then
                if
                    middle_x >= stair.start_x and middle_x <= stair.start_x + 1 and self.facing == "right" and
                        stair.orientation == "left"
                then
                    self.state = "stair"
                    self.stair = stair
                end

                if
                    middle_x >= stair.end_x - 1 and middle_x <= stair.end_x and self.facing == "left" and
                        self.stair.orientation == "right"
                then
                    self.state = "stair"
                    self.stair = stair
                end
            end
        end
    elseif self.state == "stair" then
        if middle_x < self.stair.start_x - 0.5 or middle_x > self.stair.end_x+0.5 then
            self.state = "ground"
            self.stair = nil
        elseif self.stair.orientation == "left" then
            self.y = self.stair.bottom_y - 16 - (middle_x - self.stair.start_x)
        elseif self.stair.orientation == "right" then
            self.y = self.stair.bottom_y - 16 - (self.stair.end_x - middle_x)
        end
    end

    if self.blinking then
        local previous_progress = self.blinking_progress
        self.blinking_progress = self.blinking_progress + dt * 5
        if self.blinking_progress >= 1 then
            self.blinking = false
            self.blinking_timer = 4
        end

        if previous_progress < 0.5 and self.blinking_progress >= 0.5 then
            self.blink_sound:play()
        end
    else
        self.blinking_timer = self.blinking_timer - dt
        if self.blinking_timer <= 0 then
            self.blinking = true
            self.blinking_progress = 0
        end
    end

    -- quad update
    local head_x = 0
    local head_y = self.blinking and head_y_frames[math.floor(self.blinking_progress * 4 + 1)] or 0
    if self.looking == "normal" then
        head_x = 0
    elseif self.looking == "up" then
        head_x = 8
    elseif self.looking == "down" then
        head_x = 16
    end
    self.head_quad:setViewport(head_x, head_y, 8, 8)

    local legs_x = 32
    if self.walking then
        self.walk_cycle_progress = (self.walk_cycle_progress + dt * 3) % 1
        legs_x = legs_x + 8 * math.floor(4 * self.walk_cycle_progress)
    end
    self.body_quad:setViewport(legs_x, 0, 8, 8)
end

function Player:draw()
    love.graphics.setColor(255,255,255)
    local middle_x = self.x + 4
    local body_quad = love.graphics.newQuad(4 * 8, 0, 8, 8, self.tex:getWidth(), self.tex:getHeight())
    local fx, fy = self.x, self.y
    local face_scale = self.facing == "left" and -1 or 1
    local face_offset = self.facing == "left" and 8 or 0

    love.graphics.draw(self.tex, self.head_quad, fx + face_offset, fy, 0, face_scale, 1)

    love.graphics.draw(self.tex, self.body_quad, fx + face_offset, fy + 8, 0, face_scale, 1)
end

return Player
