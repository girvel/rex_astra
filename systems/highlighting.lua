return tiny.processingSystem {
	name = "systems.highlighting",
	system_type = "update",
	filter = tiny.requireAll("hitbox", "highlight"),

	process = function(_, entity)
		entity.highlight.visible = kit.is_mouse_over(entity)
	end,
}