return tiny.system {
	name = "systems.mutex",
	system_type = "update",

	update = function()
		keyboard.mutex.pressed = {}
		mouse.mutex.pressed = {}
		mouse.mutex.over = false
	end,
}