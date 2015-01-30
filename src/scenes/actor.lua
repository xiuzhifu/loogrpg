local actor = {}
local imagemgr = require "imagemgr"
local camera = require "camera"
local const = require "const"
local utils = require "utils"
actor.__index = actor

function actor.new(config)
	local t = setmetatable({}, actor)
	t.name = ""
	t.id = 0
	t.x = 0
	t.y = 0
	t.lastx = 0
	t.lasty = 0
	t.offsetx = 0
	t.offsety = 0
	t.dir = 0
	t.drawstart = 0
	t.startframe = 0
	t.currentframe = 0
	t.maxframe = 0
	t.framecount = 0
	t.frametime = 0
	t.lastframetime = 0
	t.currentaction = 0
	t.movestep = 0
	t.alive = false
	t.effectlist = {}
	t.actionlist = {}
	t.attri = {}

	t.config = config

	t.cc_sprite = display.newNode()
	return t
end

function actor:setdress(dress)
	self.dress = dress
	local image = imagemgr:getimage2(self.dress.images, self.config[0].start,1)
	self.cc_dress = display.newSprite(image)
	self.cc_sprite:addChild(self.cc_dress)
end

function actor:setweapon(weapon)
	self.weapon = weapon
	local image = imagemgr:getimage2(self.weapon.images, self.config[0].start,1)
	self.cc_weapon = display.newSprite(image)
	self.cc_sprite:addChild(t.cc_weapon)
end

function actor:recalcoffset(tick)
	local t = const.mapcellwidth * self.movestep / self.maxframe
	self.offsetx = utils.actordir[self.dir + 1][1] * t * self.currentframe

	t = const.mapcellheight * self.movestep / self.maxframe
	self.offsety = utils.actordir[self.dir + 1][2] * t * self.currentframe
end
function actor:move(tick)
	if tick - self.lastframetime >= self.frametime then
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
	--tx = tx + self.offsetx
	--ty = ty + self.offsety
	if self.drawx ~= tx or self.drawy ~= ty then
		self.drawx = tx
		self.drawy = ty
		self:setposition(tx, ty)
	end 
	return false
end
function actor:recalcframe()
	local act
	self.movestep = 0
	local act = self.config[self.currentaction]
	if not act then act = self.action[0] end
	self.movestep = act.movestep
	self.currentframe = 1--会先加1
	self.action = act
	self.maxframe = act.count
	self.frametime = act.time
	self:draw()
end

function actor:draw()
	local image
	if self.dress then
		image = imagemgr:getimage2(self.dress.images, self.action.start, self.maxframe * self.dir + self.currentframe)
		if image then self.cc_dress:setSpriteFrame(image) end
	end
	
	if self.weapon then
		image = imagemgr:getimage2(self.weapon.images, self.action.start, self.maxframe * self.dir + self.currentframe)
		if image then self.cc_weapon:setSpriteFrame(image) end
	end
end

function actor:update(tick)
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

function actor:handleaction()
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
function actor:addaction(action)
	table.insert(self.actionlist,action)
end

function actor:addeffect(effect)
	table.insert(self.effectlist, effect)
end

function actor:setposition(x, y)
	self.cc_sprite:setPosition(x, utils.righty(y))
end

return actor
