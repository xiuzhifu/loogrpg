local camera = require "camera"
local utils = require "utils"
local mi = {
	
}

function mi.new(scene)
	mi.cc_sprite = display.newNode()
	scene:addChild(mi.cc_sprite)
	mi.cc_background = display.newSprite("ui_mon.png")
	mi.cc_hp = display.newSprite("ui_monhp.png")

	mi.hprect = mi.cc_hp:getTextureRect()
	mi.hpwidth = mi.hprect.width

	display.align(mi.cc_background, display.LEFT_TOP)
	display.align(mi.cc_hp, display.LEFT_TOP)
	
	mi.cc_sprite:addChild(mi.cc_background)
	mi.cc_sprite:addChild(mi.cc_hp)

	mi.cc_background:setPosition(450, utils.righty(0))
	mi.cc_hp:setPosition(450 + 67, utils.righty(22))

	mi.cc_hptext = cc.ui.UILabel.new({text = "0/0", size = 15})
    mi.cc_hptext:align(display.CENTER, 65, 10)  
    	:addTo(mi.cc_hp)
	mi.cc_sprite:setVisible(false)
end

function mi.update(tick)
	if not mi.mon then return end
	local attri = mi.mon.attri
	local hp, hpmax = attri.hp, attri.hpmax
	if hp ~= mi.hp then
		mi.hp = hp
		mi.hprect.width = math.floor(mi.hpwidth * hp / (hpmax + 1))
		mi.cc_hp:setTextureRect(mi.hprect)
		mi.cc_hptext:setString(hp.."/"..hpmax)
	end
end

function mi.setmon(mon)
	if mon then
		mi.mon = mon
		mi.cc_sprite:setVisible(true)
	else
		mi.cc_sprite:setVisible(false)
	end
end

return mi