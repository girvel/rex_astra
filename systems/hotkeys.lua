return tiny.system {
	name = "systems.hotkeys",
	system_type = "keypressed",

	update = function(self, event)
		local key, scancode = unpack(event)
		if not keyboard.mutex.pressed[scancode] then return end

		if self.behaviours[scancode] then
			ui.mode = self.behaviours[scancode](self) or ui.mode
		end
	end,

	behaviours = {
		escape = function()
			return standard.ui_modes.normal
		end,

		a = function()
			return fun.iter(ui.sources):length() > 0 
				and standard.ui_modes.aggression 
				or nil
		end,

		g = function()
			for entity, _ in pairs(ui.sources) do
				if entity.owner == player then
					kit.orders.invest(entity, 1)
				end
			end
		end,
	},
}