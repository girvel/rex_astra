local types = require "kernel.types"


local module = {}


-- initialization --
module.initialize = function(self)
	love.mouse.setVisible(false)
	if launch.resolution then
		self.window_size = launch.resolution
		love.window.setMode(unpack(self.window_size))
	else
		love.window.setFullscreen(true, "desktop")
		self.window_size = vector {love.graphics.getDimensions()}
	end

	self.scale = self.window_size:soft_proportion_to(world_size)

	-- create black lines
	local d = (world_size * self.scale - self.window_size) / 2
	self.window_size = world_size * self.scale

	love.graphics.setDefaultFilter("nearest", "nearest")

	self.camera = gamera.new(0, 0, unpack(world_size))
	self.camera:setScale(self.scale)
	self.camera:setPosition(unpack(d))

	self.ui_camera = gamera.new(0, 0, unpack(self.window_size))
	self.ui_camera:setPosition(unpack(d))
end

module.palette = types.palette("sprites/palette.png", {
	"transparent",
	"sea_blue",
	"tropic_green",
	"cold_gray",
	"white",
	"black",
	"casual_gold",
	"selection",
	"jadians",
	"player",
	"savanna_yellow",
	"zanarthians",
})

module.layers = types.enumeration {
	"planet",
	"highlight",
	"coin",
}

module.fonts = {
	small = love.graphics.newFont("fonts/aseprite-remix.ttf", 7),
	normal = love.graphics.newFont("fonts/aseprite-remix.ttf", 14),
	ui_small = love.graphics.newFont("fonts/aseprite-remix.ttf", 14),
	ui_normal = love.graphics.newFont("fonts/aseprite-remix.ttf", 28),
}

for _, f in pairs(module.fonts) do
	f:setFilter("nearest", "nearest")
end

module.pixels_near = function(x, y, w, h)
	return fun.iter {
		{x + 1, y},
		{x - 1, y},
		{x, y + 1},
		{x, y - 1},
	}
		:filter(function(pos) return 
			pos[1] >= 0 and
			pos[2] >= 0 and
			pos[1] < w and
			pos[2] < h
		end)
end

module.generate_highlight = function(province_data)
	local data = love.image.newImageData(
		province_data:getWidth(),
		province_data:getHeight()
	)

	local w = province_data:getWidth()
	local h = province_data:getHeight()

	for _, x in fun.range(0, w - 1) do
		for _, y in fun.range(0, h - 1) do
			if ({province_data:getPixel(x, y)})[4] == 0 and
				module.pixels_near(x, y, w, h)
					:reduce(function(acc, pos) return 
						acc or ({province_data:getPixel(unpack(pos))})[4] == 1
					end, false)
			then
				data:setPixel(x, y, unpack(graphics.palette.white))
			end
		end
	end

	return data
end

module.fill_province_hitbox = function(borders, position, hitbox)
	hitbox = hitbox or love.image.newImageData(
		borders:getWidth(), borders:getHeight()
	)

	if ({borders:getPixel(unpack(position))})[4] > 0 or 
		({hitbox:getPixel(unpack(position))})[4] > 0 
	then
		return hitbox
	end

	hitbox:setPixel(position[1], position[2], unpack(graphics.palette.white))

	for _, p in module.pixels_near(
		position[1], position[2], borders:getWidth(), borders:getHeight()
	) do
		module.fill_province_hitbox(borders, p, hitbox)
	end

	return hitbox
end

module.centered_print = function(position, text)
	local font = love.graphics.getFont()
	local w = font:getWidth(text)
	local h = font:getHeight()

	love.graphics.print(text, position[1], position[2], 0, 1, 1, w / 2, h / 2)
end

module.generate_cached = function(cache_path, source_path, f, ...)
	if cache_path:exists() and cache_path:modtime() >= source_path:modtime() then
		return cache_path:load_image_data()
	end

	local value = f(...)
	cache_path:write_image_data(value)
	return value
end


return module