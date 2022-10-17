local module = {}


-- definitions --
local enumeration_member = function(n, name)
	return setmetatable({value = n, name = name}, {
		__tostring = function(self)
			return self.name
		end,
		__lt = function(self, other) return self.value < other.value end,
		__le = function(self, other) return self.value <= other.value end,
	})
end

module.enumeration = function(members)
	local result = fun.iter(members)
		:enumerate()
		:map(function(i, m) return m, i end)
		:tomap()

	result.members_ = members

	return setmetatable(result, {
		__index = function(self, index)
			error("No enumeration member %s" % index)
		end
	})
end

module.palette = function(palette_path, colors)
	local palette_data = love.image.newImageData(palette_path)

	return fun.iter(colors)
		:enumerate()
		:map(function(i, c) return c, {palette_data:getPixel(i - 1, 0)} end)
		:tomap()
end

module.repeater = function()
	return {
		value = 0,

		move = function(self, delta) 
			self.value = self.value + delta 
			return self
		end,

		each = function(self, period)
			if self.value > period then
				self.value = self.value - period
				return true
			end

			return false
		end
	}
end


return module