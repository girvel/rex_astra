local standard = require "kernel.standard"


local module = {}


-- definitions --
module.load_sprite = function(path)
	return {
		image = love.graphics.newImage(path),
		data = love.image.newImageData(path),
	}
end

module.add_island = function(planet, name, island)
	island.sprite = module.load_sprite("%s/islands/%s.png" % {planet, name})
	island.layer = standard.layers.island
	island.highlight = world:addEntity {
		name = "highlight: %s" % name,
		sprite = module.load_sprite("%s/highlights/%s.png" % {planet, name}),
		layer = standard.layers.highlight
	}

	return world:addEntity(island)
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