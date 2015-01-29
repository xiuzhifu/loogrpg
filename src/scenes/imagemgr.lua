local imagemgr =  {
	catch = {},
	images = {}
}
function imagemgr:getimage(images, id)
		if not self.images[images] then
			self.images[images] = true
			display.addSpriteFrames(images..".plist", images..".png")
		end
	local name = string.format(images.."_%06d.bmp", id)
	if imagemgr.catch[name] then
		return imagemgr.catch[name]
	end
	local frame = display.newSpriteFrame(name)
	imagemgr.catch[name] = frame
	return frame
end

function imagemgr:getimage2(images, action, id)
		if not self.images[images] then
			self.images[images] = true
			display.addSpriteFrames("res/"..images..".plist", "res/"..images..".png")
		end
	local name = images.."/"..action.."/"..id..".png"
	if imagemgr.catch[name] then
		return imagemgr.catch[name]
	end
	local frame = display.newSpriteFrame(name)
	imagemgr.catch[name] = frame
	return frame
end

return imagemgr