local utils = require "utils"
local camera = require "camera"
local imagemgr = require "imagemgr"
local const = require "const"
local effect = {}
effect.__index = effect
function effect.new(config, owner)
	if not effect then return nil end
	local t = setmetatable({}, effect)
	t.effect = config
	t.lasttick = 0
	t.currentframe = 0
	t.disappear = false
	t.lastx = 0
	t.lasty = 0
	t.drawx = 0
	t.drawy = 0
	t.count = config.playcount - 1
	t.owner = owner
	local image = t:getimage()
	t.cc_sprite = display.newSprite(image) 
	if config.blend then  
		if config.blend == 1 then  
			t.cc_sprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_COLOR)
		end
	end
	owner:addChild(t.cc_sprite)
	return t
end

function effect:update(tick)
	if tick - self.lasttick < self.effect.delay then return not self.disappear end
	self.lasttick = tick
	if self.currentframe < self.effect.count - 1 then
		self.currentframe = self.currentframe + 1
		self:draw()
	else
		if self.count > 0 then 
			self.count = self.count - 1 
		elseif self.count == 0 then 
			self.disappear = true
		end
		self.currentframe = 0
	end
	return not self.disappear
end

function effect:getimage()
	return imagemgr:getimage(self.effect.images, self.effect.start + self.currentframe)
end

function effect:draw()
	if not disapper then
		local image = self:getimage()
		if image then self.cc_sprite:setSpriteFrame(image) end
	end
end

function effect:setposition(x, y)
	self.cc_sprite:setPosition(x, y)
end

local actoreffect = {}
actoreffect.__index = actoreffect
setmetatable(actoreffect, effect)

function actoreffect.new(config, owner)
	if not owner then return nil end
	local t = effect.new(config, owner.cc_sprite)
	if t then
		setmetatable(t, actoreffect)
		t.actor = owner
		t:setposition(0, 0)
		return t
	end
end

function actoreffect:update(tick)
	return effect.update(self, tick)
end

local fixeffect = { }
fixeffect.__index = fixeffect
setmetatable(fixeffect, effect)

function fixeffect.new(config, owner, x, y)
	local t = effect.new(config, owner)
	setmetatable(t, fixeffect)
	t.x = x
	t.y = y
	return t
end
function fixeffect:update(tick, player)
	local x , y = camera.getposincamera(self.x, self.y)
	x = x - player.offsetx
	y = utils.righty(y - player.offsety)
	if self.lastx ~= x or self.lasty ~= y then
		self.lastx = x
		self.lasty = y
		self:setposition(x, y)
	end
	return effect.update(self, tick)
end

flyeffect = {}
setmetatable(flyeffect, effect)
flyeffect.__index = flyeffect

function flyeffect.new(config, owner, targetx, targety, sourcex, sourcey, targeteffect, target)
	local t = effect.new(config, owner)
	setmetatable(t, flyeffect)
	t.targetx, t.targety = targetx, targety
	t.sourcex, t.sourcey = camera.getposincamera(sourcex, sourcey)
	t.tickcount = config.flytime
	t.lasttick = 0
	if targeteffect then t.targeteffect = targeteffect end
	if target then t.target = target end
	return t
end

function flyeffect:update(tick, player)
	if tick - self.lasttick < 30 then return true end
	self.lasttick = tick
	local tx ,ty, sx, sy
	if self.target then
		tx, ty = camera.getposincamera(self.target.x, self.target.y)
		sx, sy = self.sourcex, self.sourcey

		tx = tx + self.target.offsetx - player.offsetx
		ty = ty + self.target.offsety - player.offsety

		sx = sx
		sy = sy
	else
		sx, sy = camera.getposincamera(self.sourcex, self.sourcey)
		tx, ty = camera.getposincamera(self.targetx, self.targety)
		tx = tx - player.offsetx
		ty = ty - player.offsety

		--sx = sx + player.offsetx
		--sy = sy - player.offsety
	end
	local dir = utils.getdir(sx, sy, tx ,ty)
	local lenx = tx - sx
	local leny = ty - sy


	local runx = 0
	local runy = 0--runx * leny / lenx

	if lenx > 0 then
		runx = sx + (lenx / self.tickcount) * 30
	else
		runx = sx + (lenx / self.tickcount) * 30
	end

	if leny > 0 then
		runy = sy + (leny / self.tickcount) * 30
	else
		runy = sy + (leny / self.tickcount) * 30
	end
	self.tickcount = self.tickcount - 30




	runx = runx - player.offsetx
	runy = runy - player.offsety

	self.sourcex = runx
	self.sourcey = runy
	if self.lastx ~= runx or self.lasty ~= runy then
		self.lastx = runx
		self.lasty = runy
		self:setposition(runx, utils.righty(runy))
	end

	if math.abs(runx - tx) < 10 and math.abs(runy - ty) < 10 then
		print("fuck")
		if self.targeteffect then
			if self.target then
				--target.addeffect(magic.create_actoreffect(self.targeteffect, self.target))
			else
				local effect = fixeffect.new(self.targeteffect, self.owner, tx, utils.righty(ty))
				table.insert(magic.effectlist, effect)				
			end
		end
		return false 
	end
	return effect.update(self, tick)
end

local magic = {
	effectlist = {}
}
function magic.createmagic(msg)
	local effect
	if msg.id and magicConfig[msg.id] then
		local magic = magicConfig[msg.id]
		if sourceactor and magic.ready then
			sourceactor.addaeffect(magic.ready)
		end
		if magic.fly then
			if magic.exp and target then
				effect = TFlyEffect.create(magic.fly, 0, 0, sourceactor.x, sourceactor.y, magic.exp, target)
			elseif magic.exp then
				effect = TFlyEffect.create(magic.fly, targetx, targety, sourceactor.x, sourceactor.y, magic.exp)
			else
				effect = TFlyEffect.create(magic.fly, targetx, targety, sourceactor.x, sourceactor.y)
			end
		elseif magic.exp then
			if target then
				target.addaeffect(magic.exp)
			else
				effect = TFixEffect.create(magic.exp, targetx, targety)
			end
		end
	end
	if effect then table.insert(effectList,effect) end
end

function magic.create_effect(config, owner)
	return effect.new(config, owner)
end

function magic.create_actoreffect(config, owner)
	return actoreffect.new(config, owner)
end

function magic.create_fixeffect(config, owner,  x, y)
	local effect = fixeffect.new(config, owner, x, y)
	table.insert(magic.effectlist, effect)
end
function magic.create_flyeffect(...)
	local effect = flyeffect.new(...)
	table.insert(magic.effectlist, effect)
end
return magic