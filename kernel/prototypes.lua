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
		} + vector[2].up() * 2,
		coin_flag = true,
		parent_province = province,
	}
end

module.narrator = function(path, narrator)
	kit.table.merge(narrator, {
		name = "Narrator",
		lines = setmetatable({}, {__index = function(_, index)
			local content = kit.read_text(
				path .. "/" .. launch.language .. "/" .. index .. ".txt"
			)

			content = content and (content / "\n\n") or {}

			content.play = function(self, ...)
				for _, message in ipairs(self) do
					ui.chat(kit.ingame_format(message, ...))
				end
			end

			return content
		end}),
	})

	narrator.interpret = setmetatable(narrator.interpret or {}, {
		__index = function(_, index)
			return function(...) narrator.lines[index]:play(...) end
		end,
	})

	return narrator
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

		add_highlight = function(self, province)
			local sprite = love.graphics.newImage(graphics.generate_cached(
				"%s/highlights/%s.png" % {self.path, province.codename},
				"%s/borders.png" % self.path,
				graphics.generate_highlight,
				province.hitbox
			))

			return self.world:addEntity {
				name = "highlight: %s" % province.codename,
				sprite = sprite,
				layer = graphics.layers.highlight,
				is_team_colored = true,
				parent = province,
				opacity = 0,
			}
		end,

		add_province = function(self, province)
			kit.table.merge(province, self.province_defaults)

			local success, value = pcall(
				graphics.generate_cached,
				"%s/provinces/%s.png" % {self.path, province.codename},
				"%s/borders.png" % self.path,
				graphics.fill_province_hitbox,
				self.borders, 
				province.anchor_position
			)

			if success then
				province.hitbox = value
			elseif value("overflow") then
				error(
					"Unable to generate hitbox for province %s" % province.codename, 2
				)
			else
				error(value)
			end

			province.highlight = self:add_highlight(province)

			province.set_owner = function(self, owner)
				if self.owner then
					self.owner.property[self] = nil
				end

				self.owner = owner

				if self.owner then
					self.owner.property[self] = true

					if self.owner ~= player and self.coin then
						world:removeEntity(self.coin)
						self.coin = nil
					end
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