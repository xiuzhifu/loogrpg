local socket = require "socket"
local netmgr = {
	handler = {},
	msglist ={}
}
function netmgr.new()
	print(socket._VERSION)
end
function netmgr.addmessagehandler(id, func)
	netmgr.handler[tostring(id)] = func
end

function netmgr.deletemessagehandler(id)
	netmgr.handler[id] = nil
end

function netmgr.dispatch()
	for i=1,#netmgr.msglist do
		local msg = netmgr.msglist[i]
		if netmgr.handler[msg.id] then
			netmgr.handler[msg.id](msg)
		end
	end
	netmgr.msglist = {}
end

function netmgr.addmsg(msg)
	table.insert(netmgr.msglist, msg)
end

function netmgr.send(msg)
	netmgr.socket:send(msg)
end

function netmgr.connect(ip, port)
	netmgr.socket = socket.connect(ip, port)
end

netmgr.new()
netmgr.connect("localhost", 8858)

return netmgr