local module = {}


-- definitions --
module.merge = function(first, second)
	for key, value in pairs(second) do
		first[key] = first[key] ~= nil and first[key] or value
	end

	return first
end

module.delete = function(t, item)
	local index = fun.iter(t):index(item)
	return index and table.remove(t, index)
end

module.concat = function(self, ...)
	for _, other in ipairs {...} do
		for _, e in ipairs(other) do
			table.insert(self, e)
		end
	end

	return self
end

module.reverse_index = function(self, index)
	for key, value in pairs(self) do
		if value == index then return key end
	end
end

module.size = function(self)
	local result = 0
	for _, _ in pairs(self) do
		result = result + 1
	end
	return result
end

module.empty = function(self)
	for _, _ in pairs(self) do
		return false
	end
	return true
end

module.pop = function(self)
	for k, v in pairs(self) do
		self[k] = nil
		return k, v
	end
end

module.contains = function(self, e)
	for k, v in pairs(self) do
		if v == e then
			return true
		end
	end
end

module.shallow_copy = function(self)
	local result = {}
	for k, v in pairs(self) do
		result[k] = v
	end
	return result
end


return module