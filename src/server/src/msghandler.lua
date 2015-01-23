local const = require "const"
local struct = require "struct"
local mh = {}
mh[const.sm_login] = function(msg)
	local s, next = struct.unpack(">s", msg, 3)
	print(s, next)
	s, next = struct.unpack(">s", msg, next)
	print(s, next)
end
return mh