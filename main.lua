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

local vector_sub = function(a, b)
	return fun.zip(a, b):map(function(u, v) return u - v end):totable()
end

local vector_in = function(a, b)
	return fun.zip(a, b)
		:map(fun.operator.le)
		:reduce(fun.operator.land, true)
end

local enumeration = function(members)
	return fun.iter(members)
		:enumerate()
		:map(function(i, m) return m, i end)
		:tomap()
end

local layers = enumeration {
	"planet",
	"island",
	"highlight",
}

hover = function(entity)
	local mouse_position = {camera:toWorld(love.mouse.getPosition())}
	mouse_position = vector_sub(mouse_position, entity.position)

	if (mouse_position[1] <= 0 or 
		mouse_position[2] <= 0 or 
		mouse_position[1] > entity.sprite.data:getWidth() or
		mouse_position[2] > entity.sprite.data:getHeight()
	) then
		return false
	end

	local r, g, b, a = entity.sprite.data:getPixel(unpack(mouse_position))
	return a > 0
end

function love.load()
	log.info("Loading the game")
	world = tiny.world()

	for _, system in ipairs(love.filesystem.getDirectoryItems("systems")) do
		tiny.addSystem(world, require("systems." .. system:sub(1, -5)))
	end

	window_size = {960, 540}
	world_size = vector_div(window_size, 2)

	love.window.setMode(unpack(window_size))
	love.graphics.setDefaultFilter("nearest", "nearest")

	camera = gamera.new(0, 0, unpack(world_size))
	camera:setScale(2.0)

	-- TODO try world:addEntity
	tiny.addEntity(world, {
		name = "The Planet",
		sprite = load_sprite("sprites/planet.png"),
		layer = layers.planet,
	})

	tiny.addEntity(world, {
		name = "Island of Sod",
		sprite = load_sprite("sprites/islands/sod.png"),
		layer = layers.island,
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
