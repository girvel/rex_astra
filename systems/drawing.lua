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

				if entity.opacity then
					local r, g, b = love.graphics.getColor()
					love.graphics.setColor(r, g, b, entity.opacity)
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

			-- print ui values --
			local lines = {
				{standard.ui_modes.investing, "[G]old: %s" % player.gold},
				{standard.ui_modes.aggression, "[A]rmy"},
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
				love.graphics.print("> %s" % ui.console.command, 0, 45)
			end

			love.graphics.setFont(ui.chat.font)

			local line_h = ui.chat.font:getHeight()
			local lines_n = math.min(#ui.chat, graphics.world_size[2] / line_h)

			for y in fun.range(0, lines_n - 1) do
				love.graphics.print(
					ui.chat[#ui.chat - lines_n + y + 1],
					graphics.world_size[1] - ui.chat.w, y * line_h
				)
			end

			love.graphics.setFont(standard.fonts.normal)
		end)
	end
}