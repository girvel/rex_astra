return tiny.system {
	name = "systems.modifiers_pressed",
	system_type = "keypressed",
	update = function(self, event)
		local key, scancode = unpack(event)

		if keyboard.modifier_by_scancode[scancode] then
			keyboard.modifiers[keyboard.modifier_by_scancode[scancode]] = true
		end

		log.trace(keyboard.modifier_by_scancode[scancode], "pressed")
	end,
}