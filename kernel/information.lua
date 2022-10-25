local module = {
	messages = {},
}

module.register = setmetatable({}, {
	__index = function(self, index)
		return function(...)
			table.insert(module.messages, {
				name = index,
				args = {...},
			})
		end
	end
})


return module