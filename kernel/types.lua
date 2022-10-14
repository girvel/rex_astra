local module = {}


-- definitions --
module.enumeration = function(members)
	return fun.iter(members)
		:enumerate()
		:map(function(i, m) return m, i end)
		:tomap()
end

module.palette = function(palette_path, colors)
	local palette_data = love.image.newImageData(palette_path)

	return fun.iter(colors)
		:enumerate()
		:map(function(i, c) return c, {palette_data:getPixel(i - 1, 0)} end)
		:tomap()
end


return module