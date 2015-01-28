local quadtree = { }
local rt, lt, lb, rb = 1, 2, 3, 4

function quadtree.split(node, r, level)
	node.level = level 
	if  level - 1 > 0 then
		node.quadnode = {}
		local t
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
		t.bottom = t.top + (r.bottom - r.top) / 2
		node.quadnode[rb] = {}
		node.quadnode[rb].rect = t
	
		quadtree.split(node.quadnode[rt], node.quadnode[rt].rect, level - 1)
		quadtree.split(node.quadnode[lt], node.quadnode[lt].rect, level - 1)
		quadtree.split(node.quadnode[lb], node.quadnode[lb].rect, level - 1)
		quadtree.split(node.quadnode[rb], node.quadnode[rb].rect, level - 1)
	else
		node.rect = r
	end
end

function quadtree.rectinrect(inrect, outrect)
	if (outrect.left <= inrect.left) and (outrect.top <= inrect.top) 
		and (outrect.right >= inrect.right) and (outrect.bottom >= inrect.bottom) then
		return true
	else
		return false
	end
end

function quadtree.find_node(node, rect, parent)
	--printrect(node.rect)
	if (node.level > 1) and quadtree.rectinrect(rect, node.rect) then
		if rect.left >= node.rect.left + (node.rect.right - node.rect.left) / 2 then
			if rect.top >= node.rect.top + (node.rect.bottom - node.rect.top) / 2 then
				return quadtree.find_node(node.quadnode[rb], rect, node)
			else
				return quadtree.find_node(node.quadnode[rt], rect, node)
			end
		else
			if rect.top >= node.rect.top + (node.rect.bottom - node.rect.top) / 2 then
				return quadtree.find_node(node.quadnode[lb], rect, node)
			else
				return quadtree.find_node(node.quadnode[lt], rect, node)
			end
		end
	end
	-- 
	if quadtree.rectinrect(rect, node.rect) then
		return node
	else
		return parent
	end
end

function printrect(rect, s)
	if s then
		print(s, rect.left, rect.top, rect.right, rect.bottom)
	else
		print(rect.left, rect.top, rect.right, rect.bottom)
	end
end

function quadtree.insert(node, data)
	local n = quadtree.find_node(node, data.rect, node)
	if not n.list then n.list = {} end
	n.list[#n.list + 1] = data
end

function quadtree.delete(node, data)
	local n = quadtree.find_node(node, data.rect, node)
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
	if node.level > 1 then
		wget(node.quadnode[rt], r)
		wget(node.quadnode[lt], r)
		wget(node.quadnode[lb], r)
		wget(node.quadnode[rb], r)
	end
end

function quadtree.get(node, rect)
	local r = {}
	local n = quadtree.find_node(node, rect, node)
	--printrect(rect)
	--printrect(n.rect)
	if n then wget(n, r) end
	return r
end

function quadtree.print_tree(node)
	if node.rect then 
		print(node.rect.left, node.rect.top, node.rect.right, node.rect.bottom)
	else
		return
	end
	if not node.quadnode then return end
	quadtree.print_tree(node.quadnode[lt])
	quadtree.print_tree(node.quadnode[lb])
	quadtree.print_tree(node.quadnode[rt])
	quadtree.print_tree(node.quadnode[rb])
end
--[[
-- test
local rect = {left = 0, top = 0, right = 4096 * 4 , bottom = 4096 * 4}
local root, cell = {}, {}
root.rect = rect
quadtree.split(root, rect, 5)
--quadtree.insert(root, cell)
--local r = {left = 0, top = 0, right = 1024, bottom = 1024}
local r = {left = 1024, top = 0, right = 1025, bottom = 1}
local n = quadtree.find_node(root, r, root)
printrect(n.rect)
]]
return quadtree