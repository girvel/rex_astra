local standard = require "kernel.standard"


local module = {}


-- submodules --
module.random = require "kernel.kit.random"
module.orders = require "kernel.kit.orders"
module.table = require "kernel.kit.table"


-- definitions --
local query_system = require "systems.query"
module.query = function(request_source)
	local _, predicate = load("return function(e) return %s end" % request_source)
	local result = fun.iter(query_system.entities):filter(predicate):totable()
	
	if #result > 1 then
		log.warn(
			"Query `%s` returned more %s values; \n\n%s" % 
			{request_source, #result, inspect(result)}
		)
	end

	return result[1]
end

return module