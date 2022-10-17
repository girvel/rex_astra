return tiny.processingSystem {
	name = "systems.income",
	system_type = "update",
	filter = tiny.requireAll("fertility", "owner"),

	income_repeater = types.repeater(),

	process = function(self, entity, dt)
		if not entity.owner then return end

		-- TODO consider non-linear distribution
		if  kit.chance(
				dt * entity.fertility * 
				(1 - entity.garrison / entity.maximal_garrison)
			)
		then
			if entity.owner == player then
				if not entity.coin then 
					entity.coin = kit.add_coin(entity)
				end
			else
				entity.owner.gold = entity.owner.gold + 1
			end
		end
	end,
}