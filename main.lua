-- GLOBAL IMPORTS --
tiny = require "lib.tiny"
require "lib.strong"
gamera = require "lib.gamera"
log = require "lib.log"
inspect = require "lib.inspect"
fun = require "lib.fun"

local load_sprite = function(path)
	return {
		image = love.graphics.newImage(path),
		data = love.image.newImageData(path),
	}
end

local vector_div = function(vector, coefficient)
	return fun.iter(vector):map(function(v) return v / coefficient end):totable()
end

function love.load()
	log.info("Loading the game")
	world = tiny.world()

	for _, system in ipairs(love.filesystem.getDirectoryItems("systems")) do
		tiny.addSystem(world, require("systems." .. system:sub(1, -5)))
	end

	window_size = {960, 540}
	field_size = vector_div(window_size, 2)

	love.window.setMode(unpack(window_size))
	love.graphics.setDefaultFilter("nearest", "nearest")

	camera = gamera.new(0, 0, 960, 540)
	camera:setScale(2.0)

	-- TODO try world:addEntity
	tiny.addEntity(world, {
		name = "The Planet",
		sprite = load_sprite("sprites/planet.png"),
		position = vector_div(field_size, 2),
		layer = -2,
	})

	tiny.addEntity(world, {
		name = "Island of Sod",
		sprite = load_sprite("sprites/islands/sod.png"),
		position = {100, 100},
		layer = 0,
	})
end

for _, callback in ipairs {'update', 'keypressed', 'mousepressed', 'draw'} do
	love[callback] = function(...)
		world:update(
			select('#', ...) == 1 and select(1, ...) or {...},
			function(_, x) return x.system_type == callback end
		)
	end
end
