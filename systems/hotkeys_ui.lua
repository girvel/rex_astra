return engine.keySystem("pressed", {
	name = "systems.hotkeys_ui",

	process_key = function(self, scancode)
		if scancode == "h" and devices.keyboard.modifiers.shift then
			information.register.ui_help()
		end
	end
})