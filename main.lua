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

kit = require "kernel.kit"
vector = require "kernel.vector"
engine = require "kernel.engine"
standard = require "kernel.standard"
graphics = require "kernel.graphics"
types = require "kernel.types"


-- engine initialization --
love.load = function(args)
	log.info("Loading the game")

	launch = engine.parse_launch_parameters(args)

	world = tiny.world()
	engine.load_systems(world, {
		"mutex",

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
		mutex = {
			pressed = {},
		},
		modifier_by_scancode = {
			rshift = "shift",
			lshift = "shift",
		},
	}

	mouse = {
		mutex = {
			pressed = {},
			over = false,
		},
	}

	ui = {
		mode = standard.ui_modes.normal,
		sources = {},
		console = {
			command = "",
			active = false,
		},
		chat = {
			{standard.palette.white, "Hello!"},

			w = graphics.world_size[1] / 4,
			font = standard.fonts.small,
			put = function(self, message, color)
				color = color or standard.palette.white

				local i = math.min(#message, math.floor(self.w / self.font:getWidth('w')))

				while #message > 0 do
					if  i < #message and 
						self.font:getWidth(message:sub(1, i + 1)) < self.w 
					then
						i = i + 1
					else 
						table.insert(self, {color, message:sub(1, i)})
						message = message:sub(i + 1, #message)
						i = math.min(#message, math.floor(self.w / self.font:getWidth('w')))
					end
				end
			end,
		},
	}

	ui.chat:put("Lorem ipsum dolor sit amet", standard.palette.player)

	log.info("Loading the level")
	level = require("levels.first").load(world)

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})
end
