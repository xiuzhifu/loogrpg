package.path = package.path..";./src/?.lua"
local start = require "start"
local gameserver = require "gameserver"
local gs1 = gameserver.new()
start({gs1})