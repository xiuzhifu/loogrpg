local actormgr = require "actormgr"
local utils = require "utils"
local const = require "const"
local magicconfig = require "magicconfig"
local magic = require "magic"
local magicconfig = require "magicconfig"
local effectconfig = require "effectconfig"
local camera = require "camera"
local netmgr = require "netmgr"
--[[
	currentscene 1.登陆 2.创建 3.游戏
]]
local gamescene = {
	tick = 0,
	uilist = {}
}
local map = require "map"
local uiplayerinfo = require "ui/uiplayerinfo"

function gamescene.new(scene)
	gamescene.scene = scene
	gamescene.maplayer = display.newNode()
	gamescene.actorlayer = display.newNode()
	gamescene.magiclayer = display.newNode()
	gamescene.uilayer = display.newNode()
	gamescene.scene:addChild(gamescene.maplayer)
	gamescene.scene:addChild(gamescene.actorlayer)
	gamescene.scene:addChild(gamescene.magiclayer)
	gamescene.scene:addChild(gamescene.uilayer)
	map.new(gamescene.maplayer)
	gamescene.msg_loadmap()
	gamescene.msg_createplayer()
	uiplayerinfo.new(gamescene.uilayer)
	table.insert(gamescene.uilist, uiplayerinfo)

	gamescene.scene:setTouchEnabled(true)
	gamescene.scene:addNodeEventListener(cc.NODE_TOUCH_EVENT, gamescene.ontouch)
	return gamescene
end

function gamescene.gettickcount()
	return gamescene.tick
end

function gamescene.update(dt)
	gamescene.tick = gamescene.tick + math.floor(dt * 1000)
	
	gamescene.player:update(gamescene.tick)
	map.move(gamescene.tick)
	map.update(gamescene.tick)
	map.setactorposition()
	for i,v in ipairs(actormgr.actorlist) do
		v:update(gamescene.tick)
	end
	for i,v in ipairs(magic.effectlist) do
		if not v:update(gamescene.tick, gamescene.player) then
			gamescene.magiclayer:removeChild(v.cc_sprite)
			table.remove(magic.effectlist, i)
		end
	end

	for i,v in ipairs(gamescene.uilist) do
		if v.update then
			v.update(gamescene.tick)
		end
	end
end

function gamescene.ontouch(event)
        printf("node in scene [%s] NODE_EVENT: %s", gamescene.scene.name, event.name)
        local x , y = map.getmapposition(event.x, event.y)
        local dir = utils.getdir(gamescene.player.x, gamescene.player.y, x, y)
        gamescene.player_move(dir)
        --scene.actor_move(dir)
        --return true
end

function gamescene.player_move(dir)
	if dir < 0 or dir > 7 then return end

	local act = {ident = const.sm_run, d = dir}
	gamescene.player:addaction(act)
end

function gamescene.actor_move(dir)
	if dir < 0 or dir > 7 then return end
	--print(gamescene.player.x, gamescene.player.y, dir)
	local act = {ident = const.sm_run, d = dir}
	gamescene.tmpactor:addaction(act)
end

function gamescene.msg_loadmap()
	map.loadmap("1016")
end

function gamescene.msg_createplayer( ... )
	local actor = actormgr.newplayer(gamescene.actorlayer, 100, 1, "布衣")
	print("center:",camera.centerx, camera.centery)
	actor.x = camera.centerx
	actor.y = camera.centery
	actor.dir = 4
	gamescene.player = actor
	map.focusactor(actor)
	map.move()
	map.update()
	map.setactorposition()

	actor = actormgr.newactor(gamescene.actorlayer, 100, 1, "布衣")
	actor.x = 10
	actor.y = 10
	actor.dir = 4
	actor:setposition(camera.getposincamera(actor.x, actor.y))
	gamescene.tmpactor = actor
	--scene.msg_magic()
	--scene.msg_fixeffect()
	gamescene.msg_flyeffect()
	--local effect = magic.create_actoreffect(effectconfig[2], actor)
	--actor:addeffect(effect)
	uiplayerinfo.setplayer(actor)
end

function gamescene.msg_walk( ... )
	-- body
end

function gamescene.msg_run( ... )
	-- body
end

function gamescene.msg_magic( ... )
	local effect = magic.create_effect(effectconfig[1], gamescene.magiclayer)
	effect:setposition(100, utils.righty(100))
	table.insert(magic.effectlist, effect)
end

function gamescene.msg_fixeffect( ... )
	local effect = magic.create_fixeffect(effectconfig[1], gamescene.magiclayer, 20, 20)
end

function gamescene.msg_flyeffect( ... )
	--local effect = magic.create_flyeffect(effectconfig[3], scene.magiclayer, 20, 10, 10, 10,effectconfig[1])

	local effect = magic.create_flyeffect(effectconfig[3], gamescene.magiclayer, gamescene.tmpactor.x, 
		gamescene.tmpactor
		, 20, 15, effectconfig[1], gamescene.tmpactor)
	
end

function gamescene.msg_actorattri( ... )
	
end

netmgr.addmessagehandler(const.sm_walk, gamescene.msg_walk)
netmgr.addmessagehandler(const.sm_run, gamescene.msg_run)
netmgr.addmessagehandler(const.sm_magic, gamescene.msg_magic)
netmgr.addmessagehandler(const.sm_actorattri, gamescene.msg_actorattri)

return gamescene


