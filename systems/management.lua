return tiny.processingSystem {
	name = "systems.management",
	system_type = "mousepressed",
	filter = tiny.requireAll("garrison"),

	process = function(self, entity)
		if (kit.is_mouse_over(entity) and
			entity.owner == player and 
			entity.garrison < (entity.maximal_garrison or standard.maximal_garrison) and
			entity.garrison <= player.gold
		) then
			player.gold = player.gold - entity.garrison
			entity.garrison = entity.garrison + 1
		end
	end,
}