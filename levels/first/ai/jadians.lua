return prototypes.player {
	name = "Jadian nomads",
	codename = "jadians",
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
}