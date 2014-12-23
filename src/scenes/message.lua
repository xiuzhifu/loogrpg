tmsg = {
	sign = 0;
	id = 0;
	wparaml = 0;
	wparamr = 0;
	iparam = 0;
		}
messagehandler = {}
messagehandler.messagelist = {}
messagehandler.handlerlist = {}
function messagehandler.onreveiced(msg)
	table.insert(messagehandler.messagelist, msg)	
end
function messagehandler.addahandler(id, func)	
	if not id then return end
	local handler = messagehandler.handlerlist[id];
	if not handler then messagehandler.handlerlist[id] = func end
end

function messagehandler.deleteahandler(id)
	if not id then return end
	table.remove(messagehandler.handlerlist,id)
end
function messagehandler.dispatch()
	for i, v in messagehandler.messagelist do
	if v then 
		local id = v.sign
		local handler = hanglerlist[id]
		if handler then
			handler(v)
		end
	end 
	end
end