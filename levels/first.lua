return {load = function(world)
	local ai1 = world:addEntity {
		name = "AI_1",
		color = standard.palette.ai1,
		gold = 0,
	}

	local zandara = kit.planet(world, "Zandara", "sprites/zandara")

	zandara:add_planet()

	local sod = zandara:add_province("sod", {
		name = "Coast of Sod",
		garrison = 3,
		anchor_position = vector {233, 35},
		fertility = .03,
		owner = player,
		maximal_garrison = 8,
	})

	local annar = zandara:add_province("annar", {
		name = "Taiga of Annar",
		garrison = 2,
		anchor_position = vector {220, 66},
		fertility = .05,
		owner = ai1,
	})

	local dowur = zandara:add_province("dowur", {
		name = "Dowur lowlands",
		garrison = 2,
		anchor_position = vector {248, 56},
		fertility = .12,
		owner = player,
	})

	local venedai = zandara:add_province("venedai", {
		name = "Venedai reach",
		garrison = 2,
		anchor_position = vector {189, 77},
		fertility = .11,
		owner = ai1,
	})

	local zanartha = zandara:add_province("zanartha", {
		name = "Zanartha highland",
		garrison = 2,
		anchor_position = vector {236, 92},
		fertility = .06,
		owner = ai1,
	})

	sod.neighbours = {annar, dowur}
	annar.neighbours = {sod, dowur, venedai, zanartha}
	dowur.neighbours = {sod, annar}
	venedai.neighbours = {annar}
	zanartha.neighbours = {annar}
end}
