local const = require "const"
local netmgr = require "netmgr"
local ls = {
	
}

function ls.new(scene, scenenode)
	print(scene, scenenode)
	ls.scene = scene
	ls.scenenode = scenenode
	ls.node = cc.uiloader:load("Login.csb")
	-- 解析成功后，会返回场景/UI的根节点，将其加入场景即可显示
	if ls.node then
	    ls.node:setPosition(0, 0)
	    scenenode:addChild(ls.node)
	end

	local butlogin = cc.uiloader:seekNodeByTag(ls.node, 25)
	butlogin:addTouchEventListener(ls.onloginclick)

	ls.username =  cc.uiloader:seekNodeByTag(ls.node, 31)
	ls.password =  cc.uiloader:seekNodeByTag(ls.node, 32)

	return ls
end

function ls.update(tick)
	
end

function ls.onloginclick(sender, event)
	if event == 2 then
		print(ls.username:getString(),
		ls.password:getString())
		local s = string.pack(">hz2",const.cm_login, ls.username:getString(),ls.password:getString())
		s = string.pack(">hA", #s, s)
		netmgr.send(s)
	end
end

function ls.msg_login(msg)
	local next, ret = string.unpack(msg, ">H", 3)
	if ret == 1 then
		print("登陆成功")
		ls.scene.changescene(3)
	elseif ret == 2 then
		print("登陆失败")
	end	
end

netmgr.addmessagehandler(const.sm_login, ls.msg_login)
return ls