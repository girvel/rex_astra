return tiny.system {
	name = "systems.ui_mode_manipulation",
	system_type = "keypressed",

	update = function(_, event)
		local key, _, _ = unpack(event)

		ui.mode = ({
			g = standard.ui_modes.investing,
			escape = standard.ui_modes.normal,
		})[key]
	end,
}