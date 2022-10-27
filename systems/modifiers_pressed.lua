return engine.keySystem("pressed", {
	name = "systems.modifiers_pressed",

	process_key = function(self, scancode)
		if devices.keyboard.modifier_by_scancode[scancode] then
			devices.keyboard.modifiers[
				devices.keyboard.modifier_by_scancode[scancode]
			] = true

			return true
		end
	end,
})