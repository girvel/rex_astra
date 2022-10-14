return tiny.processingSystem {
	name = "systems.collecting",
	system_type = "mousepressed",
	filter = tiny.requireAll("coin_flag"),

	process = function(self, entity)
		if kit.is_mouse_over(entity) then
			player.gold = player.gold + 1
			entity.parent_province.coin = nil
			world:removeEntity(entity)
		end
	end,
}