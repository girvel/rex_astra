local module_metatable = {}
local module = setmetatable({}, module_metatable)
local vector_metatable = {}


-- constructor --
module_metatable.__call = function(_, array)
	return setmetatable({unpack(array)}, vector_metatable)
end


-- operators --
vector_metatable.__sub = function(a, b)
	return fun.zip(a, b):map(function(u, v) return u - v end):totable()
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


return module
