


local socket = require "levent.socket.c"
local levent = require "levent.levent"
local timeout = require "levent.timeout"
local struct = require "struct"

function handle_client(gs, csock, clientid)
    local host, port = csock:getpeername()
    csock:setblocking(false)
    print("New connection from:", host, port)
    local msg, err
    local player = gs:newplayer(csock, clientid)
    local msgbuf = ""
    while true do
    	if not player.runing then break end
        msg, err = csock:recv(1024 * 4)
        if msg then
	       	msgbuf = msgbuf..msg
	        local len = #msgbuf
	        if len > 2 then
	        	local l = struct.unpack(">I2", msgbuf)
	        	if len >= l + 2 then
	        		local s = string.sub(msg, 3, l + 2)
	        		player:addmsg(s)
	        	end
	        	msgbuf = string.sub(msgbuf, l + 2 + 1, len)
	        end
	    end
	    levent.sleep(0.01)
    end
    csock:close()
    print("Connection close:", host, port)
end

local function socketthread(gs)
   local sock, err = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   sock:setblocking(false)
    assert(sock, err)
    print("bind:", sock:bind("0.0.0.0", 8858))
    print("listen:", sock:listen())
    local clientid = 0
    while true do
        csock, err = sock:accept()
        clientid = clientid + 1
       --print(csock, err)
        if csock then
        	levent.spawn(handle_client, gs[1], csock, clientid) 
        end
        levent.sleep(0.01)
    end
end


local function mainthread(func) 
    local tick = 0
    while true do
    	for i,v in ipairs(func) do
    		if v.update then
    			v:update(tick)
    		end
    	end
        tick = tick + 100
        levent.sleep(0.1)
    end
end

local function start(...)
    levent.spawn(socketthread, ...)
    levent.spawn(mainthread, ...)
end


return function(...)
    levent.start(start, ...)
end



