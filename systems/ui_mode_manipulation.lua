return tiny.system {
	name = "systems.ui_mode_manipulation",
	system_type = "keypressed",

	update = function(_, event)
		local key, _, _ = unpack(event)

		ui.mode = ({
			escape = standard.ui_modes.normal,
			g = standard.ui_modes.investing,
			a = standard.ui_modes.aggression,
		})[key]
	end,
}