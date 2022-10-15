local module = {}


-- initialization --
module.world_size = vector {480, 270}
module.scale = 3
module.window_size = module.world_size * module.scale

love.window.setMode(unpack(module.window_size))
love.graphics.setDefaultFilter("nearest", "nearest")

module.camera = gamera.new(0, 0, unpack(module.world_size))
module.camera:setScale(module.scale)


return module