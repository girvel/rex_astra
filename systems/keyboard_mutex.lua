return tiny.system {
	name = "systems.keyboard_mutex",
	system_type = "update",
	update = function()
		keyboard.mutex_lock = {}
	end,
}