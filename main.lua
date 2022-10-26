-- The only place a global can be defined in is here

local loading_time = os.time()

-- this is for between-libraries dependencies
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua")

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
		log.stack_delta = 1
		log.warn("Undefined global variable %s" % {index})
		log.stack_delta = nil
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
information = require "kernel.information"


-- engine initialization --
love.load = function(args)
	log.info("Loading the game")

	launch = engine.parse_launch_parameters(args)

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
		"information",
	})
	
	engine.override_game_cycle(world)

	player = world:addEntity(prototypes.player {
		name = "Rex Astra",
		codename = "player",
		color = graphics.palette.player,
		gold = 0,

		win = function(self)
			
		end,

		lose = function(self)
			ui.chat(
				"The last army of Rex Astra was destroyed. Thousands have " ..
				"died, fighting for something greater. The Rex himself " ..
				"quickly left the dangerous planet. He will spend some " ..
				"time resting in the halls of Astral Keep and return " ..
				"in a couple hundred years with the new forces."
			)

			ui.chat("selection{You lost!}")
		end,
	})

	log.info("Loading the level")
	level = require("levels.first").load(world)
	information.register.game_starts()

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})
end
