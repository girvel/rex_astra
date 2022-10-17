local types = require "kernel.types"


local module = {}


-- definitions --
module.layers = types.enumeration {
	"planet",
	"highlight",
	"coin",
}

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

module.ui_modes = types.enumeration {
	"normal",
	"investing",
	"aggression",
}

module.maximal_garrison = 10

module.fonts = {
	small = love.graphics.newFont(8),
	normal = love.graphics.newFont(12),
}

for _, f in pairs(module.fonts) do
	f:setFilter("nearest", "nearest")
end


return module