return tiny.processingSystem {
	ingame = true,
	filter = tiny.requireAll("decide"),

	process = function(_, entity, dt)
		if entity.lost then return end

		entity:decide(dt)
	end,
}