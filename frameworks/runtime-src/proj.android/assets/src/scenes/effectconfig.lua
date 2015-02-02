local effectconfig = {
	[1] = {
		-- 火墙
		images = "Magic10",
		start = 2490,
		count = 8,
		delay = 100,
		dir = -1,
		playcount = -1,
		blend = 1
	},
	[2] ={
		-- 盾
		images = "Magic10",
		blend = 1,
		start = 2330,
		count = 4,
		delay = 200,
		dir = -1,
		playcount = 2
	},
	[3] = {--火符 飞行道具，playcount 是播放的秒数
		images = "Magic10",
		blend = 1,
		start = 1290,
		count = 3,
		delay = 200,
		dir = -1,
		playcount = -1,
		flytime = 1000
	}
}

return effectconfig