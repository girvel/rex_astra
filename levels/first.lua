return {load = function(world)
	local p = {}
	local ai = {}

	ai.jadians = world:addEntity(prototypes.player {
		name = "Jadian nomads",
		color = graphics.palette.jadians,
		is_barbaric = true,

		activity_period = types.repeater(5),
		aggression_chance = .7,

		decide = function(self, dt)
			if not self.activity_period:move(dt):now() then return end

			kit.orders.invest_evenly(self)

			for province, _ in pairs(self.property) do
				if kit.random.chance(self.aggression_chance) then
					kit.orders.attack(
						{province}, 
						kit.random.choose(province.neighbours)
					)
				end
			end
		end,
	})

	ai.zanarthians = world:addEntity(prototypes.player {
		name = "Guardians of Zanartha",
		color = graphics.palette.zanarthians,

		activity_period = types.repeater(5),
		surrender_period = types.repeater(3),

		raid = {
			period = types.repeater(30),
			chance = .7,
		},

		decide = function(self, dt)
			local all_neighbours = {}

			for p, _ in pairs(self.property) do
				for _, n in ipairs(p.neighbours) do
					if n.owner ~= self then
						all_neighbours[n] = true
					end
				end
			end

			if self.activity_period:move(dt):now() then
				kit.orders.invest_evenly(self)

				if  fun.iter(all_neighbours)
						:filter(function(p) return 
							p.owner == player
						end)
						:map(function(p) return p.garrison end)
						:reduce(fun.operator.add, 0) >=
					2 * fun.iter(self.property)
						:map(function(p) return p.garrison end)
						:reduce(fun.operator.add, 0)
				then
					if self.surrender_period:move(1):now() then
						kit.orders.surrender(self, player)

						ui.chat:message(
							"#1{%s} sees your superior army and surrenders" %
							self.name,
							self.color
						)
					end
				else
					self.surrender_period.value = 0
				end
			end

			if  self.raid.period:move(dt):now() and 
				kit.random.chance(self.raid.chance) 
			then
				local targets = fun.iter(all_neighbours)
					:filter(function(n) return
						n.owner and n.owner.is_barbaric and n.garrison > 0 
					end)
					:totable()

				if #targets > 0 then
					local target = kit.random.choose(targets)

					kit.orders.attack(self.property, target)

					ui.chat:message(
						"#1{%s} ride against barbarians in %s" %
						{self.name, target.name},
						self.color
					)
				end
			end
		end,
	})

	local zandara = prototypes.planet(world, "Zandara", "sprites/zandara")

	zandara:add_planet()

	p.sod = zandara:add_province {
		name = "Coast of Sod",
		anchor_position = vector {233, 35},
		fertility = .03,
		maximal_garrison = 8,
	}

	p.annar = zandara:add_province {
		name = "Taiga of Annar",
		anchor_position = vector {220, 66},
		fertility = .05,
	}

	p.dowur = zandara:add_province {
		name = "Dowur lowlands",
		anchor_position = vector {248, 56},
		fertility = .12,
	}

	p.venedai = zandara:add_province {
		name = "Venedai reach",
		garrison = 2,
		anchor_position = vector {189, 77},
		fertility = .11,
	}

	p.zanartha = zandara:add_province {
		name = "Zanartha highland",
		anchor_position = vector {236, 92},
		fertility = .06,
		maximal_garrison = 11,
		garrison = 8,
		defense_k = 1.1,
	}

	p.jadia = zandara:add_province {
		name = "Jadia edge",
		fertility = .07,
		anchor_position = vector {170, 90},
	}

	p.reimin = zandara:add_province {
		name = "Reimin plains",
		fertility = .10,
		anchor_position = vector {220, 100},
	}

	p.uxan = zandara:add_province {
		name = "Uxan peaks",
		fertility = .02,
		anchor_position = vector {259, 98},
		maximal_garrison = 12,
		garrison = 7,
		defense_k = 1.3,
	}

	p.reidan = zandara:add_province {
		name = "Reidan swamp",
		fertility = .15,
		anchor_position = vector {266, 66},
		garrison = 2,
	}

	p.lower_mikara = zandara:add_province {
		name = "Lower mikara",
		fertility = .01,
		anchor_position = vector {186, 21},
	}

	p.higher_mikara = zandara:add_province {
		name = "Higher mikara",
		fertility = .003,
		anchor_position = vector {171, 21},
	}

	p.antaris = zandara:add_province {
		name = "Antaris archipelago",
		fertility = .09,
		anchor_position = vector {85, 30},
	}

	p.devarus = zandara:add_province {
		name = "Devarus",
		fertility = .13,
		anchor_position = vector {75, 46},
	}

	p.fulthu = zandara:add_province {
		name = "Lost peninsula of Fulthu",
		fertility = .14,
		anchor_position = vector {126, 73},
	}

	player:own(p.reidan)
	ai.jadians:own(p.annar, p.venedai, p.jadia)
	ai.zanarthians:own(p.zanartha, p.uxan)

	p.fulthu.neighbours = {p.devarus, p.jadia}
	p.devarus.neighbours = {p.antaris, p.fulthu}
	p.antaris.neighbours = {p.higher_mikara, p.devarus}
	p.higher_mikara.neighbours = {p.lower_mikara, p.antaris}
	p.lower_mikara.neighbours = {p.higher_mikara, p.sod}
	p.sod.neighbours = {p.annar, p.dowur, p.lower_mikara}
	p.annar.neighbours = {p.sod, p.dowur, p.venedai, p.zanartha, p.uxan}
	p.dowur.neighbours = {p.sod, p.annar, p.uxan, p.reidan}
	p.venedai.neighbours = {p.annar, p.jadia, p.reimin}
	p.zanartha.neighbours = {p.annar, p.reimin, p.uxan}
	p.jadia.neighbours = {p.venedai, p.reimin, p.fulthu}
	p.reimin.neighbours = {p.jadia, p.venedai, p.annar, p.zanartha, p.uxan}
	p.uxan.neighbours = {p.reimin, p.zanartha, p.annar, p.dowur, p.reidan}
	p.reidan.neighbours = {p.uxan, p.dowur}

	return {
		ai = ai,
		provinces = p,
	}
end}
