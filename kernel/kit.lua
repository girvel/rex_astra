local standard = require "kernel.standard"


local module = {}


-- submodules --
module.random = require "kernel.kit.random"


-- definitions --
module.merge = function(first, second)
	for key, value in pairs(second) do
		first[key] = first[key] or value
	end

	return first
end

module.player = function(entity)
	return module.merge(entity, {
		property = {},
		own = function(self, ...)
			for _, subject in ipairs {...} do
				module.set_owner(subject, self)
			end
		end,
	})
end

module.delete = function(t, item)
	local index = fun.iter(t):index(item)
	return index and table.remove(t, index)
end

module.concat = function(self, other)
	for _, e in ipairs(other) do
		table.insert(self, e)
	end

	return self
end

module.set_owner = function(entity, owner)
	if entity.owner then
		kit.delete(owner.property, entity)
	end

	entity.owner = owner

	if entity.owner then
		table.insert(owner.property, entity)
	end
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
	data = love.image.newImageData(
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

	return love.graphics.newImage(data)
end

module.fill_province_hitbox = function(borders, position, hitbox)
	hitbox = hitbox or love.image.newImageData(
		borders:getWidth(), borders:getHeight()
	)

	if  ({borders:getPixel(unpack(position))})[4] > 0 or 
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

module.planet = function(world, name, path)
	return {
		world = world,
		name = name,
		path = path,
		borders = love.image.newImageData("%s/borders.png" % path),

		add_planet = function(self)
			self.world:addEntity {
				name = self.name,
				sprite = love.graphics.newImage("%s/planet.png" % self.path),
				layer = standard.layers.planet,
			}
		end,

		province_defaults = {
			neighbours = {},
			garrison = 0,
			maximal_garrison = standard.maximal_garrison,
			layer = 1,
			owner = false,
		},

		add_province = function(self, province)
			module.merge(province, self.province_defaults)

			province.hitbox = module.fill_province_hitbox(
				self.borders, province.anchor_position
			)

			province.highlight = self.world:addEntity {
				name = "highlight: %s" % province.name,
				sprite = module.generate_highlight(province.hitbox),
				layer = standard.layers.highlight,
				is_team_colored = true,
				parent = province,
			}

			return self.world:addEntity(province)
		end,
	}
end

module.add_coin = function(province)
	local hitbox = love.image.newImageData("sprites/golden_coin.png")
	return world:addEntity {
		name = "coin",
		sprite = love.graphics.newImage("sprites/golden_coin.png"),
		hitbox = hitbox,
		layer = standard.layers.coin,
		position = province.anchor_position - vector {
			hitbox:getWidth() / 2, 
			hitbox:getHeight(),
		},
		coin_flag = true,
		parent_province = province,
	}
end

module.is_mouse_over = function(entity)
	local mouse_position = vector {graphics.camera:toWorld(love.mouse.getPosition())}
	mouse_position = mouse_position - (entity.position or {0, 0})

	if (mouse_position[1] < 0 or 
		mouse_position[2] < 0 or 
		mouse_position[1] >= entity.hitbox:getWidth() or
		mouse_position[2] >= entity.hitbox:getHeight()
	) then
		return false
	end

	local r, g, b, a = entity.hitbox:getPixel(unpack(mouse_position))
	return a > 0
end

module.centered_print = function(position, text)
	local font = love.graphics.getFont()
	local w = font:getWidth(text)
	local h = font:getHeight()

	love.graphics.print(text, position[1], position[2], 0, 1, 1, w / 2, h / 2)
end



module.invest = function(entity, amount)
	if  entity.garrison < entity.maximal_garrison and
		entity.owner.gold >= amount
	then
		entity.owner.gold = entity.owner.gold - amount
		entity.garrison = entity.garrison + amount
		return true
	end

	return false
end

module.attack = function(army, target)
	army = fun.iter(army)
		:filter(function(a) 
			return a.garrison > 0 and fun.iter(target.neighbours):index(a) 
		end)
		:totable()

	local attacking_force = fun.iter(army)
		:reduce(function(acc, a) return acc + a.garrison end, 0)

	if attacking_force <= 0 then
		return false
	end

	if not target.owner then
		ui.chat:message(
			"#1{%s} colonizes %s" % {army[1].owner.name, target.name}, 
			army[1].owner.color
		)

		module.set_owner(target, army[1].owner)
		return true
	end

	if target.owner == army[1].owner then
		for _, entity in ipairs(army) do
			local movement = math.min(
				math.floor(entity.garrison * 2 / 3 + .5), 
				target.maximal_garrison - target.garrison
			)

			entity.garrison = entity.garrison - movement
			target.garrison = target.garrison + movement
		end
		return true
	end

	ui.chat:message(
		"#1{%s} attack %s, #2{%s}" % 
		{army[1].owner.name, target.name, target.owner.name}, 
		army[1].owner.color, target.owner.color
	)

	local success = kit.random.chance(
		attacking_force / (attacking_force + 1.5 * target.garrison)
	)

	if success then
		target.garrison = target.garrison - 1

		if target.garrison < 0 then
			kit.set_owner(target, army[1].owner)
			target.garrison = 0

			ui.chat:message(
				"#1{%s} takes %s" % {army[1].owner.name, target.name}, 
				army[1].owner.color
			)
		end
	else
		army[1].garrison = army[1].garrison - 1
	end

	return success
end

local query_system = require "systems.query"
module.query = function(request_source)
	local _, predicate = load("return function(e) return %s end" % request_source)
	local result = fun.iter(query_system.entities):filter(predicate):totable()
	
	if #result > 1 then
		log.warn(
			"Query `%s` returned more %s values; \n\n%s" % 
			{request_source, #result, inspect(result)}
		)
	end

	return result[1]
end

return module