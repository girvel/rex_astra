return {load = function(world)
	local p = {}
	local ai = {}

	ai.jadians = world:addEntity(prototypes.player {
		name = "Jadian nomads",
		color = graphics.palette.jadians,
		is_barbaric = true,

		activity_period = types.repeater(5),
		aggression_chance = .7,

		win = function(self)
			ui.chat(
				"Now the planet Zandara belongs to Jadian nomads. They " ..
				"will continue to travel through its beautiful lands, " ..
				"disturbed by no sentient being."
			)
		end,

		lose = function(self)
			ui.chat(
				"Last one of Jadian nomads dies in battle. The species becomes " ..
				"extinct, but their brave souls will continue the ride in " .. 
				"the fields of eternity."
			)
		end,

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

		surrendered = false,

		win = function(self)
			ui.chat(
				"After the years of brutal war the Guardians of Zanartha " ..
				"remain the last one standing. They have defeated every " ..
				"invader that dared to set foot on Zandara, and now they " ..
				"enter a golden age of peace, prosperity and honour."
			)
		end,

		lose = function(self)
			if self.surrendered then
				ui.chat(
					"After careful consideration the Guardians of Zanartha " ..
					"have decided to stop the conflict and join the empire " ..
					"of the Rex Astra. They will preserve their ancent " ..
					"culture and tradition and continue to defend the lands " ..
					"of Zandara from invaders, but now as a part of the " ..
					"rising intergalactic empire."
				)
			else
				ui.chat(
					"After the series of great battles the legendary " ..
					"civilization of the Guardians of Zanartha ceases to " ..
					"exist. Never again will they ride through the valleys " ..
					"of Zanartha, and never again will the Uxan peaks hear " ..
					"the horn of Dasnar."
				)
			end
		end,

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
						self.surrendered = true

						ui.chat(
							"%s sees your superior army and surrenders" %
							self.name
						)
					end
				else
					self.surrender_period.value = 0
				end
			end

			if self.raid.period:move(dt):now() and 
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

					ui.chat("%s ride against barbarians in %s" % {
						self.name, target.name
					})
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
		garrison = 4,
		maximal_garrison = 17,
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
		garrison = 1,
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
	ai.jadians:own(p.annar, p.venedai, p.jadia, p.annar, p.reimin)
	ai.zanarthians:own(p.zanartha, p.uxan)

	p.fulthu.neighbours = {p.devarus, p.jadia}
	p.devarus.neighbours = {p.antaris, p.fulthu}
	p.antaris.neighbours = {p.higher_mikara, p.devarus}
	p.higher_mikara.neighbours = {p.lower_mikara, p.antaris}
	p.lower_mikara.neighbours = {p.higher_mikara, p.sod}
	p.sod.neighbours = {p.annar, p.dowur, p.lower_mikara}
	p.annar.neighbours = {p.sod, p.dowur, p.venedai, p.zanartha, p.uxan, p.reimin}
	p.dowur.neighbours = {p.sod, p.annar, p.uxan, p.reidan}
	p.venedai.neighbours = {p.annar, p.jadia, p.reimin}
	p.zanartha.neighbours = {p.annar, p.reimin, p.uxan}
	p.jadia.neighbours = {p.venedai, p.reimin, p.fulthu}
	p.reimin.neighbours = {p.jadia, p.venedai, p.annar, p.zanartha, p.uxan}
	p.uxan.neighbours = {p.reimin, p.zanartha, p.annar, p.dowur, p.reidan}
	p.reidan.neighbours = {p.uxan, p.dowur}

	local narrator = world:addEntity {
		name = "narrator",
		interpret = {
			game_starts = function()
				ui.chat(
					"Press player{[Shift + H]} to display help."
				)

				ui.chat(
					"You arrive to the mysterious planet of Zandara. You are a Rex " ..
					"Astra, one of the mythical Star Kings, that conquer galaxies just " ..
					"for fun. To get this planet, you have to defeat two powerful " ..
					"opponents."
				)

				ui.chat(
					"The first one is the Jadian nomads, the wild tribes of " ..
					"bloodthirsty savages that wander the reaches of Zandara. They " ..
					"do not care for better life or greater good and can be defeated " ..
					"only with a brutal force."
				)

				ui.chat(
					"The second one is the Guards of Zanartha, the legendary religious " ..
					"order, consisting of thousands of brave and honourable warriors. " ..
					"They are powerful and dangerous, but also reasonable."
				)
			end,
		}
	}

	return {
		ai = ai,
		provinces = p,
		narrator = narrator,
	}
end}
