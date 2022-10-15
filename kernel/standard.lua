local types = require "kernel.types"


local module = {}


-- definitions --
module.layers = types.enumeration {
	"planet",
	"province",
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


return module