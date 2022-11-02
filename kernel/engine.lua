--- love + ECS + internal structure integration
local module = {}


-- functions --
module.parse_launch_parameters = function(args)
	args[-2] = nil
	args[-1] = nil

	local parser = argparse()
		:name "rex_astra"
		:description "Run the Rex Astra game"

	parser:help_max_width(80)

	parser:argument("case", "Lua code to execute in the beginning of the game")
		:args "*"

	parser:group("Main stuff", 
		parser:flag(
			"-d --debug", 
			"Use the debug mode: displays log console, adds debug console to " ..
			"the game"
		),

		parser:option(
			"-r --resolution", 
			"Resolution of the game in format <width>x<height>; should " ..
			"be proportional %sx%s, %sx%s if empty" % 
			{world_size[1], world_size[2], 
			 world_size[1] * 3, world_size[2] * 3}
		)
			:args "?"
			:action(function(args, index, value) 
				if #value == 0 then
					args[index] = world_size * 3
					return
				end

				local r = vector[2].parse(value[1], "%xx%y")

				if not r then
					error "Wrong format of --resolution option"
				end
				
				if r:proportion_to(world_size) % 1 ~= 0 then
					error(
						"--resolution should be proportional to %sx%s" % 
						world_size
					)
				end

				args[index] = r
			end),

		parser:option(
			"-l --language",
			"Localization of the game; supports EN, RU."
		)
			:default("EN")
	)

	parser:group("Questionable stuff", 
		parser:flag(
			"-m --trace-mouse", 
			"Output mouse position every tick (Legacy feature)"
		)
	)

	local result = parser:parse(args)

	result.case = table.concat(result.case, " ")

	return result
end

local tsort_systems = function(systems)
	local systems_map = fun.iter(systems)
		:map(function(s) return s.codename, s end)
		:tomap()

	for _, s in ipairs(systems) do
		for _, o_name in ipairs(s.after) do
			local o = systems_map[o_name]
			o.before = o.before
			table.insert(o.before, s.codename)
		end

		s.after = nil
	end

	local result = {}
	local source = fun.iter(systems)
		:filter(function(e) return
			not fun.iter(systems)
				:any(function(s) return 
					kit.table.contains(s.before, e.codename)
				end)
		end)
		:map(function(e) return e, true end)
		:tomap()

	while not kit.table.empty(source) do
		local n = kit.table.pop(source)
		table.insert(result, n)
		n_before = n.before
		n.before = nil
		for _, m_name in ipairs(n_before) do
			local m = systems_map[m_name]

			if not fun.iter(systems)
				:any(function(s) return 
					s.before and kit.table.contains(s.before, m.codename)
				end)
			then
				source[m] = true
			end
		end
	end

	local remaining = fun.iter(systems)
		:filter(function(s) return s.before and #s.before > 0 end)
		:map(function(s) return "%s > %s" % {s.codename, s.before} end)
		:totable()

	if #remaining > 0
	then
		error(
			"There is at least one cycle in the systems " .. inspect(remaining)
		)
	end

	return result
end

module.load_systems = function(world)
	systems = {}

	for _, system_folder in ipairs(love.filesystem.getDirectoryItems("systems")) do
		for _, system_file in ipairs(love.filesystem.getDirectoryItems("systems/" .. system_folder)) do
			system_name = system_file:sub(1, -5)

			local system = require("systems.%s.%s" % {system_folder, system_name})
			system.name = "systems." .. system_name
			system.codename = system_name
			system.system_type = system_folder

			kit.table.merge(system, {
				before = {},
				after = {}
			})

			table.insert(systems, system)

			if not fun.iter(module.events):index(system.system_type) then
				log.warn(
					"System `%s` has unrecognized type `%s`" %
					{system.name, system.system_type}
				)
			end
		end
	end

	systems = tsort_systems(systems)
	
	log.info(
		"Loaded systems", 
		fun.iter(systems):map(function(s) return s.codename end):totable()
	)

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
				function(_, x) return 
					not (ui.mode == ui.modes.pause and x.ingame) 
					and x.system_type == callback 
				end
			)
		end
	end
end

module.keySystem = function(kind, t)
	return tiny.system(kit.table.merge(t, {
		system_type = "key" .. kind,
		update = function(self, event)
			local _, scancode = unpack(event)
			if devices.keyboard.mutex[kind][scancode] then return end
			devices.keyboard.mutex[kind][scancode] = self:process_key(scancode)
		end,
	}))
end


return module