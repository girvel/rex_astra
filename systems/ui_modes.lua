return tiny.system {
	name = "systems.ui_modes",
	system_type = "keypressed",

	update = function(self, event)
		local key, scancode = unpack(event)
		if devices.keyboard.mutex.pressed[scancode] then return end

		if self.behaviours[scancode] then
			ui.mode = self.behaviours[scancode](self) or ui.mode
			devices.keyboard.mutex.pressed[scancode] = true
		end
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
		end,

		p = function()
			return ui.modes.pause
		end,
	},
}