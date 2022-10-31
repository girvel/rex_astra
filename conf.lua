local fetch_console_from_flags = function()
	for _, a in ipairs(arg) do
		if a:find("-%a*d") or a:find("-%a*h") or a:find("--help") then
			return true
		end
	end
end

love.conf = function(conf)
	conf.window.title = "Rex Astra"
	conf.window.icon = "sprites/icon.png"
	conf.console = fetch_console_from_flags()
	conf.appendidentity = true
end
