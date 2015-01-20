local netmgr = {
	handler = {},
	msglist ={}
}
function netmgr.addmessagehandler(id, func)
	netmgr.handler[id] = func
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

return netmgr