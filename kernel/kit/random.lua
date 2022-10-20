local module = {}


-- definitions --
module.chance = function(chance)
	return math.random() < chance
end

module.choose = function(list)
	return list[math.ceil(math.random() * #list)]
end


return module