--[[
	currentscene 1.登陆 2.创建 3.游戏
]]
local map = require "map"
local utils = require "utils"
local scene = {
	tick = 0,
	uilist = {},
	__gc = function()
		scheduler.unscheduleGlobal(scene.timer)
	end
}

local gamescene = require "gamescene"
local loginscene = require "loginscene"
local createplayerscene = require "createplayerscene"
local netmgr = require "netmgr"

local scheduler = require (cc.PACKAGE_NAME..".scheduler")

function scene.new()	
	scene.scene = display.newScene("myscene")
	
	scene.scene:setTouchEnabled(true)
	scene.scene:addNodeEventListener(cc.NODE_TOUCH_EVENT, scene.ontouch)
	scene.loginlayer = display.newNode()
	scene.createplayerlayer = display.newNode()
	scene.gamelayer = display.newNode()
	scene[1] = loginscene.new(scene, scene.loginlayer)
	scene[2] = createplayerscene.new(scene, scene.createplayerlayer)
	scene[3] = gamescene.new(scene, scene.gamelayer)
	scene.changescene(1)
	scene.timer = scheduler.scheduleGlobal(scene.update, 0.03 * 100)
	scene.test()
	return scene.scene
end

function scene.gettickcount()
	return scene.tick
end

function scene.test( ... )

end

function scene.update(dt)
	scene.tick = scene.tick + math.floor(dt * 1000)
	scene.currentscene.update(scene.tick)
	netmgr.update(scene.tick)
end

function scene.changescene(id)
	if id and id > 0 and id < 4 then
		if scene.currentscene then scene.scene:removeChild(scene.currentscene.scenenode, false) end
		scene.currentscene = scene[id]
		scene.scene:addChild(scene.currentscene.scenenode)
	end
end

function scene.ontouch(event)
	return false
end

return scene
