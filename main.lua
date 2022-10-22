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
			ui.chat(
				"Now the lands of Zandara belong to the Rex Astra. Soon they " ..
				"will finish the colonization process and start preparing " ..
				"the planet to join the Regis Astra Coalition."
			)

			ui.chat("casual_gold{You win!}")

			if level.ai.zanarthians.surrendered then
				ui.chat(
					"You have discovered a player{peaceful ending}."
				)
			else
				ui.chat(
					"You have discovered a selection{violent ending}."
				)
			end
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

	ui.chat(
		"Press player{[Shift + H]} to display help."
	)

	ui.chat(
		"You arrive to the mysterious planet of Zandara. You are a Rex " ..
		"Astra, one of the mythical Star Kings, that conquer galaxies just " ..
		"for fun. To get this planet, you have to defeat two powerful " ..
		"opponents."
	)

	ui.chat(
		"The first one is the Jadian nomads, the wild tribes of " ..
		"bloodthirsty savages that wander the reaches of Zandara. They " ..
		"do not care for better life or greater good and can be defeated " ..
		"only with a brutal force."
	)

	ui.chat(
		"The second one is the Guards of Zanartha, the legendary religious " ..
		"order, consisting of thousands of brave and honourable warriors. " ..
		"They are powerful and dangerous, but also reasonable."
	)

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})
end
