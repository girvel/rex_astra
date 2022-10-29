local module_metatable = {}
local module = setmetatable({}, module_metatable)
local vector_metatable = {}
local vector_methods = {}


-- constructors --
module_metatable.__call = function(_, array)
	return setmetatable({unpack(array)}, vector_metatable)
end

module.parse = function(source, format)
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


-- operators --
vector_metatable.__sub = function(a, b)
	return fun.zip(a, b):map(function(u, v) return u - v end):totable()
end

vector_metatable.__mul = function(vector, coefficient)
	return fun.iter(vector):map(function(v) return v * coefficient end):totable()
end

vector_metatable.__div = function(vector, coefficient)
	return fun.iter(vector):map(function(v) return v / coefficient end):totable()
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

vector_metatable.__index = vector_methods


-- methods
vector_methods.proportion_to = function(self, other)
	local ks = fun.zip(self, other)
		:map(function(a, b) return a / b end)

	return ks
		:map(function(k) return k == ks:head() end)
		:reduce(fun.operator.land, true) 
		and ks:head()
		or nil
end


return module
