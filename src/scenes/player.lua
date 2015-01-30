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
		if self.currentframe > self.maxframe then 
			self.x = self.x + utils.actordir[self.dir + 1][1] * self.movestep
			self.y = self.y + utils.actordir[self.dir + 1][2] * self.movestep
			self.offsetx = 0
			self.offsety = 0
			self.currentaction = 0
			self.movestep = 0
			self.lastframetime = 0
			return true
		end	
		self:draw()
	end
	if self.movestep > 0 then 
		self:recalcoffset(tick) 
	end
	return false
end
return player