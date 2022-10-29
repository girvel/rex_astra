-- The only place a global can be defined in is here

local loading_time = os.time()

-- this is for between-libraries dependencies
love.filesystem.setRequirePath(
	love.filesystem.getRequirePath() .. 
	";lib/?.lua"
)

-- libraries --
log = require "log"
d = log.debug

log.info("Loading libraries")
require "strong"
argparse = require "argparse"
tiny = require "tiny"
gamera = require "gamera"
inspect = require "inspect"
fun = require "fun"

setmetatable(_G, {
	__index = function(self, index)
		log.stack_delta = 1
		log.warn("Undefined global variable %s" % {index})
		log.stack_delta = nil
	end,
})

-- kernel --
log.info("Loading kernel")

vector = require "kernel.vector"
world_size = vector {480, 270}

types = require "kernel.types"
kit = require "kernel.kit"
engine = require "kernel.engine"
graphics = require "kernel.graphics"
ui = require "kernel.ui"
prototypes = require "kernel.prototypes"
devices = require "kernel.devices"
clock = require "kernel.clock"
information = require "kernel.information"


-- engine initialization --
love.load = function(args)
	log.info("Loading the game")

	launch = engine.parse_launch_parameters(args)
	graphics:initialize()
	ui:initialize()

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
		"ui_modes",
		"select_target",
		"income",
		"modifiers_pressed",
		"modifiers_released",
		"query",
		"ai",
		"ending",
		"hotkeys_ui",
		"information",
	})
	
	engine.override_game_cycle(world)

	player = world:addEntity(prototypes.player {
		name = "Rex Astra",
		codename = "player",
		color = graphics.palette.player,
		gold = 0,
	})

	log.info("Loading the level")
	level = require("levels.first").load(world)
	information.register.game_start()

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})

	if #launch.case > 0 then
		log.info("Executing the case `%s`" % launch.case)
		log.info(pcall(load(launch.case)))
	end
end
