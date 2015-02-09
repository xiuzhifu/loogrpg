local actormgr = require "actormgr"
local utils = require "utils"
local const = require "const"
local magicconfig = require "magicconfig"
local magic = require "magic"
local magicconfig = require "magicconfig"
local effectconfig = require "effectconfig"
local camera = require "camera"
local netmgr = require "netmgr"
local map = require "map"
local monster = require "monster"
local monsterconfig = require "monsterconfig"

local scheduler = require (cc.PACKAGE_NAME..".scheduler")
--[[
	currentscene 1.登陆 2.创建 3.游戏
]]
local gamescene = {
	tick = 0,
	uilist = {},
	__gc = function()
		scheduler.unscheduleGlobal(gamescene.timer)
	end
}
local map = require "map"
local uiplayerinfo = require "ui/uiplayerinfo"
local uimonsterinfo = require "ui/uimonsterinfo"

function gamescene.new(scene)
	gamescene.scene = scene
	gamescene.scenenode = display.newScene("gamescene")
	gamescene.maplayer = display.newNode()
	gamescene.actorlayer = display.newNode()
	gamescene.magiclayer = display.newNode()
	gamescene.uilayer = display.newNode()
	gamescene.scenenode:addChild(gamescene.maplayer)
	gamescene.scenenode:addChild(gamescene.actorlayer)
	gamescene.scenenode:addChild(gamescene.magiclayer)
	gamescene.scenenode:addChild(gamescene.uilayer)
	map.new(gamescene.maplayer)
	gamescene.msg_loadmap()
	gamescene.msg_createplayer()
	uiplayerinfo.new(gamescene.uilayer)
	table.insert(gamescene.uilist, uiplayerinfo)

	uimonsterinfo.new(gamescene.uilayer)
	table.insert(gamescene.uilist, uimonsterinfo)	
	
	gamescene.scenenode:setTouchEnabled(true)
	gamescene.scenenode:addNodeEventListener(cc.NODE_TOUCH_EVENT, gamescene.ontouch)
	gamescene.timer = scheduler.scheduleGlobal(gamescene.update, 0.01 * 1)
	return gamescene
end

function gamescene.gettickcount()
	return gamescene.tick
end

function gamescene.update(dt)
	gamescene.tick = gamescene.tick + math.floor(dt * 1000)
	gamescene.player:update(gamescene.tick)
	camera.update(gamescene.tick, dt * 1000)
	map.move(gamescene.tick)
	map.update(gamescene.tick)

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

function gamescene.oneclosetoone(sx, sy, tx, ty, step)
	local x, y = math.abs(tx - sx), math.abs(ty - sy)
	if x <= step and y <= step then return true else return false end
end

function gamescene.ontouch(event)
		if gamescene.player.currentaction ~= 0 then return end
        --printf("node in scene [%s] NODE_EVENT: %s", gamescene.scenenode.name, event.name)
        local tempx, tempy = camera.getposinscene(event.x, utils.righty(event.y))
        
        local actor = gamescene.getactor(tempx, tempy)
        uimonsterinfo.setmon(actor)
        if actor then
        	local dir = utils.getdir(actor.x, actor.y, gamescene.player.x, gamescene.player.y)
        	if dir > -1 then
	        	if gamescene.oneclosetoone(actor.x, actor.y, gamescene.player.x, gamescene.player.y, 1) then
	        		gamescene.player_turn(dir)
	   				gamescene.player_hit(actor)
	        	else
	        		--dir = utils.getdir(gamescene.player.x, gamescene.player.y, actor.x, actor.y)
		    		gamescene.player_move(dir)     
	        	end
	        end
        else
        	local x , y = map.getmapposition(event.x, event.y)
   			local dir = utils.getdir(gamescene.player.x, gamescene.player.y, x, y)
	    	gamescene.player_move(dir)
		end
end

function gamescene.getactor(x, y)
	for i,v in ipairs(actormgr.actorlist) do
		if math.abs(v.x - x) < 2 and math.abs(v.y - y) < 2 then
			return v
		end
	end
	return nil
end

function gamescene.player_move(dir)
	if dir < 0 or dir > 7 then return end
	local act = {ident = const.sm_run, d = dir}
	gamescene.player:addaction(act)
	--act = {ident = const.sm_walk, d = dir}
	--gamescene.mon:addaction(act)
end

function gamescene.player_turn(dir)
	gamescene.player.dir = dir 
end

function gamescene.player_hit(actor)
	local act = {ident = const.sm_hit}
	actor.attri.hp = actor.attri.hp - 200
	if actor.attri.hp <= 0 then
	local act = {ident = 1004, d = dir}	
		actor:addaction(act)
	end
	gamescene.player:addaction(act)	
end

function gamescene.actor_move(dir)
	if dir < 0 or dir > 7 then return end
	--print(gamescene.player.x, gamescene.player.y, dir)
	local act = {ident = const.sm_walk, d = dir}
	gamescene.tmpactor:addaction(act)
end

function gamescene.msg_loadmap()
	map.loadmap("1016")
end

function gamescene.msg_createplayer( ... )
	local actor = actormgr.newplayer(gamescene.actorlayer, 100, 1, "布衣")
	print("center:",camera.centerx, camera.centery)
	actor.x = 27
	actor.y = 40
	actor.dir = 4
	actor.attri.hp = 1000
	actor.attri.hpmax = 800
	gamescene.player = actor
	map.focusactor(actor)
	map.move(gamescene.gettickcount())
	map.update()
	--scene.msg_magic()
	--scene.msg_fixeffect()
	--gamescene.msg_flyeffect()
	--local effect = magic.create_actoreffect(effectconfig[2], actor)
	--actor:addeffect(effect)
	uiplayerinfo.setplayer(actor)

	local mon = monster.new(monsterconfig["雪人王"])
	gamescene.actorlayer:addChild(mon.cc_sprite)
	mon.x = 27
	mon.y = 41
	mon.dir = 4
	mon.attri.hp = 1000
	mon.attri.hpmax = 1000
	gamescene.mon = mon
	table.insert(actormgr.actorlist, mon)
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

	local effect = magic.create_flyeffect(effectconfig[3], gamescene.magiclayer, gamescene.player.x, 
		gamescene.player
		, 20, 15, effectconfig[1], gamescene.player)
	
end

function gamescene.msg_actorattri( ... )
	
end

netmgr.addmessagehandler(const.sm_walk, gamescene.msg_walk)
netmgr.addmessagehandler(const.sm_run, gamescene.msg_run)
netmgr.addmessagehandler(const.sm_magic, gamescene.msg_magic)
netmgr.addmessagehandler(const.sm_actorattri, gamescene.msg_actorattri)

return gamescene


