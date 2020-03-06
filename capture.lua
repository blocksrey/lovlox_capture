local axisangle = _G.require("axisangle")
local cframe    = _G.require("cframe")

local v3         = Vector3.new
local nv3        = v3()
local dot        = nv3.Dot
local cf         = CFrame.new
local ncf        = cf()
local cfunp      = ncf.components

local function v3unp(v3)
	return v3.x, v3.y, v3.z
end

local function c3unp(c3)
	return c3.r, c3.g, c3.b
end

local function shunp(sh)
	return
		sh == Enum.PartType.Ball     and "Ball"     or
		sh == Enum.PartType.Block    and "Block"    or
		sh == Enum.PartType.Cylinder and "Cylinder"
end

local function cfparts(cf)
	local
		px, py, pz,
		xx, yx, zx,
		xy, yy, zy,
		xz, yz, zz = cfunp(cf)
	
	local p = v3(px, py, pz)
	local x = v3(xx, xy, xz)
	local y = v3(yx, yy, yz)
	local z = v3(zx, zy, zz)
	
	return p, x, y, z
end

local function v3ref(vec, dir)
	return vec - 2*dot(vec, dir)*dir
end

local function cfref(ori, dir)
	local p, x, y, z = cfparts(ori)
	
	local v = v3ref(p, dir)
	local a = axisangle.matrix(ori)
	local r = v3ref(a, dir)
	
	return cframe.axisangle(r) + v
end

local function argstr(str, div, fin, ...)
	local tab = {...}
	local len = #tab
	for ind = 1, len - 1 do
		str = str..tab[ind]..div
	end
	return str..tab[len]..fin
end

local ignorelist = {
	Terrain = true;
	Camera = true;
	Decal = true;
	Folder = true;
}

local structure = {}

structure.Part = function(o, a)
	local cf  = cfref(o.CFrame, a)
	local pos = argstr("vec3.new(", ", ", ")", v3unp(cf.Position))
	local ori = argstr("mat3.new(", ", ", ")", select(4, cfunp(cf)))
	local siz = argstr("vec3.new(", ", ", ")", v3unp(o.Size))
	local col = argstr("vec3.new(", ", ", ")", c3unp(o.Color))
	local sha = argstr('"', "", '"', shunp(o.Shape))
	return argstr("{", ", ", "};", pos, ori, siz, col, sha)
end

structure.WedgePart = function(o, a)
	local cf  = cfref(o.CFrame, a)
	local pos = argstr("vec3.new(", ", ", ")", v3unp(cf.Position))
	local ori = argstr("mat3.new(", ", ", ")", select(4, cfunp(cf)))
	local siz = argstr("vec3.new(", ", ", ")", v3unp(o.Size))
	local col = argstr("vec3.new(", ", ", ")", c3unp(o.Color))
	return argstr("{", ", ", "};", pos, ori, siz, col)
end

structure.MeshPart = structure.WedgePart

local function captureworld(a)
	local t = workspace:GetDescendants()
	for i = 1, #t do
		local obj = t[i]
		if ignorelist[obj.ClassName] then
			t[i] = nil
		end
	end
	print("return {")
	for i0, v0 in next, structure do
		print(i0.." = {")
		for i1, v1 in next, t do
			if v1.ClassName == i0 then
				print(v0(v1, a))
			end
		end
		print("};")
	end
	print("}")
end

return captureworld