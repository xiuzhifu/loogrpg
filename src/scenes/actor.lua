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
	t.skip = 0
	t.action = {}
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

	t.action = config

	t.cc_sprite = display.newNode()
	return t
end

function actor:setdress(dress)
	self.dress = dress
	local image = imagemgr:getimage(self.dress.images, self.dress.start)
	self.cc_dress = display.newSprite(image)
	self.cc_sprite:addChild(self.cc_dress) 
	if self.dress.effectstart then
		self.cc_dresseffect = display.newSprite(image)
		self.cc_sprite:addChild(t.cc_dresseffect)
	end
end

function actor:setweapon(weapon)
	self.weapon = weapon
	local image = imagemgr:getimage(self.dress.images, self.dress.start)
	self.cc_weapon = display.newSprite(image)
	self.cc_sprite:addChild(t.cc_weapon)
	if self.weapon.effectstart then
		self.cc_weaponeffect = display.newSprite(image)
		self.cc_sprite:addChild(t.cc_weaponeffect)
	end
end

function actor:recalcoffset(tick)
	local t = const.mapcellwidth * self.movestep / (self.framecount - self.skip)
	self.offsetx = utils.actordir[self.dir + 1][1] * math.floor(t) * (self.currentframe + 1)
	t = const.mapcellheight * self.movestep / (self.framecount - self.skip)
	self.offsety = utils.actordir[self.dir + 1][2] * math.floor(t) * (self.currentframe + 1)
end
function actor:move(tick)
	if tick - self.lastframetime > self.frametime then
		self.currentframe = self.currentframe + 1
		self.lastframetime = tick
		if self.currentframe + self.startframe > self.maxframe then 
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
	if self.currentaction == const.sm_walk then
		act = self.action.walk
		self.movestep = 1
	elseif self.currentaction == const.sm_run then
		act = self.action.run
		self.movestep = 2
	elseif self.currentaction == const.sm_hit then
		act = self.action.hit	
	elseif self.currentaction == const.sm_magic then
		act = self.action.hit
	elseif self.currentaction == const.sm_behit then
		act = self.action.behit
	elseif self.currentaction == const.sm_death then
		act = self.action.death
	else
		act = self.action.stand
	end
	if act then
		self.currentframe = -1
		self.framecount = act.count + act.skip
		self.skip = act.skip
		self.startframe = act.start
		self.maxframe = self.startframe + act.count - 1
		self.frametime = act.time
	end
end

function actor:draw()
	local image
	if self.dress then
		image = imagemgr:getimage(self.dress.images, self.dress.start + self.startframe + 
			self.framecount * self.dir + self.currentframe)
		if image then self.cc_dress:setSpriteFrame(image) end

		if self.dress.effectstart then
			image = imagemgr:getimage(self.dress.images, self.dress.effectstart + self.startframe + 
				self.framecount * self.dir + self.currentframe)
			if image then self.cc_dresseffect:setSpriteFrame(image) end
		end
	end
	
	if self.weapon then
		image = imagemgr:getimage(self.weapon.images, self.weapon.start + self.startframe + 
			self.framecount * self.dir + self.currentframe)
		if image then self.cc_weapon:setSpriteFrame(image) end

		if self.weapon.effectstart then
			image = imagemgr:getimage(self.weapon.images, self.weapon.effectstart + self.startframe + 
				self.framecount * self.dir + self.currentframe)
			if image then self.cc_weaponeffect:setSpriteFrame(image) end
		end
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
