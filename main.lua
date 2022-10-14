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
	engine.load_systems(world)
	engine.override_game_cycle(world)

	require("levels.first").load(world)
end
