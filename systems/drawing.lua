return tiny.sortedProcessingSystem {
	name = "systems.drawing",
	system_type = "draw",
	filter = tiny.requireAll("sprite", "layer"),

	compare = function(_, e1, e2) return e1.layer < e2.layer end,

	preProcess = function()
		love.graphics.setBackgroundColor(0., 0., 0.)
	end,

	process = function(_, entity)
		if entity.visible == false then return end

		camera:draw(function(l, t, w, h)
			love.graphics.draw(
				entity.sprite.image,
				unpack(entity.position or {0, 0})
			)
		end)
	end,
}