return tiny.processingSystem {
	name = "systems.query",
	system_type = "update",
	filter = tiny.requireAll("name"),

	process = function() end,
}