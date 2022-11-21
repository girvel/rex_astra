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

module.narrator = function(directory, narrator)
	kit.table.merge(narrator, {
		name = "Narrator",
		lines = setmetatable({}, {__index = function(_, index)
			local content = (
				directory / launch.language / (index .. ".txt")
			):load_text()

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

module.planet = function(world, name, directory)
	return {
		world = world,
		name = name,
		path = directory,
		borders = (directory / "borders.png"):load_image_data(),

		add_planet = function(self)
			return self.world:addEntity {
				name = self.name,
				sprite = (self.path / "planet.png"):load_image(),
				layer = graphics.layers.planet,
			}
		end,

		add_highlight = function(self, province)
			local sprite = love.graphics.newImage(graphics.generate_cached(
				self.path / ("highlights/%s.png" % province.codename),
				self.path / "borders.png",
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

		_area_defaults = {
			name = "Unknown place",
			layer = 1,
			owner = false,
			defense_k = 1,

			connect = function(self, neighbour, ...)
				if neighbour == nil then return end

				self.neighbours[neighbour] = true
				neighbour.neighbours[self] = true

				self:connect(...)
			end
		},

		_add_area = function(self, source)
			kit.table.merge(source, self._area_defaults)

			source.neighbours = source.neighbours or {}

			local success, value = pcall(
				graphics.generate_cached,
				self.path / ("provinces/%s.png" % source.codename),
				self.path / "borders.png",
				graphics.fill_province_hitbox,
				self.borders, 
				source.anchor_position
			)

			if success then
				source.hitbox = value
			elseif value("overflow") then
				error("Unable to generate hitbox for area %s" % source.codename, 2)
			else
				error(value)
			end

			source.highlight = self:add_highlight(source)

			return self.world:addEntity(source)
		end,

		province_defaults = {
			garrison = 0,
			maximal_garrison = 10,
			income_repeater = types.repeater(1),
			contains_land = true,

			set_owner = function(self, owner)
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
			end,
		},

		add_province = function(self, source)
			kit.table.merge(source, self.province_defaults)

			return self:_add_area(source)
		end,

		waters_defaults = {
			fleet = 0,
			maximal_fleet = 15,
			contains_sea = true,
		},

		add_waters = function(self, source)
			kit.table.merge(source, self.waters_defaults)

			return self:_add_area(source)
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