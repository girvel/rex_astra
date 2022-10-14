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
})


return module