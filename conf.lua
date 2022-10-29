love.conf = function(conf)
	conf.console = false

	for _, a in ipairs(arg) do
		if a:find("-%a*d") or a:find("-%a*h") or a:find("--help") then
			conf.console = true
			break
		end
	end
end