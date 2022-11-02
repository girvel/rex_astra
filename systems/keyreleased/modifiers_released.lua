return engine.keySystem("released", {
	process_key = function(self, scancode)
		if devices.keyboard.modifier_by_scancode[scancode] then
			devices.keyboard.modifiers[
				devices.keyboard.modifier_by_scancode[scancode]
			] = false

			return true
		end
	end,
})