local actormgr = require "actormgr"
local utils = require "utils"
local const = require "const"
local magicconfig = require "magicconfig"
local magic = require "magic"
local magicconfig = require "magicconfig"
local effectconfig = require "effectconfig"
local camera = require "camera"
local scene = {
	tick = 0,
	__gc = function()
		scheduler.unscheduleGlobal(scene.timer)
	end
}
local map = require "map"
local scheduler = require (cc.PACKAGE_NAME..".scheduler")

function scene.new()
	local map2 =  require "map2"

	for k,v in pairs(map2) do
		print("2",k,v)
	end

	local socket = require("socket")
	print(socket._VERSION)
	scene.scene = display.newScene("myscene")
	scene.maplayer = display.newNode()
	scene.actorlayer = display.newNode()
	scene.magiclayer = display.newNode()
	scene.scene:addChild(scene.maplayer)
	scene.scene:addChild(scene.actorlayer)
	scene.scene:addChild(scene.magiclayer)

	scene.timer = scheduler.scheduleGlobal(scene.update, 0.03 * 100)

	map.new(scene.maplayer)
	scene.msg_loadmap()
	scene.msg_createplayer()

	scene.scene:setTouchEnabled(true)
	scene.scene:addNodeEventListener(cc.NODE_TOUCH_EVENT, scene.ontouch)
	return scene.scene
end

function scene.gettickcount()
	return scene.tick
end

function scene.update(dt)
	scene.tick = scene.tick + math.floor(dt * 1000)
	
	scene.player:update(scene.tick)
	map.move(scene.tick)
	map.update(scene.tick)
	map.setactorposition()
	for i,v in ipairs(actormgr.actorlist) do
		v:update(scene.tick)
	end
	for i,v in ipairs(magic.effectlist) do
		if not v:update(scene.tick, scene.player) then
			scene.magiclayer:removeChild(v.cc_sprite)
			table.remove(magic.effectlist, i)
		end
	end
end

function scene.player_move(dir)
	if dir < 0 or dir > 7 then return end

	local act = {ident = const.sm_run, d = dir}
	scene.player:addaction(act)
end

function scene.actor_move(dir)
	if dir < 0 or dir > 7 then return end
	--print(scene.player.x, scene.player.y, dir)
	local act = {ident = const.sm_run, d = dir}
	scene.tmpactor:addaction(act)
end

function scene.ontouch(event)
        printf("node in scene [%s] NODE_EVENT: %s", scene.scene.name, event.name)
        local x , y = map.getmapposition(event.x, event.y)
        local dir = utils.getdir(scene.player.x, scene.player.y, x, y)
        scene.player_move(dir)
        --scene.actor_move(dir)
        --return true
end

function scene.msg_loadmap()
	map.loadmap("map.png")
end

function scene.msg_createplayer( ... )
	local actor = actormgr.newplayer(scene, 100, 1, "布衣")
	actor.x = camera.centerx
	actor.y = camera.centery
	actor.dir = 4
	print(998,actor.x, actor.y)
	scene.player = actor
	map.focusactor(actor)
	map.move()
	map.update()
	map.setactorposition()

	actor = actormgr.newactor(scene, 100, 1, "布衣")
	actor.x = 10
	actor.y = 10
	actor.dir = 4
	actor:setposition(camera.getposincamera(actor.x, actor.y))
	scene.tmpactor = actor
	--scene.msg_magic()
	--scene.msg_fixeffect()
	scene.msg_flyeffect()
	--local effect = magic.create_actoreffect(effectconfig[2], actor)
	--actor:addeffect(effect)
end

function scene.msg_walk( ... )
	-- body
end

function scene.msg_run( ... )
	-- body
end

function scene.msg_magic( ... )
	local effect = magic.create_effect(effectconfig[1], scene.magiclayer)
	effect:setposition(100, utils.righty(100))
	table.insert(magic.effectlist, effect)
end

function scene.msg_fixeffect( ... )
	local effect = magic.create_fixeffect(effectconfig[1], scene.magiclayer, 20, 20)
end

function scene.msg_flyeffect( ... )
	--local effect = magic.create_flyeffect(effectconfig[3], scene.magiclayer, 20, 10, 10, 10,effectconfig[1])

	local effect = magic.create_flyeffect(effectconfig[3], scene.magiclayer, scene.tmpactor.x, 
		scene.tmpactor
		, 20, 15, effectconfig[1], scene.tmpactor)
	
end

return scene


