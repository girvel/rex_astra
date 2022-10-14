return tiny.processingSystem {
	name = "systems.income",
	system_type = "update",
	filter = tiny.requireAll("fertility"),

	income_repeater = types.repeater(),

	process = function(self, entity, dt)
		if not entity.coin and kit.chance(dt / 60 * entity.fertility) then
			entity.coin = kit.add_coin(entity)
		end
	end,
}