return tiny.sortedProcessingSystem {
	filter = tiny.requireAll("layer"),

	compare = function(_, e1, e2) return e1.layer < e2.layer end,

	preProcess = function()
		love.graphics.setBackgroundColor(0., 0., 0.)
	end,

	process = function(_, entity)
		if entity.visible == false then return end

		graphics.camera:draw(function(l, t, w, h)

			-- draw the sprite --
			if entity.sprite then
				if entity.is_team_colored  
					and entity.parent.owner 
					and entity.parent.garrison 
				then
					love.graphics.setColor(
						entity.parent.owner.color 
						or graphics.palette.white
					)
				end

				if entity.opacity then
					local r, g, b = love.graphics.getColor()
					love.graphics.setColor(r, g, b, entity.opacity)
				end

				love.graphics.draw(
					entity.sprite,
					unpack(entity.position or {0, 0})
				)

				love.graphics.setColor(graphics.palette.white)
			end

			-- province info --
			if entity.owner then
				love.graphics.setFont(graphics.fonts.small)
				love.graphics.setColor(entity.owner.color)

				if entity.garrison then
					graphics.centered_print(entity.anchor_position, tostring(entity.garrison))
				end

				if entity.fleet and (entity.fleet > 0 or entity.garrison) then
					graphics.centered_print(entity.fleet_p, tostring(entity.fleet))
				end
			end

			if launch.trace_names and entity.name and entity.anchor_position then
				love.graphics.setColor(graphics.palette.white)
				love.graphics.setFont(graphics.fonts.small)
				graphics.centered_print(entity.anchor_position, entity.name)
			end

			love.graphics.setColor(graphics.palette.white)
		end)
	end,

	postProcess = function()
		graphics.ui_camera:draw(function(l, t, w, h)

			-- ui modes --
			local font = graphics.fonts.ui_normal
			love.graphics.setFont(font)

			local lines = {
				{ui.modes.investing, "[G]old: %s" % player.gold},
				{ui.modes.aggression, "[A]rmy"},
				{ui.modes.pause, "[P]ause"},
			}

			for i, line_pair in ipairs(lines) do
				local mode, line = unpack(line_pair)

				if mode == ui.mode then
					love.graphics.setColor(graphics.palette.selection)
				end

				love.graphics.print(line, 0, (font:getHeight() + 4) * (i - 1))
				
				love.graphics.setColor(graphics.palette.white)
			end

			-- console --
			if ui.console.active then
				love.graphics.setFont(graphics.fonts.ui_small)
				love.graphics.print("> %s" % ui.console.command, 0, (font:getHeight() + 4) * 3)
			end

			-- chat --
			love.graphics.setFont(ui.chat.font)

			local line_h = ui.chat.font:getHeight() + ui.chat.line_spacing
			local lines_n = math.min(
				#ui.chat, 
				math.floor(graphics.window_size[2] / line_h)
			)

			if lines_n > 0 then
				for y in fun.range(0, lines_n - 1) do
					love.graphics.print(
						ui.chat[#ui.chat - lines_n + y + 1],
						graphics.window_size[1] - ui.chat.w - 5, 
						y * line_h
					)
				end
			end

		end)

		-- mouse --
		if love.mouse.getX() > 0 and love.mouse.getY() > 0 then
			love.graphics.draw(ui.cursor, love.mouse.getPosition())
		end
	end
}