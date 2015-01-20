local gs = {
	__gc = function()
		scheduler.unscheduleGlobal(scene.timer)
	end
}
function gs.new()
	gs.tick = 0
	gs.timer = scheduler.scheduleGlobal(gs.update, 0.03)
end

function gs.update(dt)
	gs.tick = gs.tick + math.floor(dt * 1000)
end
