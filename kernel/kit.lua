local module = {}


-- submodules --
module.random = require "kernel.kit.random"
module.orders = require "kernel.kit.orders"
module.table = require "kernel.kit.table"


-- definitions --
module.ingame_format = function(source, ...)
	for i, substitute in ipairs {...} do
		source = source:gsub("%%" .. i, module.ingame_string(substitute))
	end

	return source
end

module.short_string = function(object)
	local result = module._short_string(object)

	if #result > 256 then
		return result:sub(1, 253) .. "..."
	end

	return result
end

module._short_string = function(object)
	if type(object) ~= "table" then
		return tostring(object)
	end

	if #object == kit.table.size(object) then
		return "{%s}" % table.concat(
			fun.iter(object)
				:map(module._short_string)
				:totable(), 
			", "
		)
	end

	return object.name 
		or object.codename 
		or tostring(object)
end

module.ingame_string = function(object)
	return type(object) ~= "table" and object 
		or object.name 
		or object.codename 
		or tostring(object)
end

local query_system = require "systems.update.query"
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