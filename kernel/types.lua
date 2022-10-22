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

module.time = function(t)
	kit.table.merge(t, {
		second = 0,
		minute = 0,
		hour = 0,
	})

	local r = {}

	r.constants = t.constants
	r.value = ((((t.year
		* t.constants.months_in_year + t.month) 
		* t.constants.days_in_month + t.day) 
		* t.constants.hours_in_day + t.hour)
		* t.constants.minutes_in_hour + t.minute)
		* t.constants.seconds_in_minute + t.second

	r.get_second = function(self)
		return self.value % self.constants.seconds_in_minute
	end

	r.get_minute = function(self)
		return math.floor(self.value 
			/ self.constants.seconds_in_minute)
			% self.constants.minutes_in_hour
	end

	r.get_hour = function(self)
		return math.floor(self.value 
			/ self.constants.seconds_in_minute 
			/ self.constants.minutes_in_hour)
			% self.constants.hours_in_day
	end

	r.get_day = function(self)
		return math.floor(self.value 
			/ self.constants.seconds_in_minute 
			/ self.constants.minutes_in_hour
			/ self.constants.hours_in_day)
			% self.constants.days_in_month
	end

	r.get_month = function(self)
		return math.floor(self.value 
			/ self.constants.seconds_in_minute 
			/ self.constants.minutes_in_hour
			/ self.constants.hours_in_day
			/ self.constants.days_in_month)
			% self.constants.months_in_year
	end

	r.get_year = function(self)
		return math.floor(self.value 
			/ self.constants.seconds_in_minute 
			/ self.constants.minutes_in_hour
			/ self.constants.hours_in_day
			/ self.constants.days_in_month
			/ self.constants.months_in_year)
	end

	local to_string = function(n, length)
		local result = tostring(n)
		if #result < length then
			return ("0"):rep(length - #result) .. result
		end
		return result
	end

	r.format = function(self, format)
		return format
			:gsub("%%Y", to_string(self:get_year(), 4))
			:gsub("%%m", to_string(self:get_month(), 2))
			:gsub("%%d", to_string(self:get_day(), 2))
			:gsub("%%H", to_string(self:get_hour(), 2))
			:gsub("%%M", to_string(self:get_minute(), 2))
			:gsub("%%S", to_string(self:get_second(), 2))
	end

	return r
end

module.repeater = function(period)
	return {
		value = 0,
		period = period,

		move = function(self, delta) 
			self.value = self.value + delta 
			
			if self.value > self.period then
				self.value = self.value - self.period
				return true
			end

			return false
		end,
	}
end


return module