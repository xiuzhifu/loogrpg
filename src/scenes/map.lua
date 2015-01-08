--map格式  用三层，最底层远处，次底层近处，顶层实现遮挡跟动画
local map = {
stops = {},
x = 0, 
y = 0
}
local const = require "const"
local utils = require "utils"
local camera = require "camera"
local cc = cc
local sharedTextureCache = cc.Director:getInstance():getTextureCache()
local sharedDirector = cc.Director:getInstance()

function map.loadmap(filename)
	map.image = sharedTextureCache:addImage(filename)
	if map.cc_sprite then
		map.scene:removeChild(0)
	end
	map.cc_sprite = display.newSprite(map.image)
	display.align(map.cc_sprite, display.LEFT_TOP)
	map.scene:addChild(map.cc_sprite)
end

function map.new(scene)
	map.scene = scene
	camera.init(1000, 1000)
end

function map.move()
	camera.move(map.actor)
end

function map.focusactor(actor)
	map.actor = actor
end

function map.setactorposition()
	local x, y = camera.getposincamera(map.actor.x, map.actor.y, true)
	if x ~= map.x or y ~= map.y then
		map.actor:setposition(x, y)
		map.x = x
		map.y = y
		print(map.x, map.y)
	end
end

function map.getmapposition(x, y)
	return camera.getposinscene(x, y)
end

function map.update()
	local x, y = camera.getcamerarect()
	local tempx, tempy = - (x + map.actor.offsetx), - (y + map.actor.offsety)
	if map.lastx == tempx and map.lasty == tempy then
		return
	end 
	map.lastx = tempx 
	map.lasty = tempy
	map.cc_sprite:setPosition( tempx, utils.righty(tempy))
end

return map

