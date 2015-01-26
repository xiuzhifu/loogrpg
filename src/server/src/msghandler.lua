local const = require "const"
local struct = require "struct"
local mh = {}
mh[const.sm_login] = function(player, msg)
	local name, next = struct.unpack(">s", msg, 3)
	local password = struct.unpack(">s", msg, next)
	print("login:",name, password)
	local s 
	if name == "gm01" and password == "123456" then
		s = struct.pack(">HHH", 4,const.sm_login, 1)
	else
		s = struct.pack(">HHH", 4, const.sm_login, 2)
	end
	local r = player.sock:send(s)
	print(r, #s)
end

return mh