local class = require("30log")
local Room = require("room")

local RoomStorage = class "RoomStorage"
RoomStorage.init = {rooms={},prefix="maps/"}

function RoomStorage:get(room_name)
    if self.rooms[room_name] then
        return self.rooms[room_name]
    else
        local room = Room(self.prefix..room_name..".lua")
        self.rooms[room_name] = room
        return room
    end
end

return RoomStorage
