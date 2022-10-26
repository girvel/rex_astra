local module = {
	messages = {},
}

module.register = setmetatable({}, {
	__index = function(self, index)
		return function(...)
			log.stack_delta = 1

			log.trace("Game information:", index, 
				unpack(fun.iter {...}
					:map(kit.short_string)
					:totable()
				)
			)

			log.stack_delta = nil

			table.insert(module.messages, {
				name = index,
				args = {...},
			})
		end
	end
})


return module