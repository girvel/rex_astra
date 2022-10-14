return {load = function(world)
	local ai1 = world:addEntity {
		gold = 0,
	}

	world:addEntity {
		name = "The Planet",
		sprite = kit.load_sprite("sprites/zandara/planet.png"),
		layer = standard.layers.planet,
	}

	kit.add_province("sprites/zandara", "sod", {
		garrison = 3,
		anchor_position = vector {233, 35},
		fertility = .03,
		owner = player,
		maximal_garrison = 8,
	})

	kit.add_province("sprites/zandara", "annar", {
		garrison = 2,
		anchor_position = vector {220, 66},
		fertility = .05,
		owner = ai1,
	})

	kit.add_province("sprites/zandara", "dowur", {
		garrison = 2,
		anchor_position = vector {248, 56},
		fertility = .12,
		owner = player,
	})
end}
