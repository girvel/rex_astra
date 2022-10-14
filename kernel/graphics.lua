local module = {}


-- initialization --
module.window_size = vector {960, 540}
module.world_size = module.window_size / 2

love.window.setMode(unpack(module.window_size))
love.graphics.setDefaultFilter("nearest", "nearest")

module.camera = gamera.new(0, 0, unpack(module.world_size))
module.camera:setScale(2.0)


return module