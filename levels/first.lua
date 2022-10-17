return {load = function(world)
	local r = {}

	r.ai1 = world:addEntity {
		name = "AI_1",
		color = standard.palette.ai1,
		gold = 0,
	}

	local zandara = kit.planet(world, "Zandara", "sprites/zandara")

	zandara:add_planet()

	r.sod = zandara:add_province {
		name = "Coast of Sod",
		garrison = 3,
		anchor_position = vector {233, 35},
		fertility = .03,
		owner = player,
		maximal_garrison = 8,
	}

	r.annar = zandara:add_province {
		name = "Taiga of Annar",
		garrison = 2,
		anchor_position = vector {220, 66},
		fertility = .05,
		owner = r.ai1,
	}

	r.dowur = zandara:add_province {
		name = "Dowur lowlands",
		garrison = 2,
		anchor_position = vector {248, 56},
		fertility = .12,
		owner = player,
	}

	r.venedai = zandara:add_province {
		name = "Venedai reach",
		garrison = 2,
		anchor_position = vector {189, 77},
		fertility = .11,
		owner = r.ai1,
	}

	r.zanartha = zandara:add_province {
		name = "Zanartha highland",
		garrison = 2,
		anchor_position = vector {236, 92},
		fertility = .06,
		owner = r.ai1,
	}

	r.jadia = zandara:add_province {
		name = "Jadia edge",
		fertility = .07,
		anchor_position = vector {170, 90},
	}

	r.reimin = zandara:add_province {
		name = "Reimin plains",
		fertility = .10,
		anchor_position = vector {220, 100},
	}

	r.uxan = zandara:add_province {
		name = "Uxan peaks",
		fertility = .02,
		anchor_position = vector {259, 98},
	}

	r.reidan = zandara:add_province {
		name = "Reidan",
		fertility = .15,
		anchor_position = vector {266, 66},
	}

	r.lower_mikara = zandara:add_province {
		name = "Lower mikara",
		fertility = .01,
		anchor_position = vector {186, 21},
	}

	r.higher_mikara = zandara:add_province {
		name = "Higher mikara",
		fertility = .003,
		anchor_position = vector {171, 21},
	}

	r.antaris = zandara:add_province {
		name = "Antaris archipelago",
		fertility = .09,
		anchor_position = vector {85, 30},
	}

	r.devarus = zandara:add_province {
		name = "Devarus",
		fertility = .13,
		anchor_position = vector {75, 46},
	}

	r.fulthu = zandara:add_province {
		name = "Lost peninsula of Fulthu",
		fertility = .14,
		anchor_position = vector {126, 73},
	}

	r.fulthu.neighbours = {r.devarus, r.jadia}
	r.devarus.neighbours = {r.antaris, r.fulthu}
	r.antaris.neighbours = {r.higher_mikara, r.devarus}
	r.higher_mikara.neighbours = {r.lower_mikara, r.antaris}
	r.lower_mikara.neighbours = {r.higher_mikara, r.sod}
	r.sod.neighbours = {r.annar, r.dowur, r.lower_mikara}
	r.annar.neighbours = {r.sod, r.dowur, r.venedai, r.zanartha, r.uxan}
	r.dowur.neighbours = {r.sod, r.annar, r.uxan, r.reidan}
	r.venedai.neighbours = {r.annar, r.jadia, r.reimin}
	r.zanartha.neighbours = {r.annar, r.reimin, r.uxan}
	r.jadia.neighbours = {r.venedai, r.reimin}
	r.reimin.neighbours = {r.jadia, r.venedai, r.annar, r.zanartha, r.uxan}
	r.uxan.neighbours = {r.reimin, r.zanartha, r.annar, r.dowur, r.reidan}
	r.reidan.neighbours = {r.uxan, r.dowur}
end}
