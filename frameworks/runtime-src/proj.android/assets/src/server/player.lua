local player =  {
	
}
--[[
	t.hp = config.hp
	t.mp = config.mp
	t.maxhp = config
	t.sex = config.sex
]]
function player.new(config)
	local t = {}
	for k,v in pairs(config) do
		t[k] = v
	end
	return t 
end

function player.run(x, y)
	-- body
end

function player:walk(x, y)
	-- body
end