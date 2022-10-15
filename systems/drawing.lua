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

			-- draw the sprite --
			if entity.is_team_colored then
				love.graphics.setColor(entity.parent.owner.color or standard.palette.white)
			end

			love.graphics.draw(
				entity.sprite.image,
				unpack(entity.position or {0, 0})
			)

			love.graphics.setColor(standard.palette.white)

			-- display province info --
			if entity.garrison and entity.anchor_position then
				love.graphics.setColor(standard.palette.black)
				kit.centered_print(entity.anchor_position, tostring(entity.garrison))
				love.graphics.setColor(standard.palette.white)
			end
		end)
	end,

	postProcess = function()
		graphics.camera:draw(function(l, t, w, h)

			-- display selection --
			love.graphics.setColor(standard.palette.selection)

			for _, entity in ipairs(ui.sources) do
				love.graphics.draw(entity.highlight.sprite.image, 0, 0)
			end

			love.graphics.setColor(standard.palette.white)

			-- print ui values --
			love.graphics.print("gold: %s" % player.gold, 0, 0)
			love.graphics.print("mode: %s" % ui.mode, 0, 15)
		end)
	end
}