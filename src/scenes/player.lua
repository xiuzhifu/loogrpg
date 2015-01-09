local actor = require "actor"
local utils = require "utils"
local player = {}
player.__index = player
setmetatable(player, actor)
function player.new(config)
	local t = actor.new(config)
	setmetatable(t, player)
	return t
end
function player:move(tick)
	if tick - self.lastframetime > self.frametime then
		self.currentframe = self.currentframe + 1
		self.lastframetime = tick
		if self.currentframe + self.startframe > self.maxframe then
			local dx, dy = utils.getxydirectionbydir(self.dir)
			self.x = self.x + dx * self.movestep
			self.y = self.y + dy * self.movestep
			self.offsetx = 0
			self.offsety = 0
			self.currentaction = 0
			self.movestep = 0
			self.lastframetime = 0
			return false
		end	
		self:draw()
	end
	if self.movestep > 0 then self:recalcoffset(tick) end
	return true
end
return player