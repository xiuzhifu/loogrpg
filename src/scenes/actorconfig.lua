local actorconfig = {}

local baseaction ={
	[1002] = {start = "attack0", count = 2, time = 100, movestep = 0},
	[1003] = {start = "attack1", count = 6, time = 100, movestep = 0},
	[1004] = {start = "attacked", count = 3, time = 50, movestep = 0},
	[1005] = {start = "death", count = 6, time = 100, movestep = 0},
	[1006] = {start = "jump", count = 10, time = 100, movestep = 0},
	[1007] = {start = "magic1", count = 6, time = 100, movestep = 0},
	[1008] = {start = "magic2", count = 5, time = 100, movestep = 0},
	[1009] = {start = "push", count = 6, time = 100, movestep = 0},
	[1001] = {start = "run", count = 12, time = 50, movestep = 2},
	[1010] = {start = "shoot1", count = 5, time = 100, movestep = 0},
	[1011] = {start = "shoot2", count = 7, time = 100, movestep = 0},
	[0] = {start = "stand", count = 6, time = 100, movestep = 0},
	[1000] = {start = "walk", count = 8, time = 100, movestep = 1},
}

actorconfig.dresses = {
	["布衣"] = {
	images = "women1",
	action = baseaction,
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