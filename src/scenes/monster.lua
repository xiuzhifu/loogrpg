local monster = {}
local imagemgr = require "imagemgr"
local camera = require "camera"
local const = require "const"
local utils = require "utils"
monster.__index = monster

function monster.new(config)
	local t = setmetatable({}, monster)
	t.name = ""
	t.id = 0
	t.x = 0
	t.y = 0
	t.lastx = 0
	t.lasty = 0
	t.offsetx = 0
	t.offsety = 0
	t.dir = 0
	t.action = {}
	t.drawstart = 0
	t.currentframe = 0
	t.maxframe = 0
	t.frametime = 0
	t.lastframetime = 0
	t.currentaction = 0
	t.movestep = 0
	t.alive = false
	t.effectlist = {}
	t.actionlist = {}
	t.attri = {}

	t.config = config
	t:setbody(config)
	return t
end

function monster:setbody()
	local image = imagemgr:getimage2(self.config.images, self.config.action[0].start,1)
	self.cc_sprite = display.newSprite(image)
end

function monster:recalcoffset(tick)
	local t = const.mapcellwidth * self.movestep / (self.maxframe)
	self.offsetx = utils.actordir[self.dir + 1][1] * math.floor(t) * (self.currentframe + 1)

	t = const.mapcellheight * self.movestep / (self.maxframe)
	self.offsety = utils.actordir[self.dir + 1][2] * math.floor(t) * (self.currentframe + 1)

	print(self.offsetx, self.offsety)
end
function monster:move(tick)
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
	local tx, ty = camera.getposincamera(self.x, self.y)
	tx = tx + self.offsetx
	ty = ty + self.offsety
	if self.drawx ~= tx or self.drawy ~= ty then
		self.drawx = tx
		self.drawy = ty
		self:setposition(tx, ty)
	end 
	return false
end
function monster:recalcframe()
	local act
	self.movestep = 0
	local act = self.config.action[self.currentaction]
	if not act then act = self.config.action[0] end
	self.movestep = act.movestep
	self.currentframe = 0--会先加1
	self.action = act
	self.maxframe = act.count
	self.frametime = act.time
end

function monster:draw()
	local image
	if self.cc_sprite then
		image = imagemgr:getimage2(self.config.images, self.action.start, self.maxframe * self.dir + self.currentframe)
		if image then self.cc_sprite:setSpriteFrame(image) end
	end
end

function monster:update(tick)
	if self.currentaction == 0 then 
		if #self.actionlist > 0 then
			self:handleaction() 
		end
	end
	if self:move(tick) then
		self:recalcframe()
	end
	for i,v in ipairs(self.effectlist) do
		if not v:update(tick) then
			self.cc_sprite:removeChild(v.cc_sprite)
			table.remove(self.effectlist, i)
		end
	end
end

function monster:handleaction()
	local act = self.actionlist[1]
	self.currentaction = act.ident
	if act.ident == const.sm_walk then 
		self.dir = act.d 
	elseif act.ident == const.sm_run then
		self.dir = act.d
	end
	table.remove(self.actionlist,1)
	self:recalcframe()
end
function monster:addaction(action)
	table.insert(self.actionlist,action)
end

function monster:addeffect(effect)
	table.insert(self.effectlist, effect)
end

function monster:setposition(x, y)
	self.cc_sprite:setPosition(x, utils.righty(y))
end

return monster