local standard = require "kernel.standard"


local module = {}


-- definitions --
module.load_sprite = function(path)
	return {
		image = love.graphics.newImage(path),
		data = love.image.newImageData(path),
	}
end

module.planet = function(world, name, path)
	return {
		world = world,
		name = name,
		path = path,

		add_planet = function(self)
			self.world:addEntity {
				name = self.name,
				sprite = kit.load_sprite("%s/planet.png" % self.path),
				layer = standard.layers.planet,
			}
		end,

		add_province = function(self, name, province)
			province.neighbours = province.neighbours or {}
			province.sprite = module.load_sprite("%s/provinces/%s.png" % {self.path, name})
			province.layer = standard.layers.province
			province.highlight = self.world:addEntity {
				name = "highlight: %s" % name,
				sprite = module.load_sprite("%s/highlights/%s.png" % {self.path, name}),
				layer = standard.layers.highlight,
				is_team_colored = true,
				parent = province,
			}

			return self.world:addEntity(province)
		end,
	}
end

module.add_province = function(planet, name, province)
	province.neighbours = province.neighbours or {}
	province.sprite = module.load_sprite("%s/provinces/%s.png" % {planet, name})
	province.layer = standard.layers.province
	province.highlight = world:addEntity {
		name = "highlight: %s" % name,
		sprite = module.load_sprite("%s/highlights/%s.png" % {planet, name}),
		layer = standard.layers.highlight,
		is_team_colored = true,
		parent = province,
	}

	return world:addEntity(province)
end

module.add_coin = function(province)
	local sprite = module.load_sprite("sprites/golden_coin.png")
	return world:addEntity {
		name = "coin",
		sprite = sprite,
		layer = standard.layers.coin,
		position = province.anchor_position - vector {
			sprite.data:getWidth() / 2, 
			sprite.data:getHeight(),
		},
		coin_flag = true,
		parent_province = province,
	}
end

module.is_mouse_over = function(entity)
	local mouse_position = vector {graphics.camera:toWorld(love.mouse.getPosition())}
	mouse_position = mouse_position - (entity.position or {0, 0})

	if (mouse_position[1] <= 0 or 
		mouse_position[2] <= 0 or 
		mouse_position[1] > entity.sprite.data:getWidth() or
		mouse_position[2] > entity.sprite.data:getHeight()
	) then
		return false
	end

	local r, g, b, a = entity.sprite.data:getPixel(unpack(mouse_position))
	return a > 0
end

module.centered_print = function(position, text)
	local font = love.graphics.getFont()
	local w = font:getWidth(text)
	local h = font:getHeight()

	love.graphics.print(text, position[1], position[2], 0, 1, 1, w / 2, h / 2)
end

module.chance = function(chance)
	return math.random() < chance
end

module.invest = function(entity)
	if  entity.garrison < (entity.maximal_garrison or standard.maximal_garrison) and
		entity.garrison <= entity.owner.gold
	then
		entity.owner.gold = entity.owner.gold - entity.garrison
		entity.garrison = entity.garrison + 1
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

	log.info("%s attack %s" % {
		table.concat(fun.iter(army)
			:map(function(e) return "%s (%s)" % {e.name, e.owner.name} end)
			:totable(), ", "),
		"%s (%s)" % {target.name, target.owner.name},
	})

	if kit.chance(attacking_force / (attacking_force + 1.5 * target.garrison)) then
		target.garrison = target.garrison - 1

		if target.garrison < 0 then
			target.owner = army[1].owner
			target.garrison = 0
		end

		return true
	else
		army[1].garrison = army[1].garrison - 1

		return false
	end
end

return module