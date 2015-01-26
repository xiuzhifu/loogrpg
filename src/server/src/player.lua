local msghandler = require "msghandler"
local struct = require "struct"
local player =  {
	msglist = {}
}
player.__index = player
--[[
	t.hp = config.hp
	t.mp = config.mp
	t.maxhp = config
	t.sex = config.sex
]]

function player.new()
	local t = setmetatable({}, player)
	return t 
end

function player:load(config)
	for k,v in pairs(config) do
		t[k] = v
	end
	
end

function player:update(tick)
	if #self.msglist > 0 then
		local msg = table.remove(self.msglist, 1)
		self:dispatchmsg(msg)
	end	
end

function player.run(x, y)
	-- body
end

function player:walk(x, y)
	-- body
end

function player:addmsg(msg)
	table.insert(self.msglist, msg)
end

function player:dispatchmsg(msg)
	local id = struct.unpack(">I2", msg)
	if msghandler[id] then
		msghandler[id](self, msg)
	else
		gs.runing = false
	end
end
return player