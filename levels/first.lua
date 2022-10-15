return {load = function(world)
	local ai1 = world:addEntity {
		name = "AI_1",
		color = standard.palette.ai1,
		gold = 0,
	}

	local zandara = kit.planet(world, "Zandara", "sprites/zandara")

	zandara:add_planet()

	local sod = zandara:add_province {
		name = "Coast of Sod",
		garrison = 3,
		anchor_position = vector {233, 35},
		fertility = .03,
		owner = player,
		maximal_garrison = 8,
	}

	local annar = zandara:add_province {
		name = "Taiga of Annar",
		garrison = 2,
		anchor_position = vector {220, 66},
		fertility = .05,
		owner = ai1,
	}

	local dowur = zandara:add_province {
		name = "Dowur lowlands",
		garrison = 2,
		anchor_position = vector {248, 56},
		fertility = .12,
		owner = player,
	}

	local venedai = zandara:add_province {
		name = "Venedai reach",
		garrison = 2,
		anchor_position = vector {189, 77},
		fertility = .11,
		owner = ai1,
	}

	local zanartha = zandara:add_province {
		name = "Zanartha highland",
		garrison = 2,
		anchor_position = vector {236, 92},
		fertility = .06,
		owner = ai1,
	}

	local jadia = zandara:add_province {
		name = "Jadia edge",
		fertility = .07,
		anchor_position = vector {170, 90},
	}

	local reimin = zandara:add_province {
		name = "Reimin plains",
		fertility = .10,
		anchor_position = vector {220, 100},
	}

	local uxan = zandara:add_province {
		name = "Uxan peaks",
		fertility = .02,
		anchor_position = vector {259, 98},
	}

	local reidan = zandara:add_province {
		name = "Reidan",
		fertility = .15,
		anchor_position = vector {266, 66},
	}

	local lower_mikara = zandara:add_province {
		name = "Lower mikara",
		fertility = .01,
		anchor_position = vector {186, 21},
	}

	local higher_mikara = zandara:add_province {
		name = "Higher mikara",
		fertility = .003,
		anchor_position = vector {171, 21},
	}

	higher_mikara.neighbours = {lower_mikara}
	lower_mikara.neighbours = {higher_mikara, sod}
	sod.neighbours = {annar, dowur, lower_mikara}
	annar.neighbours = {sod, dowur, venedai, zanartha, uxan}
	dowur.neighbours = {sod, annar, uxan, reidan}
	venedai.neighbours = {annar, jadia, reimin}
	zanartha.neighbours = {annar, reimin, uxan}
	jadia.neighbours = {venedai, reimin}
	reimin.neighbours = {jadia, venedai, annar, zanartha, uxan}
	uxan.neighbours = {reimin, zanartha, annar, dowur, reidan}
	reidan.neighbours = {uxan, dowur}
end}
