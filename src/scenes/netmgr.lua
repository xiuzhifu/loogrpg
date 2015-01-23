local socket = require "socket"
local const = require "const"
local netmgr = {
	handler = {},
	msglist ={},
	msgbuf = "",
	lasttick = 0
}
local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"
function netmgr.new()
	netmgr.socket = socket:tcp()
	netmgr.socket:settimeout(0)
	--netmgr.socket:shutdown("both")
	print(socket._VERSION)
end
function netmgr.addmessagehandler(id, func)
	netmgr.handler[id] = func
end

function netmgr.deletemessagehandler(id)
	netmgr.handler[id] = nil
end

function netmgr.update(tick)
	--if tick - netmgr.lasttick < 200 then return end
	netmgr.lasttick = tick
	-- if use "*l" pattern, some buffer will be discarded, why?
	local __body, __status, __partial = netmgr.socket:receive(1024)	-- read the package body
	if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
		netmgr.socket:close()
		return
	end
	if 	(__body and string.len(__body) == 0) or 
		(__partial and string.len(__partial) == 0) then return end
	if __body or __partial then 
		if __body then netmgr.msgbuf = netmgr.msgbuf..__body end
		if __partial then netmgr.msgbuf = netmgr.msgbuf .. __partial end
		local len = #netmgr.msgbuf
        if len > 2 then
        	local next, l = string.unpack(netmgr.msgbuf, ">H")
        	if len >= l + 2 then
        		local s = string.sub(netmgr.msgbuf, 3, l + 2)
        		netmgr.addmsg(s)
        	end
        	netmgr.msgbuf = string.sub(netmgr.msgbuf, l + 2 + 1, len)
        end
    end
    netmgr.dispatch()
end

function netmgr.dispatch()
	if #netmgr.msglist == 0 then return end
	for i=1,#netmgr.msglist do
		local msg = netmgr.msglist[i]
		local next, id = string.unpack(msg, ">H")
		if netmgr.handler[id] then
			netmgr.handler[id](msg)
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
	local succ, status = netmgr.socket:connect(ip, port)
	return succ == 1 or status == STATUS_ALREADY_CONNECTED
end

netmgr.new()
netmgr.connect("localhost", 8858)

return netmgr