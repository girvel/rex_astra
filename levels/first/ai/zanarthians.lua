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
			end
		end
	end,
}