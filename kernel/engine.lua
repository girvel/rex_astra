--- love + ECS + internal structure integration
local module = {}


-- functions --
module.parse_launch_parameters = function(args)
	args[-2] = nil
	args[-1] = nil

	local parser = argparse()
		:name "rex_astra"
		:description "Run the Rex Astra game"

	parser:argument("case", "Lua code to execute in the beginning of the game")
		:args "*"

	parser:flag "-m --trace-mouse"
	parser:flag "-d --debug"

	local result = parser:parse(args)

	result.case = table.concat(result.case, " ")

	return result
end

module.load_systems = function(world, order)
	order = fun.iter(order)
		:enumerate()
		:map(function(i, s) return s, i end)
		:tomap()

	systems = {}

	for _, system_file in ipairs(love.filesystem.getDirectoryItems("systems")) do
		system_name = system_file:sub(1, -5)

		if order[system_name] then
			local system = require("systems." .. system_name)
			systems[order[system_name]] = system

			if not fun.iter(module.events):index(system.system_type) then
				log.warn(
					"System `%s` has unrecognized type `%s`" %
					{system.name, system.system_type}
				)
			end
		else
			log.warn("Detected unlisted system `%s`" % system_name)
		end
	end

	for _, s in ipairs(systems) do
		world:addSystem(s)
	end
end

module.events = {
	'update', 
	'textinput',
	'keypressed', 
	'keyreleased', 
	'mousepressed', 
	'draw',
}

module.override_game_cycle = function(world)
	for _, callback in ipairs(module.events) do
		love[callback] = function(...)
			world:update(
				select('#', ...) == 1 and select(1, ...) or {...},
				function(_, x) return x.system_type == callback end
			)
		end
	end
end


return module