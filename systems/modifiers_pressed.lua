return tiny.system {
	name = "systems.modifiers_pressed",
	system_type = "keypressed",
	update = function(self, event)
		local key, scancode = unpack(event)

		if devices.keyboard.modifier_by_scancode[scancode] then
			devices.keyboard.modifiers[
				devices.keyboard.modifier_by_scancode[scancode]
			] = true
		end
	end,
}