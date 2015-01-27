import os
#读取配置 time 消息编号
cfg = open("./config.txt", "r")
actioncfg = {}
for line in cfg:
	pos = line.index("=")
	ident = line[0: pos]
	pos2 = line.index(",")
	name = line[pos+ 1: pos2]
	pos3 = line.index(",", pos2 + 1)
	time = line[pos2 + 1:pos3]
	movestep = line[pos3 + 1:]
	
	if not name in actioncfg:
		actioncfg[name] = {}
	actioncfg[name][ident] = {"time": time, "movestep": movestep}
	print(ident,name,time, movestep)
cfg.close()

#配置文件
pathname = os.path.basename(os.getcwd())
fp = open("./" + pathname + ".lua", "w")
fp.write("return = {\n")

for item in os.listdir("."):
	if os.path.isdir(item):
		if actioncfg[item]:
			changename = True
			for key, it in actioncfg[item].items():
				index = 1
				print(key, item)
				fp.write("	" + key + " = {")
				fp.write("start = \"" + item + "\"")
				for filename in os.listdir(item):
					global index
					fn = "./" + item + "/" + filename
					#需要改名
					if changename:
						os.rename(fn, item + "/" + str(index) + ".png")
					index += 1
				changename = False
				index -= 1
				fp.write( ", count = " + str(index // 8))
				fp.write(", time = " + it["time"].strip())
				fp.write(", movestep = " + it["movestep"].strip() +"}\n")

fp.write("}\n")
fp.close()
