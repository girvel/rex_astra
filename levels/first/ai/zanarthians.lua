return prototypes.player {
	name = "Guardians of Zanartha",
	codename = "zanarthians", 
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
}