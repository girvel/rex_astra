return tiny.system {
	name = "systems.modifiers_released",
	system_type = "keyreleased",
	update = function(self, event)
		local key, scancode = unpack(event)

		if devices.keyboard.modifier_by_scancode[scancode] then
			devices.keyboard.modifiers[
				devices.keyboard.modifier_by_scancode[scancode]
			] = false
		end
	end,
}