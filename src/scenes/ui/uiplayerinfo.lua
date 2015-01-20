local camera = require "camera"
local utils = require "utils"
local playerinfo = {
	
}

local pi = playerinfo

function playerinfo.new(scene)
	pi.cc_sprite = display.newNode()
	scene:addChild(pi.cc_sprite)
	pi.cc_background = display.newSprite("UI/ui_playerinfo/player_head.png")
	pi.cc_hp = display.newSprite("UI/ui_playerinfo/hp.png")
	pi.cc_mp = display.newSprite("UI/ui_playerinfo/mp.png")

	pi.hprect = pi.cc_hp:getTextureRect()
	pi.hpwidth = pi.hprect.width

	pi.mprect = pi.cc_mp:getTextureRect()
	pi.mpwidth = pi.mprect.width

	display.align(pi.cc_background, display.LEFT_TOP)
	display.align(pi.cc_hp, display.LEFT_TOP)
	display.align(pi.cc_mp, display.LEFT_TOP)


	
	pi.cc_sprite:addChild(pi.cc_background)
	pi.cc_sprite:addChild(pi.cc_hp)
	pi.cc_sprite:addChild(pi.cc_mp)

	pi.cc_background:setPosition(0, utils.righty(0))
	pi.cc_hp:setPosition(121, utils.righty(42))
	pi.cc_mp:setPosition(112, utils.righty(68))
	 

	cc.ui.UILabel.new({text = "0/0", size = 15})
        :align(display.CENTER, 10, 5)  
        :addTo(pi.cc_hp)
end

function playerinfo.update(tick)
	local atti = playerinfo.player.atti
	local hp, hpmax = atti.hp, atti.hpmax
	hp , hpmax = 60, 100
	if hp ~= pi.hp then
		pi.hp = hp
		pi.hprect.width = math.floor(pi.hpwidth * hp / (hpmax + 1))
		playerinfo.cc_hp:setTextureRect(pi.hprect)
	end
	if mp ~= pi.mp then
		local mp, mpmax = atti.mp, mpmax
		pi.mprect.width = math.floor(pi.mpwidth * mp / (mpmax + 1))
		playerinfo.cc_mp:setTextureRect(pi.mprect)
	end
end

function playerinfo.setplayer(player)
	playerinfo.player = player
end

return playerinfo