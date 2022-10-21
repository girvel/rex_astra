local module = {}


-- definitions --
module.merge = function(first, second)
	for key, value in pairs(second) do
		first[key] = first[key] or value
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


return module