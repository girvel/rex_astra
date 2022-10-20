local types = require "kernel.types"


local module = {}


-- definitions --
module.layers = types.enumeration {
	"planet",
	"highlight",
	"coin",
}

module.ui_modes = types.enumeration {
	"normal",
	"investing",
	"aggression",
}

module.maximal_garrison = 10

module.fonts = {
	small = love.graphics.newFont("fonts/aseprite-remix.ttf", 7),
	normal = love.graphics.newFont("fonts/aseprite-remix.ttf", 14),
}

for _, f in pairs(module.fonts) do
	f:setFilter("nearest", "nearest")
end


return module