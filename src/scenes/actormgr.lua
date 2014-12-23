local actormgr = {
	actorlist ={}
}
local actorconfig = require "actorconfig"
local actor = require "actor"
function actormgr.newactor(scene, id, type, dress, weapon)
	local t
	if actorconfig[type] then
		t = actor.new(actorconfig[type])
	end

	if dress and actorconfig.dresses[dress] then
		t:setdress(actorconfig.dresses[dress])
	end

	if weapon and actorconfig.weapones[weapon] then
		t:setweapon(actorconfig.weapones[weapon])
	end

	scene.actorlayer:addChild(t.cc_sprite)--加入到显示列表

	table.insert(actormgr.actorlist, t)
	return t
end

return actormgr