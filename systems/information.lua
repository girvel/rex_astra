return tiny.processingSystem {
	name = "systems.information",
	system_type = "update",
	ingame = true,
	filter = tiny.requireAll("interpret"),

	process = function(self, entity, dt)
		for _, message in ipairs(information.messages) do
			if entity.interpret[message.name] then
				entity.interpret[message.name](unpack(message.args))
			end
		end
	end,

	postProcess = function(self)
		information.messages = {}
	end,
}