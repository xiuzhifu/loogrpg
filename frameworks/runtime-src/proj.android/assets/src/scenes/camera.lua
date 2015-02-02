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
	player = nil
}
function camera.init(width, height)
	camera.width =  width
	camera.height = height
	camera.centerx = math.floor(const.screenwidth / const.mapcellwidth / 2)
	camera.centery = math.floor(const.screenheight / const.mapcellheight / 2)
	camera.offsetx = math.floor((const.screenwidth % const.mapcellwidth) / 2)
	camera.offsety = math.floor((const.screenheight % const.mapcellheight) / 2)
end
function camera.move(player)
	if camera.x == player.x and camera.y == player.y then return false end
	camera.x = player.x
	camera.y = player.y
	camera.player = player
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

function camera.getposincamera(x, y, offset)
	if not offset then
	return (x - camera.left) * const.mapcellwidth - camera.player.offsetx + camera.offsetx, 
		(y - camera.top) * const.mapcellheight - camera.player.offsety + camera.offsety
	else
	return (x - camera.left) * const.mapcellwidth + camera.offsetx, 
		(y - camera.top) * const.mapcellheight + camera.offsety
	end
end

function camera.getposinscene(x, y)
	return camera.left + math.floor(x / const.mapcellwidth),
		camera.top + math.floor(y / const.mapcellheight)
end

function camera.getcameraxy()
	return camera.left * const.mapcellwidth , camera.top * const.mapcellheight
end

function camera.getcamerarect()
	return {left =camera.left * const.mapcellwidth, top = camera.top * const.mapcellheight,
		right = camera.right * const.mapcellwidth, bottom = camera.bottom * const.mapcellheight}
end

function function_name( ... )
	-- body
end

return camera