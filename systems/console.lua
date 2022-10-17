return tiny.system {
	name = "systems.console",
	system_type = "keypressed",

	update = function(self, event)
		if not launch.debug then return end

		local key = unpack(event)

		if key == "`" then
			ui.console.active = not ui.console.active
			return
		end

		if not ui.console.active then return end

		if key == "return" then
			local success, message = pcall(load("return " .. ui.console.command))
			log.info(">", ui.console.command, ">>", message)

			if not success then
				log.debug("console error:", message)
			end

			ui.console.command = ""
		elseif key == "backspace" then
			if #ui.console.command > 0 then
				ui.console.command = ui.console.command:sub(1, -2)
			end
		elseif key == "space" then 
			ui.console.command = ui.console.command .. " "
		elseif #key == 1 then
			ui.console.command = ui.console.command .. tostring(key)
		end
	end,
}