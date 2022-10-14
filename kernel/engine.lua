--- love + ECS + internal structure integration
local module = {}


-- functions --
module.load_systems = function(world)
	for _, system in ipairs(love.filesystem.getDirectoryItems("systems")) do
		world:addSystem(require("systems." .. system:sub(1, -5)))
	end
end

module.override_game_cycle = function(world)
	for _, callback in ipairs {'update', 'keypressed', 'mousepressed', 'draw'} do
		love[callback] = function(...)
			world:update(
				select('#', ...) == 1 and select(1, ...) or {...},
				function(_, x) return x.system_type == callback end
			)
		end
	end
end


return module