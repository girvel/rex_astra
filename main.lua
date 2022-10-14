-- GLOBAL IMPORTS --
package.path = package.path .. ";lib/?.lua"

require "strong"
tiny = require "tiny"
gamera = require "gamera"
log = require "log"
inspect = require "inspect"
fun = require "fun"

vector = require "kernel.vector"

local load_sprite = function(path)
	return {
		image = love.graphics.newImage(path),
		data = love.image.newImageData(path),
	}
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

is_mouse_over = function(entity)
	local mouse_position = vector {camera:toWorld(love.mouse.getPosition())}
	mouse_position = mouse_position - (entity.position or {0, 0})

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

	window_size = vector {960, 540}
	world_size = window_size / 2

	love.window.setMode(unpack(window_size))
	love.graphics.setDefaultFilter("nearest", "nearest")

	camera = gamera.new(0, 0, unpack(world_size))
	camera:setScale(2.0)

	world:addEntity {
		name = "The Planet",
		sprite = load_sprite("sprites/planet.png"),
		layer = layers.planet,
	}

	world:addEntity {
		name = "Island of Sod",
		sprite = load_sprite("sprites/islands/sod.png"),
		layer = layers.island,
		highlight = world:addEntity {
			name = "[Island of Sod] Highlight",
			sprite = load_sprite("sprites/highlights/sod.png"),
			layer = layers.highlight
		}
	}
end

for _, callback in ipairs {'update', 'keypressed', 'mousepressed', 'draw'} do
	love[callback] = function(...)
		world:update(
			select('#', ...) == 1 and select(1, ...) or {...},
			function(_, x) return x.system_type == callback end
		)
	end
end
