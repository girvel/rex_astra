return tiny.processingSystem {
	name = "systems.collecting",
	system_type = "mousepressed",
	filter = tiny.requireAll("coin_flag"),

	process = function(self, entity, event)
		local x, y, button = unpack(event)

		if mouse.mutex.pressed[button] or not kit.is_mouse_over(entity) then return end
		mouse.mutex.pressed[button] = true

		player.gold = player.gold + 1
		entity.parent_province.coin = nil
		world:removeEntity(entity)
	end,
}