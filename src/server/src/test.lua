package.path = package.path..";./src/?.lua"
local socket = require "levent.socket.c"
local levent = require "levent.levent"
local struct = require "struct"
local sock, err = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
assert(sock, err)
local b = sock:connect("127.0.0.1", 8858)
print(b)
local s = struct.pack(">I2ss", 1008, "gm01", "123456")
s = struct.pack(">I2s", #s, s)
sock:send(s)
msg, err = sock:recv(1024 * 4)
if not msg then return end
local l = struct.unpack(">I2", msg)
print(l)
l = struct.unpack(">I2", msg, 3)
print(l)
l = struct.unpack(">I", msg, 5)
print(l)
