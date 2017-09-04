local class = require("30loc")

local Player = class()
local head_y_frames = {0,8,16,8}


function Player:init(x, y)
    self.x, self.y = x, y
    self.dx, self.dy = 0,0
    self.tex = love.graphics.newImage("imgs/sheet.png")
    self.head_quad = love.graphics.newQuad(0,0,8,8,self.tex:getWidth(),self.tex:getHeight())
    self.body_quad = love.graphics.newQuad(4*8,0,8,8,self.tex:getWidth(),self.tex:getHeight())

    self.facing="right"
    self.looking="normal"
    self.state = "stair"
    self.stair = {
        start=130,
        send=130+32,
        bottom_y=63,
        -- going downwards in which direction
        orientation="left"
    }

    self.blinking_timer=3
    self.blinking_progress=0
    self.blinking=false

    self.walking=false
    self.walk_cycle_progress=0
end

function Player:update(dt)
    if self.state == "ground" then
        self.dy = self.dy + 1
        if self.y >= 63-16 then
            self.dy = 0
            self.y = 63-16
        end
    elseif self.state =="stair" then
        self.dy = 0
    end

    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt

    local middle_x = self.x+4
    if self.state == "ground" then
        if math.floor(self.y+16) == self.stair.bottom_y and self.looking == "up" then
            if middle_x >= self.stair.start and middle_x <= self.stair.start + 1 and self.facing=="right" and self.stair.orientation=="left" then
                self.state = "stair"
            end

            if middle_x >= self.stair.send-1 and middle_x <= self.stair.send and self.facing=="left" and self.stair.orientation=="right" then
                self.state = "stair"
            end
        end
        -- if middle_x >= self.stair.start and middle_x <= self.stair.send then
        --     self.state = "stair"
        -- end
    elseif self.state == "stair" then
        if middle_x < self.stair.start or middle_x > self.stair.send then
            self.state = "ground"
        elseif self.stair.orientation == "left" then
            self.y = self.stair.bottom_y - 16 -(middle_x-self.stair.start)
        elseif self.stair.orientation == "right" then
            self.y = self.stair.bottom_y - 16 -(self.stair.send-middle_x)
        end
    end

    if self.blinking then
        self.blinking_progress = self.blinking_progress + dt*5
        if self.blinking_progress >= 1 then
            self.blinking = false
            self.blinking_timer = 4
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
    local head_y = self.blinking and head_y_frames[math.floor(self.blinking_progress*4+1)] or 0
    if self.looking == "normal" then
        head_x = 0
    elseif self.looking == "up" then
        head_x = 8
    elseif self.looking == "down" then
        head_x = 16
    end
    self.head_quad:setViewport(head_x,head_y,8,8)

    local legs_x=32
    if self.walking then
        self.walk_cycle_progress = (self.walk_cycle_progress + dt*3) % 1
        legs_x = legs_x + 8*math.floor(4*self.walk_cycle_progress)
    end
    self.body_quad:setViewport(legs_x,0,8,8)
end

function Player:draw()
    local middle_x = self.x+4
    local body_quad = love.graphics.newQuad(4*8,0,8,8,self.tex:getWidth(),self.tex:getHeight())
    local fx,fy = math.floor(self.x), math.floor(self.y)
    local face_scale = self.facing == "left" and -1 or 1
    local face_offset = self.facing == "left" and 8 or 0

    love.graphics.draw(self.tex, self.head_quad,fx+face_offset,fy, 0, face_scale,1)
    
    love.graphics.draw(self.tex, self.body_quad,fx+face_offset,fy+8, 0, face_scale,1)
    
    love.graphics.setColor(255,0,0,255)

    if self.stair.orientation == "left" then
        love.graphics.line(self.stair.start,self.stair.bottom_y,self.stair.send,self.stair.bottom_y - (self.stair.send - self.stair.start))
    elseif  self.stair.orientation == "right" then
        love.graphics.line(self.stair.start,self.stair.bottom_y - (self.stair.send - self.stair.start),self.stair.send,self.stair.bottom_y)
    end
end

return Player