return tiny.processingSystem {
	name = "systems.ai",
	system_type = "update",
	filter = tiny.requireAll("decide"),

	process = function(_, entity, dt)
		if entity.lost then return end

		entity:decide(dt)
	end,
}