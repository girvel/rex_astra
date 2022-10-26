return tiny.system {
	name = "systems.clock",
	ingame = true,
	system_type = "update",

	update = function(_, dt)
		clock.value = clock.value + dt * 
			clock.constants.seconds_in_minute * 
			clock.constants.minutes_in_hour * 
			clock.constants.hours_in_day
	end,
}