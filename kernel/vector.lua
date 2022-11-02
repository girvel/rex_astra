local module_metatable = {}
local module = setmetatable({}, module_metatable)
local vector_metatable = {}
local vector_methods = {}

module[2] = {}


-- constructors --
module_metatable.__call = function(_, array)
	return setmetatable({unpack(array)}, vector_metatable)
end

module[2].parse = function(source, format)
	format = format or "{%x, %y}"

	local number_capture = "([%%-%%+]?%%d+%%.?%%d*)"
	format = format
		:gsub("%%x", number_capture)
		:gsub("%%y", number_capture)

	local _, _, x, y = source:find(format)

	if not x or not y then
		return nil
	end

	return module {tonumber(x), tonumber(y)}
end


-- constants --
module[2].up = function()
	return module {0, -1}
end


-- operators --
vector_metatable.__add = function(self, other)
	return module(
		fun.zip(self, other):map(function(u, v) return u + v end):totable()
	)
end

vector_metatable.__sub = function(a, b)
	return module(
		fun.zip(a, b):map(function(u, v) return u - v end):totable()
	)
end

vector_metatable.__mul = function(vector, coefficient)
	return module(
		fun.iter(vector):map(function(v) return v * coefficient end):totable()
	)
end

vector_metatable.__div = function(vector, coefficient)
	return module(
		fun.iter(vector):map(function(v) return v / coefficient end):totable()
	)
end

vector_metatable.__le = function(a, b)
	return fun.zip(a, b)
		:map(fun.operator.le)
		:reduce(fun.operator.land, true)
end

vector_metatable.__lt = function(a, b)
	return fun.zip(a, b)
		:map(fun.operator.lt)
		:reduce(fun.operator.land, true)
end

vector_metatable.__tostring = function(self)
	return "{%s}" % table.concat(fun.iter(self):map(tostring):totable(), ", ")
end

vector_metatable.__index = vector_methods


-- methods --
vector_methods.proportion_to = function(self, other)
	local ks = fun.zip(self, other)
		:map(function(a, b) return a / b end)

	return ks
		:map(function(k) return k == ks:head() end)
		:reduce(fun.operator.land, true) 
		and ks:head()
		or nil
end

vector_methods.soft_proportion_to = function(self, other)
	local ks = fun.zip(self, other)
		:map(function(a, b) return a / b end)

	return ks:reduce(math.min, ks:head())
end


return module
