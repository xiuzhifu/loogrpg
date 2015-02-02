local const = require "const"
local netmgr = require "netmgr"
local ls = {
	
}

function ls.new(scene)
	ls.scene = scene
	ls.node = cc.uiloader:load("Login.csb")
	-- 解析成功后，会返回场景/UI的根节点，将其加入场景即可显示
	if ls.node then
	    ls.node:setPosition(0, 0)
	    scene:addChild(ls.node)
	end

	local butlogin = cc.uiloader:seekNodeByTag(ls.node, 25)
	butlogin:addTouchEventListener(ls.onloginclick)

	ls.username =  cc.uiloader:seekNodeByTag(ls.node, 31)
	ls.password =  cc.uiloader:seekNodeByTag(ls.node, 32)

	return ls
end

function ls.update(dt)
	
end

function ls.onloginclick(event)
	print(ls.username:getString(),
	ls.password:getString())
	netmgr.send(const.cm_login, )
	return true
end

function ls.msg_login(msg)
	print("wangba")
	
end

netmgr.addmessagehandler(const.sm_login, ls.msg_login)
return ls