return engine.keySystem("pressed", {
	process_key = function(self, scancode)
		if scancode == "h" and devices.keyboard.modifiers.shift then
			information.register.ui_help()
		end
	end
})