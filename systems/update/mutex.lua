return tiny.system {
	update = function(self)
		devices.keyboard.mutex.pressed = {}
		devices.keyboard.mutex.released = {}
		devices.mouse.mutex.pressed = {}
		devices.mouse.mutex.over = false
	end,
}