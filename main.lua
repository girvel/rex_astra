function love.load()
	love.window.setMode(960, 540)
	love.graphics.setDefaultFilter("nearest", "nearest")

	planet = love.graphics.newImage("assets/sprites/planet.png")
end

function love.draw()
	love.graphics.scale(2, 2)
	love.graphics.draw(planet, 0, 0)
end
