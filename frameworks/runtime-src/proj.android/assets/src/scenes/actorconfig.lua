local actorconfig = {}

local baseaction =
{
	stand = {start = 0  ,count = 4,  skip = 4, time=200},
	walk =  {start = 64 ,count = 6,  skip = 2, time=50},
	run =   {start = 128,count = 6,  skip = 2, time=50},
	hit =   {start = 328,count = 10, skip = 0, time=100},
	magic = {start = 100,count = 10, skip = 6, time=100},
	behit = {start = 100,count = 10, skip = 6, time=100},
	death = {start = 100,count = 10, skip = 6, time=100}
}

actorconfig.dresses = {
	["布衣"] = {
	start = 0,
	images = "hum5"
	}
}

actorconfig.weapones = {
	["木棍"] = {
	images = "hum",
	start = 0,
	effectstart = 1000,
	}
}

actorconfig[1] = baseaction

return actorconfig