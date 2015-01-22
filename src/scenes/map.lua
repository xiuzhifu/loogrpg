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
root = {},
x = 0, 
y = 0,
mode = flat
}

local const = require "const"
local utils = require "utils"
local camera = require "camera"
local mc = require "map.c"
local quadtree = require "quadtree"
local cc = cc
local sharedTextureCache = cc.Director:getInstance():getTextureCache()
local sharedDirector = cc.Director:getInstance()

function map.loadmap(filename)
	map.name = filename
	map.cellimage = {}
	map.h = mc.load("/map/"..filename..".map")
	if not map.h then return false end
	map.h.width = 4096 * 4
	map.h.height = 4096 * 4
	camera.init(map.h.width, map.h.height)

	local rect = {left = 0, top = 0, right = map.h.width, bottom = map.h.height}
	map.root.rect = rect
	local l, s, b = 0,  math.floor(math.max(rect.right, rect.bottom) / const.mapcellsize), 1
	while true do
		b = b * 2
		l = l + 1
		if b > s then break end
	end
	print("l", l)
	quadtree.split(map.root, rect, l)
	map.pictures = mc.getpictures()
	for i,v in ipairs(map.pictures) do
		local cell = {id = i}
		cell.rect = {left = v.x, top = v.y , right = v.x + 1, bottom = v.y + 1}
		quadtree.insert(map.root, cell)
	end
	map.animations = mc.getanimations()
end

function map.new(scene)
	map.scene = scene
end

function map.move()
	if camera.move(map.actor) then
		--所有地图图片都不显示
		for k,v in pairs(map.cellimage) do
			v.visible = false
			v.cc_sprite:setVisible(false)
		end
		--设置要显示的图片
		local r = camera.getcamerarect()
		local node = quadtree.get(map.root, r)
		for i,v in ipairs(node) do
			print(v.id)
			local pic = map.pictures[v.id]
			local image = map.name..'_'..pic.picture..'.png'
			if not map.cellimage[image] then
				map.cellimage[image] = {}
				local t = map.cellimage[image] 
				t.image = sharedTextureCache:addImage("/map/"..image)
				t.cc_sprite = display.newSprite(t.image)
				display.align(t.cc_sprite, display.LEFT_TOP)		
				map.scene:addChild(t.cc_sprite)
				t.x = pic.x
				t.y = pic.y
			else
				map.cellimage[image].cc_sprite:setVisible(true)
				map.cellimage[image].visible = true
			end
		end
		if #map.cellimage > 10 then
			for i,v in ipairs(map.cellimage) do
				if v.visible then
					map.scene:removeChild(v.cc_sprite)
					v.cc_sprite = nil
					map.cellimage[k] = nil
				end
			end
		end
			
	end
end

function map.focusactor(actor)
	map.actor = actor
	local action = actor.action
	map.walkspeedx = const.mapcellwidth / (action.walk.time * action.walk.count)
	map.walkspeedy = const.mapcellheight / (action.walk.time * action.walk.count)
	map.runspeedx = const.mapcellwidth * 2 / (action.run.time * action.run.count)
	map.runspeedy = const.mapcellheight * 2 / (action.run.time * action.run.count)
end

function map.setactorposition()
	local x, y = camera.getposincamera(map.actor.x, map.actor.y, true)
	if x ~= map.x or y ~= map.y then
		map.actor:setposition(x, y)
		map.x = x
		map.y = y
	end
end

function map.getmapposition(x, y)
	return camera.getposinscene(x, y)
end

function map.update()
	local x, y = camera.getcameraxy()
	local tempx, tempy = - (x + map.actor.offsetx), - (y + map.actor.offsety)
	if map.lastx == tempx and map.lasty == tempy then
		return
	end 
	map.lastx = tempx 
	map.lasty = tempy
	for k,v in pairs(map.cellimage) do
		v.cc_sprite:setPosition(v.x + tempx, utils.righty(v.y + tempy))
	end
end

return map

