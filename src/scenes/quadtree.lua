local quadtree = {
	rt = 1,
	lt = 2,
	lb = 3,
	rb = 4,
}

function quadtree.split(node, r, level)
	node.level = level
	node.quadnode = {}
	local t
	local rt, lt, lb, rb = quadtree.rt, quadtree.lt, quadtree.lb, quadtree.rb
	t = {left = r.left + (r.right - r.left) / 2, top = r.top}
	t.right = t.left + (r.right - r.left) / 2
	t.bottom = t.top + (r.bottom - r.top) / 2
	node.quadnode[rt] = {}
	node.quadnode[rt].rect = t

	t = {left = r.left, top = r.top}
	t.right = t.left + (r.right - r.left) / 2
	t.bottom = t.top + (r.bottom - r.top) / 2
	node.quadnode[lt] = {}
	node.quadnode[lt].rect = t

	t = {left = r.left, top = r.top + (r.bottom - r.top) / 2}
	t.right = t.left + (r.right - r.left) / 2
	t.bottom = t.top + (r.bottom - r.top) / 2
	node.quadnode[lb] = {}
	node.quadnode[lb].rect = t

	t = {left = r.left + (r.right - r.left) / 2, top = r.top + (r.bottom - r.top) / 2}
	t.right = t.left + (r.right - r.left) / 2
	t.bottom = t.top + (r.bottom - r.top) /2
	node.quadnode[rb] = {}
	node.quadnode[rb].rect = t
	if level - 1 > 0 then
		quadtree.split(node.quadnode[rt], node.quadnode[rt].rect, level - 1)
		quadtree.split(node.quadnode[lt], node.quadnode[lt].rect, level - 1)
		quadtree.split(node.quadnode[lb], node.quadnode[lb].rect, level - 1)
		quadtree.split(node.quadnode[rb], node.quadnode[rb].rect, level - 1)
	end
end

function quadtree.rectinrect(inrect, outrect)
	if (outrect.left < inrect.left) and (outrect.top > inrect.top) 
		and (outrect.right > inrect.right) and (outrect.bottom > inrect.bottom) then
		return true
	else
		return false
	end
end

function quadtree.find_node(node, rect)
	local rt, lt, lb, rb = quadtree.rt, quadtree.lt, quadtree.lb, quadtree.rb
	if (node.level > 1)  and quadtree.rectinrect(rect, node.rect) then
		if rect.left > node.rect.left + (node.rect.right - node.rect.left) / 2 then
			if rect.top > node.rect.top + (node.rect.bottom - node.rect.top) / 2 then
				find_node(node.quadnode[rt], rect)
			else
				find_node(node.quadnode[rb], rect)
			end
		else
			if rect.top > node.rect.top + (node.rect.bottom - node.rect.top) / 2 then
				find_node(node.quadnode[lt], rect)
			else
				find_node(node.quadnode[lb], rect)
			end
		end
	end
	return node
end

function quadtree.insert(node, data)
		local n = quadtree.find_node(node, data.rect)
	if not n.list then n.list = {} end
	n.list[#n.list + 1] = data
end

function quadtree.delete(node, data)
	local n = quadtree.find_node(node, data.rect)
	for i, v in ipairs(n.list) do
		if v == list then
			table.remove(n.list, i)
			return
		end
	end
end

local function wget(node, r)
	if node.list then
		for i,v in ipairs(node.list) do
			table.insert(r, v)
		end
	end
	local rt, lt, lb, rb = quadtree.rt, quadtree.lt, quadtree.lb, quadtree.rb
	if node.level > 1 then
		wget(node.quadnode[rt], r)
		wget(node.quadnode[lt], r)
		wget(node.quadnode[lb], r)
		wget(node.quadnode[rb], r)
	end
end

function quadtree.get(node, rect)
	local r = {}
	local n = quadtree.find_node(node, rect)
	if n then wget(n, r) end
	return r
end

return quadtree