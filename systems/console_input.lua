return tiny.system {
	name = "systems.console_input",
	system_type = "textinput",

	update = function(self, text)
		if not launch.debug or not ui.console.active then return end

		-- TODO kit
		local escape_pattern = function(text)
		    return text:gsub("([^%w])", "%%%1")
		end

		-- for key, _ in pairs(devices.keyboard.mutex.pressed) do
		-- 	if #key == 1 then
		-- 		text = text:gsub(escape_pattern(key), "")
		-- 	end
		-- end

		ui.console.command = ui.console.command .. text

		text = text:capitalize():swapcase()
		for i in fun.range(#text) do
			devices.keyboard.mutex.pressed[text(i)] = true
		end
	end,
}