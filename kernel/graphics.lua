local types = require "kernel.types"


local module = {}


-- initialization --
module.world_size = vector {480, 270}
module.scale = 3
module.window_size = module.world_size * module.scale

love.window.setMode(unpack(module.window_size))
love.graphics.setDefaultFilter("nearest", "nearest")

module.camera = gamera.new(0, 0, unpack(module.world_size))
module.camera:setScale(module.scale)

module.palette = types.palette("sprites/palette.png", {
	"transparent",
	"sea_blue",
	"tropic_green",
	"cold_gray",
	"white",
	"black",
	"casual_gold",
	"selection",
	"ai1",
	"player",
})


return module