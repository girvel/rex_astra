return {load = function(world)
	local ai1 = world:addEntity {
		name = "AI_1",
		color = standard.palette.ai1,
		gold = 0,
	}

	world:addEntity {
		name = "The Planet",
		sprite = kit.load_sprite("sprites/zandara/planet.png"),
		layer = standard.layers.planet,
	}

	local sod = kit.add_province("sprites/zandara", "sod", {
		name = "Coast of Sod",
		garrison = 3,
		anchor_position = vector {233, 35},
		fertility = .03,
		owner = player,
		maximal_garrison = 8,
	})

	local annar = kit.add_province("sprites/zandara", "annar", {
		name = "Taiga of Annar",
		garrison = 2,
		anchor_position = vector {220, 66},
		fertility = .05,
		owner = ai1,
	})

	local dowur = kit.add_province("sprites/zandara", "dowur", {
		name = "Dowur lowlands",
		garrison = 2,
		anchor_position = vector {248, 56},
		fertility = .12,
		owner = player,
	})

	sod.neighbours = {annar, dowur}
	annar.neighbours = {sod, dowur}
	dowur.neighbours = {sod, annar}
end}
