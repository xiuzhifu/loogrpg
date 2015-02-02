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

local scheduler = require (cc.PACKAGE_NAME..".scheduler")

function scene.new()
	local socket = require("socket")
	print(socket._VERSION)
	
	scene.scene = display.newScene("myscene")
	
	scene.scene:setTouchEnabled(true)
	scene.scene:addNodeEventListener(cc.NODE_TOUCH_EVENT, scene.ontouch)
	scene.loginlayer = display.newNode()
	scene.createplayerlayer = display.newNode()
	scene.gamelayer = display.newNode()
	scene[1] = loginscene.new(scene.loginlayer)
	scene[2] = createplayerscene.new(scene.createplayerlayer)
	scene[3] = gamescene.new(scene.gamelayer)
	scene.changescene(1)
	scene.timer = scheduler.scheduleGlobal(scene.update, 0.03 * 1)
	return scene.scene
end

function scene.gettickcount()
	return scene.tick
end

function scene.update(dt)
	scene.tick = scene.tick + math.floor(dt * 1000)
	scene.currentscene.update(dt)
end

function scene.changescene(id)
	if id and id > 0 and id < 4 then
		if scene.currentscene then scene.scene:removeChild(scene.currentscene.scene) end
		scene.currentscene = scene[id]	
		print(scene.currentscene, scene[id], id, "oop")
		scene.scene:addChild(scene.currentscene.scene)
	end
end

function scene.ontouch(event)
	return false
end

return scene


