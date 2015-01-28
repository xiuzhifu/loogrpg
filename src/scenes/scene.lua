--[[
	currentscene 1.登陆 2.创建 3.游戏
]]
local scene = {}
function scene.new()	
	scene.changescene("gamescene")
end

function scene.changescene(id)
	print(id)
	local s = require(id).new(scene)
	if s and type(s) =="table" then
		display.replaceScene(s.scenenode)
	end
end

return scene
