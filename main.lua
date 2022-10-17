-- The only place a global can be defined in is here

-- this is for between-libraries dependencies
package.path = package.path .. ";lib/?.lua"

-- libraries --
require "strong"
argparse = require "argparse"
tiny = require "tiny"
gamera = require "gamera"
log = require "log"
inspect = require "inspect"
fun = require "fun"

-- TODO warning on empty globals

-- kernel --
kit = require "kernel.kit"
vector = require "kernel.vector"
engine = require "kernel.engine"
standard = require "kernel.standard"
graphics = require "kernel.graphics"
types = require "kernel.types"


-- engine initialization --
love.load = function(args)
	launch = engine.parse_launch_parameters(args)

	world = tiny.world()
	engine.load_systems(world, {
		"keyboard_mutex",

		"collecting",
		"console_special_keys",
		"console_input",
		"debugging",
		"drawing",
		"highlighting",
		"hotkeys",
		"hotkeys_target",
		"income",
		"modifiers_pressed",
		"modifiers_released",
		"query",
	})
	engine.override_game_cycle(world)

	player = {
		name = "Rex Astra",
		color = standard.palette.player,
		gold = 0,
	}

	keyboard = {
		modifiers = {
			shift = false,
		},
		mutex_lock = {},
		modifier_by_scancode = {
			rshift = "shift",
			lshift = "shift",
		},
	}

	ui = {
		mode = standard.ui_modes.normal,
		sources = {},
		console = {
			command = "",
			active = false,
		}
	}

	level = require("levels.first").load(world)
end
