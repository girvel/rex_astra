local module = {}


-- definitions --
module.load_sprite = function(path)
	return {
		image = love.graphics.newImage(path),
		data = love.image.newImageData(path),
	}
end

module.enumeration = function(members)
	return fun.iter(members)
		:enumerate()
		:map(function(i, m) return m, i end)
		:tomap()
end

module.get_palette = function(palette_path, colors)
	local palette_data = love.image.newImageData(palette_path)

	return fun.iter(colors)
		:enumerate()
		:map(function(i, c) return c, {palette_data:getPixel(i - 1, 0)} end)
		:tomap()
end

module.is_mouse_over = function(entity)
	local mouse_position = vector {graphics.camera:toWorld(love.mouse.getPosition())}
	mouse_position = mouse_position - (entity.position or {0, 0})

	if (mouse_position[1] <= 0 or 
		mouse_position[2] <= 0 or 
		mouse_position[1] > entity.sprite.data:getWidth() or
		mouse_position[2] > entity.sprite.data:getHeight()
	) then
		return false
	end

	local r, g, b, a = entity.sprite.data:getPixel(unpack(mouse_position))
	return a > 0
end

module.centered_print = function(position, text)
	local font = love.graphics.getFont()
	local w = font:getWidth(text)
	local h = font:getHeight()

	love.graphics.print(text, position[1], position[2], 0, 1, 1, w / 2, h / 2)
end


return module