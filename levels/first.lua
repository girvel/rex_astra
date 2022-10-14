return {load = function(world)
	world:addEntity {
		name = "The Planet",
		sprite = kit.load_sprite("sprites/zandara/planet.png"),
		layer = standard.layers.planet,
	}

	kit.add_island("sprites/zandara", "sod", {
		garrison = 3,
		anchor_position = vector {233, 35},
	})

	kit.add_island("sprites/zandara", "annar", {
		garrison = 2,
		anchor_position = vector {220, 66},
	})

	kit.add_island("sprites/zandara", "dowur", {
		garrison = 2,
		anchor_position = vector {248, 56},
	})
end}
