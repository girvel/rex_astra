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

		graphics.camera:draw(function(l, t, w, h)
			love.graphics.draw(
				entity.sprite.image,
				unpack(entity.position or {0, 0})
			)

			-- TODO a separate system maybe???
			if entity.garrison and entity.anchor_position then
				love.graphics.setColor(standard.palette.black)
				kit.centered_print(entity.anchor_position, tostring(entity.garrison))
				love.graphics.setColor(standard.palette.white)
			end
		end)
	end,

	postProcess = function()
		-- TODO definetely a separate system
		graphics.camera:draw(function(l, t, w, h)
			love.graphics.print("gold: %s" % player.gold, 0, 0)
		end)
	end
}