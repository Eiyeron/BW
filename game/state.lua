--[[
	State class inspired by Haxeflixel's FlxState
]]--

local class = require("30log")

local State = class "State"
function State:init()
	self.objects = {}
end

function State:update(dt)
end

function State:draw()
end

function State:add(obj)
	table.insert(self.objects, obj)
end

function State:remove(obj)
	for i,v in ipairs(self.objects) do
		if v == obj then
			table.remove(self.objects, i)
			return
		end
	end
end

function State:on_exit(next_state)
end

return State