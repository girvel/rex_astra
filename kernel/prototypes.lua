local module = {}


-- definitions --
module.coin = function(province)
	local hitbox = love.image.newImageData("sprites/golden_coin.png")
	return {
		name = "coin",
		sprite = love.graphics.newImage("sprites/golden_coin.png"),
		hitbox = hitbox,
		layer = graphics.layers.coin,
		position = province.anchor_position - vector {
			hitbox:getWidth() / 2, 
			hitbox:getHeight(),
		},
		coin_flag = true,
		parent_province = province,
	}
end

module.narrator = function(path)
	return {
		name = "narrator",
		interpret = fun.iter(love.filesystem.getDirectoryItems(path))
			:map(function(file) return (file / ".")[1], function()
				for _, message 
				in ipairs(kit.read_text(path .. "/" .. file) / "\n\n")
				do
					ui.chat(message)
				end
			end end)
			:tomap()
	}
end

module.planet = function(world, name, path)
	return {
		world = world,
		name = name,
		path = path,
		borders = love.image.newImageData("%s/borders.png" % path),

		add_planet = function(self)
			return self.world:addEntity {
				name = self.name,
				sprite = love.graphics.newImage("%s/planet.png" % self.path),
				layer = graphics.layers.planet,
			}
		end,

		province_defaults = {
			neighbours = {},
			garrison = 0,
			maximal_garrison = 10,
			layer = 1,
			owner = false,
			income_repeater = types.repeater(1),
			defense_k = 1,
		},

		add_province = function(self, province)
			kit.table.merge(province, self.province_defaults)

			province.hitbox = graphics.fill_province_hitbox(
				self.borders, province.anchor_position
			)

			province.highlight = self.world:addEntity {
				name = "highlight: %s" % province.name,
				sprite = graphics.generate_highlight(province.hitbox),
				layer = graphics.layers.highlight,
				is_team_colored = true,
				parent = province,
			}

			province.set_owner = function(self, owner)
				if self.owner then
					self.owner.property[self] = nil
				end

				self.owner = owner

				if self.owner then
					self.owner.property[self] = true
				end
			end

			return self.world:addEntity(province)
		end,
	}
end

module.player = function(entity)
	return kit.table.merge(entity, {
		property = {},
		gold = 0,
		lost = false,
		
		own = function(self, ...)
			for _, subject in ipairs {...} do
				subject:set_owner(self)
			end
		end,
	})
end


return module