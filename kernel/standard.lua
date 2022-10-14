local kit = require "kernel.kit"


local module = {}


-- definitions --
module.layers = kit.enumeration {
	"planet",
	"island",
	"highlight",
}

module.palette = kit.get_palette("sprites/palette.png", {
	"transparent",
	"sea_blue",
	"tropic_green",
	"cold_gray",
	"white",
	"black",
})


return module