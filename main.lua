-- The only place a global can be defined in is here

-- this is for between-libraries dependencies
package.path = package.path .. ";lib/?.lua"

-- libraries --
require "strong"
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


-- engine initialization --
world = tiny.world()

engine.load_systems(world)
engine.override_game_cycle(world)

require("levels.first").load(world)
