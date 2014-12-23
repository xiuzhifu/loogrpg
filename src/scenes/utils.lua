local utils = {}
function utils.righty(y)
	return display.height - y
end

function utils.getxydirectionbydir(dir)
	local actordir = {
		{0, -1},--0
		{1, -1},--1
		{1, 0},--2
		{1, 1},--3
		{0, 1},--4
		{-1, 1},--5
		{-1, 0},--6
		{-1, -1}--7
	}
	if dir >= 0 and dir <=6 then
		return actordir[dir + 1][1], actordir[dir + 1][2]
	end
end
function utils.getdir(x, y, targetx, targety)
	if (x == targetx) and (y == targety) then return -1 end
	if targetx == x then
		if targety > y then 
			return 0
		else
			return 4
		end
	end

	if targety == y then
		if targetx > x then 
			return 2
		else
			return 6
		end	
	end

	if targetx > x then
		if targety > y then
			return 1
		else
			return 3
		end
	else
		if targety < y then
			return 5
		else
			return 7
		end		
	end
end

return utils