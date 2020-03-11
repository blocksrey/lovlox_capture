--[[
local axisangle = _G.require("axisangle")
local cframe    = _G.require("cframe")

local v3         = Vector3.new
local nv3        = v3()
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
	return dir*vec
end

local function cfref(o, m)
	local p0, x0, y0, z0 = cfparts(o)
	local mx, my, mz = v3unp(m)
	local p1 = m*p0
	local x1 = m*x0*mx
	local y1 = m*y0*my
	local z1 = m*z0*mz
	return CFrame.fromMatrix(p1, x1, y1, z1)
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

structure.light = function(o, m)
	if o:IsA("BasePart") then
		local pos = argstr("vec3.new(", ", ", ")", v3unp(v3ref(o.CFrame.Position, m)))
		local siz = argstr("vec3.new(", ", ", ")", v3unp(o.Size))
		local col = argstr("vec3.new(", ", ", ")", c3unp(o.Color))
		local opa = 1 - o.Transparency
		return argstr("{", ", ", "};", pos, siz, col, opa)
	end
end

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
			if v1.ClassName == i0 or v1.Name == i0 then
				local r = v0(v1, a)
				if r then
					print(r)
				end
			end
		end
		print("};")
	end
	print("}")
end

return captureworld
--]]

local axisangle = _G.require("axisangle")
local cframe    = _G.require("cframe")

local v3         = Vector3.new
local nv3        = v3()
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
	return dir*vec
end

local function cfref(o, m)
	local p0, x0, y0, z0 = cfparts(o)
	local mx, my, mz = v3unp(m)
	local p1 = m*p0
	local x1 = m*x0*mx
	local y1 = m*y0*my
	local z1 = m*z0*mz
	return CFrame.fromMatrix(p1, x1, y1, z1)
end

local function argstr(str, div, fin, ...)
	local tab = {...}
	local len = #tab
	for ind = 1, len - 1 do
		str = str..tab[ind]..div
	end
	return str..tab[len]..fin
end



--[[
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

structure.light = function(o, m)
	if o:IsA("BasePart") then
		local pos = argstr("vec3.new(", ", ", ")", v3unp(v3ref(o.CFrame.Position, m)))
		local siz = argstr("vec3.new(", ", ", ")", v3unp(o.Size))
		local col = argstr("vec3.new(", ", ", ")", c3unp(o.Color))
		local opa = 1 - o.Transparency
		return argstr("{", ", ", "};", pos, siz, col, opa)
	end
end
--]]

local ignorelist = {
	Terrain     = true;
	Camera      = true;
	Decal       = true;
	Folder      = true;
	Texture     = true;
	Model       = true;
	SpecialMesh = true;
	Sound       = true;
	PointLight  = true;
}

local properties = {}

properties.default = {}
properties.default.CFrame = function(obj)
	return cfref(obj.CFrame)
end
properties.default.Size = function(obj)
	return obj.Size
end

properties.Part = {}
properties.Part.CFrame = properties.default.CFrame
properties.default.Size = properties.default.Size
properties.default.Shape = shunp


local typeofexclusives = {}

typeofexclusives.Vector3 = function(v3)
	return argstr("Vector3.new(", ", ", ")", v3unp(v3))
end

typeofexclusives.CFrame = function(cf)
	return argstr("CFrame.new(", ", ", ")", cfunp(cf))
end

typeofexclusives.Color3 = function(c3)
	return argstr("Color3.new(", ", ", ")", c3unp(c3))
end

local function parsethething(val)
	local to = typeof(val)
	local func = typeofexclusives[to]
	if func then
		return func(val)
	else
		return val
	end
end

local function printinstanceinstruction(object)
	print('p = Instance.new("'..object.ClassName..'")')
	local props = properties[object.ClassName] or properties.default
	for ind, val in next, props do
		print(ind, val)
		print("p."..ind.." = "..parsethething(val(object[ind])))
	end
end

local function captureworld()
	print("return function()")
	local tab = workspace:GetDescendants()
	for ind = 1, #tab do
		local obj = tab[ind]
		if not ignorelist[obj.ClassName] then
			printinstanceinstruction(obj)
		end
	end
	print("end")
end

return captureworld
