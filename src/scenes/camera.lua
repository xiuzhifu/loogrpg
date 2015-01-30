
--[[
	1. mode 为地图卷动方式
		normal 根据图片帧数(类似传奇)
		flat 按照像素
		follow 按像素，切镜头跟随(类似魔力宝贝)
]]
local normal = 0
local flat = 1
local follow = 2
local const = require "const"
local utils = require "utils"
camera =
{
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
	offsetx = 0, 
	offsety = 0,
	centerx =0, 
	centery =0, 
	player = nil,
	mode = flat,
	lasttick = 0,
}
function camera.init(width, height)
	camera.width =  width
	camera.height = height
	camera.centerx = math.floor(const.screenwidth / const.mapcellwidth / 2)
	camera.centery = math.floor(const.screenheight / const.mapcellheight / 2)
	camera.centeroffsetx = math.floor((const.screenwidth % const.mapcellwidth) / 2)
	camera.centeroffsety = math.floor((const.screenheight % const.mapcellheight) / 2)
end

function camera.focusactor(player)
	camera.player = player
	
	local action = player.config[1000]
	camera.walkspeedx = const.mapcellwidth * action.movestep / (action.time * action.count)
	camera.walkspeedy = const.mapcellheight * action.movestep / (action.time * action.count)
	camera.walktime = action.time * action.count
	action = player.config[1001]
	camera.runspeedx = const.mapcellwidth * action.movestep / (action.time * action.count)
	camera.runspeedy = const.mapcellheight * action.movestep / (action.time * action.count)
	camera.runtime = action.time * action.count
end
function camera.move(tick)
	if camera.x == camera.player.x and camera.y == camera.player.y then return false end
	camera.x = camera.player.x
	camera.y = camera.player.y
	camera.offsetx = 0
	camera.offsety = 0
	camera.lasttick = 0
	if camera.x and camera.x then
		camera.left = camera.x - camera.centerx
		--if camera.left < 0 then camera.left = 0 end
		camera.right = camera.x + camera.centerx
		--if camera.right > camera.width then camera.right = camera.width end
		camera.top = camera.y - camera.centery
		--if camera.top < 0 then camera.top = 0 end
		camera.bottom = camera.y + camera.centery
		--if camera.bottom > camera.height then camera.bottom = camera.height end
	end
	return true
end
function camera.isactorincamera(actor)
	local x = actor.x 
	local y = actor.y
	if x >= camera.left and x <= camera.right and y >= top and y <= camera.bottom then
	return true, camera.getposincamera(x, y)
	else
	return false
	end
end
function camera.getposincamera(x, y)
	return (x - camera.left) * const.mapcellwidth + camera.centeroffsetx, 
		(y - camera.top) * const.mapcellheight + camera.centeroffsety
end

function camera.getposincamera2(x, y)
	return (x - camera.left) * const.mapcellwidth + camera.centeroffsetx - camera.offsetx, 
		(y - camera.top) * const.mapcellheight + camera.centeroffsety - camera.offsety
end

function camera.getposinscene(x, y)
	return camera.left + math.floor(x / const.mapcellwidth),
		camera.top + math.floor(y / const.mapcellheight)
end

function camera.getcameraxy()
	return camera.left * const.mapcellwidth, camera.top * const.mapcellheight
end

function camera.getcamerarect()
	return {left =camera.left * const.mapcellwidth, top = camera.top * const.mapcellheight,
		right = camera.right * const.mapcellwidth, bottom = camera.bottom * const.mapcellheight}
end

function camera.getrect()
	return {left =camera.left, top = camera.top, right = camera.right, bottom = camera.bottom}
end

function camera.getcameraoffset()
	return camera.offsetx, camera.offsety
end

local i = 0
function camera.update(tick)
	if camera.mode == normal then
		camera.offsetx = camera.player.offsetx
		camera.offsety = camera.player.offsety	
	elseif camera.mode == flat then
		if camera.player.currentaction == 1000 then
			if camera.lasttick == 0 then camera.lasttick = tick end
			local t = tick - camera.lasttick
			if t > camera.walktime then return end
			camera.offsetx =  utils.actordir[camera.player.dir + 1][1] * t * camera.walkspeedx
			camera.offsety =  utils.actordir[camera.player.dir + 1][2] * t * camera.walkspeedy
		elseif camera.player.currentaction == 1001 then
			if camera.lasttick == 0 then camera.lasttick = tick end
			local t = tick - camera.lasttick
			--if t > camera.runtime then return end
			print(camera.offsetx, camera.player.offsetx, t)
			camera.offsetx =  utils.actordir[camera.player.dir + 1][1] * t * camera.runspeedx
			camera.offsety =  utils.actordir[camera.player.dir + 1][2] * t * camera.runspeedy
		end
	end
end

return camera