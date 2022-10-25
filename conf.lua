love.conf = function(conf)
	conf.console = false

	for _, a in ipairs(arg) do
		if a:find("-%S*d") ~= nil then
			conf.console = true
			break
		end
	end
end