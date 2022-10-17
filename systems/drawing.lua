return tiny.sortedProcessingSystem {
	name = "systems.drawing",
	system_type = "draw",
	-- filter = tiny.requireAll("sprite", "layer"),
	filter = tiny.requireAll("layer"),
	-- TODO remove; this is for garrison displaying

	compare = function(_, e1, e2) return e1.layer < e2.layer end,

	preProcess = function()
		love.graphics.setBackgroundColor(0., 0., 0.)
	end,

	process = function(_, entity)
		if entity.visible == false then return end

		graphics.camera:draw(function(l, t, w, h)

			-- draw the sprite --
			-- TODO remove if
			if entity.sprite then
				if entity.is_team_colored and entity.parent.owner then
					love.graphics.setColor(entity.parent.owner.color or standard.palette.white)
				end

				love.graphics.draw(
					entity.sprite,
					unpack(entity.position or {0, 0})
				)

				love.graphics.setColor(standard.palette.white)
			end

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

			for entity, _ in pairs(ui.sources) do
				love.graphics.draw(entity.highlight.sprite, 0, 0)
			end

			love.graphics.setColor(standard.palette.white)

			-- print ui values --
			local lines = {
				{standard.ui_modes.investing, "[G]old: %s" % player.gold},
				{standard.ui_modes.aggression, "[A]rmy"},
				{standard.ui_modes.normal, "[Ecs] selection"},
			}

			for i, line_pair in ipairs(lines) do
				local mode, line = unpack(line_pair)

				if mode == ui.mode then
					love.graphics.setColor(standard.palette.selection)
				end

				love.graphics.print(line, 0, 15 * (i - 1))
				
				love.graphics.setColor(standard.palette.white)
			end

			if ui.console.active then
				love.graphics.print("> %s" % ui.console.command, 0, 60)
			end
		end)
	end
}