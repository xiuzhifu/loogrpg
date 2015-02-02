local sprite =  {
	catch = {}
}
function sprite.new(images, action, dir)
	local name = images.."_"..tostring(action.start).."_%02d.png"
	local cathchname = tostring(dir)..name
	if sprite.catch[cathchname] then
		return sprite.catch[cathchname]
	end
	local frames = display.newFrames(name, 1, action.count * dir)
	sprite.catch[cathchname] = frames
	return frames
end
return sprite