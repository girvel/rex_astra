return {load = function(world)
	world:addEntity {
		name = "The Planet",
		sprite = kit.load_sprite("sprites/planet.png"),
		layer = standard.layers.planet,
	}

	world:addEntity {
		name = "Island of Sod",
		sprite = kit.load_sprite("sprites/islands/sod.png"),
		layer = standard.layers.island,
		garrison = 3,
		anchor_position = vector {233, 35},
		highlight = world:addEntity {
			name = "[Island of Sod] Highlight",
			sprite = kit.load_sprite("sprites/highlights/sod.png"),
			layer = standard.layers.highlight
		}
	}
end}
