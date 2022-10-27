return tiny.system {
	name = "systems.mutex",
	system_type = "update",

	update = function()
		devices.keyboard.mutex.pressed = {}
		devices.keyboard.mutex.released = {}
		devices.mouse.mutex.pressed = {}
		devices.mouse.mutex.over = false
	end,
}