return tiny.system {
	name = "systems.modifiers_released",
	system_type = "keyreleased",
	update = function(self, event)
		local key, scancode = unpack(event)

		if keyboard.modifier_by_scancode[scancode] then
			keyboard.modifiers[keyboard.modifier_by_scancode[scancode]] = false
		end
	end,
}