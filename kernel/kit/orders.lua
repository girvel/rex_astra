local module = {}


-- definitions --
module.invest = function(entity, amount)
	if  entity.garrison < entity.maximal_garrison and
		entity.owner.gold >= amount
	then
		entity.owner.gold = entity.owner.gold - amount
		entity.garrison = entity.garrison + amount
		return true
	end

	return false
end

module.attack = function(army, target)
	army = fun.iter(army)
		:filter(function(a) 
			return a.garrison > 0 and fun.iter(target.neighbours):index(a) 
		end)
		:totable()

	local attacking_force = fun.iter(army)
		:reduce(function(acc, a) return acc + a.garrison end, 0)

	if attacking_force <= 0 then
		return false
	end

	if not target.owner then
		ui.chat:message(
			"#1{%s} colonizes %s" % {army[1].owner.name, target.name}, 
			army[1].owner.color
		)

		target:set_owner(army[1].owner)
		return true
	end

	if target.owner == army[1].owner then
		for _, entity in ipairs(army) do
			local movement = math.min(
				math.floor(entity.garrison * 2 / 3 + .5), 
				target.maximal_garrison - target.garrison
			)

			entity.garrison = entity.garrison - movement
			target.garrison = target.garrison + movement
		end
		return true
	end

	log.trace(
		"%s attack %s, %s" % 
		{army[1].owner.name, target.name, target.owner.name}
	)

	local success = kit.random.chance(
		attacking_force / (attacking_force + 1.5 * target.garrison)
	)

	if success then
		target.garrison = target.garrison - 1

		if target.garrison < 0 then
			target:set_owner(army[1].owner)
			target.garrison = 0

			ui.chat:message(
				"#1{%s} takes %s" % {army[1].owner.name, target.name}, 
				army[1].owner.color
			)
		end
	else
		army[1].garrison = army[1].garrison - 1
	end

	return success
end


return module