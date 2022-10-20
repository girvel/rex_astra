return tiny.sortedProcessingSystem {
	name = "systems.highlighting",
	system_type = "update",
	filter = tiny.requireAll("hitbox"),

	compare = function(_, e1, e2) return e1.layer > e2.layer end,

	process = function(_, entity)
		local is_over = not devices.mouse.mutex.over and 
			devices.mouse.is_over(entity)

		if entity.highlight then
			entity.highlight.opacity = is_over and .7 or 0
		end

		if is_over then
			devices.mouse.mutex.over = true
		end
	end,

	postProcess = function()
		for entity, _ in pairs(ui.sources) do
			entity.highlight.opacity = 1
		end
	end,
}