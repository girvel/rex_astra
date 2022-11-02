return engine.keySystem("pressed", {
	process_key = function(self, scancode)
		if not self.behaviours[scancode] then return end

		ui.mode = self.behaviours[scancode](self) or ui.mode
		return true
	end,

	behaviours = {
		escape = function()
			return ui.modes.normal
		end,

		a = function()
			return fun.iter(ui.sources):length() > 0 
				and ui.modes.aggression 
				or nil
		end,

		g = function()
			for entity, _ in pairs(ui.sources) do
				if entity.owner == player then
					kit.orders.invest(entity, 1)
				end
			end
			return ui.modes.normal
		end,

		p = function()
			return ui.modes.pause
		end,
	},
})