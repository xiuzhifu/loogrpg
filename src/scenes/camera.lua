local const = require "const"
camera =
{
	left = 0,
	right = 0,
	top = 0,
	bottom = 0
}
function camera.init(width, height)
	camera.width =  width
	camera.height = height
end
function camera.move(x, y, actor)
	camera.x = x
	camera.y = y
	camera.actor = actor
	if x and y then
		camera.left = x - 15
		if camera.left < 0 then camera.left = 0 end
		camera.right = x + 15
		if camera.right > camera.width then camera.right = camera.width end
		camera.top = y - 10
		if camera.top < 0 then camera.top = 0 end
		camera.bottom = y + 10
		if camera.bottom > camera.height then camera.bottom = camera.height end
	end
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
	return (x - camera.left) * const.mapcellwidth, 
		(y - camera.top) * const.mapcellheight
end

function camera.getposinscene(x, y)
	return camera.left + math.floor(x / const.mapcellwidth),
		camera.top + math.floor(y / const.mapcellheight)
end

function camera.getcamerarect()
	return camera.left * const.mapcellwidth , camera.top * const.mapcellheight
end

function camera.get( ... )
	-- body
end

return camera