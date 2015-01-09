--[[
	1. mode 为地图卷动方式
		normal 根据图片帧数(类似传奇)
		flat 按照像素
		follow 按像素，切镜头跟随(类似魔力宝贝)
]]
local normal = 0
local flat = 1
local follow = 2

local map = {
x = 0, 
y = 0,
mode = flat
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
	local action = actor.action
	map.walkspeedx = const.mapcellwidth / (action.walk.time * action.walk.count)
	map.walkspeedy = const.mapcellheight / (action.walk.time * action.walk.count)
	map.runspeedx = const.mapcellwidth * 2 / (action.run.time * action.run.count)
	map.runspeedy = const.mapcellheight * 2 / (action.run.time * action.run.count)
	print("speed", map.runspeedx, map.runspeedy, map.walkspeedx, map.walkspeedy)
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

