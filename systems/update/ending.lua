return tiny.processingSystem {
	ingame = true,
	filter = tiny.requireAll("lost", "property"),

	period = types.repeater(1),
	game_ended = false,

	process = function(self, entity)
		if kit.table.size(entity.property) == 0 then
			entity.lost = true
			information.register.loss(entity)
			world:removeEntity(entity)
		end
	end,

	postProcess = function(self, dt)
		if level.ended or not self.period:move(dt):now() then return end

		if #self.entities == 1 then
			level.ended = true
			information.register.win(self.entities[1])
		end
	end
}