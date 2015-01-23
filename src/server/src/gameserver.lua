local gs = {
	tick = 0,
	playerlist = {}
}
local struct = require "struct"
local msghandler = require "msghandler"
local player = require "player"
function gs.new()
	local t = setmetatable({}, gs)
	for k,v in pairs(gs) do
		t[k] = v
	end
	return t
end

function gs:newplayer(sock, client)
	local p = player.new()
	p.sock = sock
	p.client = client
	p.runing = true
	self.playerlist[client] = p
	return p
end

function gs:deleteplayer(client)
	self.playerlist[client] = nil
end

function gs:update(tick)
	--print(tick)
	self.tick = tick
	for k,v in pairs(self.playerlist) do
		v:update(tick)
	end
end

function gs:test()
	-- body
end

return gs
