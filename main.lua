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
			w = graphics.world_size[1] / 4,
			font = standard.fonts.small,
			put = function(self, message)
				local line = {}
				local w = self.w
				local i = 0

				local color, text
				while true do
					if i == #message then
						table.insert(self, line)
						return
					end

					color = message[i + 1]
					text = log.debug(message[i + 2])
					local dw = log.debug(self.font:getWidth(text), w)

					if dw > w then break end

					table.insert(line, color)
					table.insert(line, text)

					w = w - dw
					i = i + 2
				end

				local j = math.floor(w / self.font:getWidth('w'))
				repeat
					j = j + 1
				until self.font:getWidth(text:sub(1, j + 1)) >= w

				table.insert(line, color)
				table.insert(line, text:sub(1, j))

				table.insert(self, line)

				self:put(fun.chain(
					fun.iter {color, text:sub(j + 1, #text)},
					fun.iter(message):drop_n(i + 2)
				):totable())
			end,
		},
	}

	ui.chat:put({
		standard.palette.white, "A voice: ", standard.palette.player, 
		"Rex Astra", standard.palette.white, " hit that little girl!"
	})

	log.info("Loading the level")
	level = require("levels.first").load(world)

	loading_time = os.difftime(os.time(), loading_time)
	log.info("Game started in %i s" % {loading_time})
end
