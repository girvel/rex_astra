return tiny.system {
	name = "systems.ui_mode_manipulation",
	system_type = "keypressed",

	modes_by_keys = {
		escape = standard.ui_modes.normal,
		g = standard.ui_modes.investing,
		a = standard.ui_modes.aggression,
	},

	update = function(self, event)
		local key, scancode, _ = unpack(event)
		ui.mode = self.modes_by_keys[scancode] or ui.mode
	end,
}