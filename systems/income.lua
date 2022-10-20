return tiny.processingSystem {
	name = "systems.income",
	system_type = "update",
	filter = tiny.requireAll("fertility", "owner"),

	income_repeater = types.repeater(1),
	global_fertility_rate = .2,

	process = function(self, entity, dt)
		if not entity.owner then return end

		-- TODO consider non-linear distribution
		if  self.income_repeater:move(dt) and
			kit.random.chance(
				self.global_fertility_rate * entity.fertility * 
				(1 - entity.garrison / entity.maximal_garrison)
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