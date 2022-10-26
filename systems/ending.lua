return tiny.processingSystem {
	name = "systems.ending",
	system_type = "update",
	filter = tiny.requireAll("lost", "property"),

	period = types.repeater(1),
	game_ended = false,

	process = function(self, entity)
		if kit.table.size(entity.property) == 0 then
			entity.lost = true
			information.register.loses(entity)
			world:removeEntity(entity)
		end
	end,

	postProcess = function(self, dt)
		if level.ended or not self.period:move(dt):now() then return end

		if #self.entities == 1 then
			level.ended = true
			information.register.wins(self.entities[1])
		end
	end
}