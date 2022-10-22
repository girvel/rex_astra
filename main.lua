-- The only place a global can be defined in is here

local loading_time = os.time()

-- this is for between-libraries dependencies
package.path = package.path .. ";lib/?.lua"

-- libraries --
log = require "log"

log.info("Loading libraries")
require "strong"
argparse = require "argparse"
tiny = require "tiny"
gamera = require "gamera"
inspect = require "inspect"
fun = require "fun"

setmetatable(_G, {
	__index = function(self, index)
		log.warn("Undefined global variable %s" % {index})
	end,
})

-- kernel --
log.info("Loading kernel")

types = require "kernel.types"
kit = require "kernel.kit"
vector = require "kernel.vector"
engine = require "kernel.engine"
graphics = require "kernel.graphics"
ui = require "kernel.ui"
prototypes = require "kernel.prototypes"
devices = require "kernel.devices"
clock = require "kernel.clock"


-- engine initialization --
love.load = function(args)
	log.info("Loading the game")

	launch = engine.parse_launch_parameters(args)
	log.level = launch.debug and "trace" or "info"

	world = tiny.world()
	engine.load_systems(world, {
		"mutex",

		"clock",
		"collecting",
		"console_special_keys",
		"console_input",
		"debugging",
		"drawing",
		"highlighting",
		"hotkeys",
		"select_target",
		"income",
		"modifiers_pressed",
		"modifiers_released",
		"query",
		"ai",
		"ending",
	})
	
	engine.override_game_cycle(world)

	player = world:addEntity(prototypes.player {
		name = "Rex Astra",
		color = graphics.palette.player,
		gold = 0,

		win = function(self)
			ui.chat:message("casual_gold{You win!}")
		end,

		lose = function(self)
			ui.chat:message("selection{You lost!}")
		end,
	})

	log.info("Loading the level")
	level = require("levels.first").load(world)

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})
end
