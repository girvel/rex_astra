return tiny.processingSystem {
	name = "systems.highlighting",
	system_type = "update",
	filter = tiny.requireAll("hitbox", "highlight"),

	process = function(_, entity)
		entity.highlight.opacity = kit.is_mouse_over(entity) and .7 or 0
	end,

	postProcess = function()
		for entity, _ in pairs(ui.sources) do
			entity.highlight.opacity = 1
		end
	end,
}