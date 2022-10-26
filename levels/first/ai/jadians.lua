return prototypes.player {
	name = "Jadian nomads",
	codename = "jadians",
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
}