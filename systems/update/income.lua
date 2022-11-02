return tiny.processingSystem {
	ingame = true,
	filter = tiny.requireAll("fertility", "owner"),

	global_fertility_rate = .35,

	process = function(self, entity, dt)
		if not entity.owner then return end

		-- TODO consider non-linear distribution
		if  entity.income_repeater:move(dt):now() and
			kit.random.chance(
				self.global_fertility_rate * entity.fertility * 
				(1 - entity.garrison / (entity.maximal_garrison + 1))
			)
		then
			if entity.owner == player then
				if not entity.coin then 
					entity.coin = world:addEntity(prototypes.coin(entity))
				end
			else
				entity.owner.gold = entity.owner.gold + 1
			end
		end
	end,
}