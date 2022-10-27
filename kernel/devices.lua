local module = {}


-- definitions --
module.keyboard = {
	modifiers = {
		shift = false,
	},
	mutex = {
		pressed = {},
		released = {},
	},
	modifier_by_scancode = {
		rshift = "shift",
		lshift = "shift",
	},
}

module.mouse = {
	mutex = {
		pressed = {},
		over = false,
	},

	is_over = function(entity)
		local mouse_position = vector {graphics.camera:toWorld(love.mouse.getPosition())}
		mouse_position = mouse_position - (entity.position or {0, 0})

		if (mouse_position[1] < 0 or 
			mouse_position[2] < 0 or 
			mouse_position[1] >= entity.hitbox:getWidth() or
			mouse_position[2] >= entity.hitbox:getHeight()
		) then
			return false
		end

		local r, g, b, a = entity.hitbox:getPixel(unpack(mouse_position))
		return a > 0
	end
}


return module