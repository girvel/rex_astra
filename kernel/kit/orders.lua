local module = {}


-- definitions --
module.invest = function(entity, amount)
	amount = math.min(
		amount, 
		entity.maximal_garrison - entity.garrison, 
		entity.owner.gold
	)

	if amount == 0 then
		return false
	end

	entity.owner.gold = entity.owner.gold - amount
	entity.garrison = entity.garrison + amount
	return true
end

local force = function(province)
	return (province.garrison or 0) + (province.fleet or 0)
end

local filter_army = function(army, target)
	return fun.iter(army)
		:filter(function(a) 
			return force(a) > 0
				and fun.iter(a.neighbours):index(target) 
		end)
		:totable()
end

module.move_or_attack = function(...)
	return module.move(...) or module.attack(...)
end

module.attack = function(army, target)
	army = filter_army(army, target)

	local attacking_force = fun.iter(army):map(force):sum()

	if attacking_force <= 0 then
		return false
	end

	if target.garrison and 
		(not target.owner or force(target) <= 0)
	then
		information.register.take(army[1].owner, target)
		target:set_owner(army[1].owner)
		return true
	end

	information.register.attack(army, target)

	local success = kit.random.chance(
		attacking_force / (attacking_force + 1.5 * force(target) * target.defense_k)
	)

	if success then
		if target.garrison and target.garrison > 0 then
			target.garrison = target.garrison - 1
		else
			target.fleet = target.fleet - 1
		end
	else
		if army[1].garrison and army[1].garrison > 0 then
			army[1].garrison = army[1].garrison - 1
		else
			army[1].fleet = army[1].fleet - 1
		end
	end

	return success
end

module.move = function(army, target)
	army = filter_army(army, target)

	if #army == 0 then return false end

	local moving_subjects = {}

	local army_can_move = target.owner == army[1].owner and target.garrison
	local fleet_can_move = (not target.owner or target.owner == army[1].owner) 
		and target.fleet

	if army_can_move then table.insert(moving_subjects, "garrison") end
	if fleet_can_move then table.insert(moving_subjects, "fleet") end

	d(moving_subjects)

	if #moving_subjects == 0 then return false end

	target.owner = army[1].owner

	for _, subject in ipairs(moving_subjects) do
		for _, entity in ipairs(army) do
			if entity[subject] then
				local movement = math.min(
					math.floor(entity[subject] * 2 / 3 + .5), 
					target["maximal_" .. subject] - target[subject]
				)

				entity[subject] = entity[subject] - movement
				target[subject] = target[subject] + movement
			end
		end
	end

	return #moving_subjects > 0
end

module.invest_evenly = function(player)
	if player.gold <= 0 then return end

	local property_n = kit.table.size(player.property)
	local investment = math.floor(player.gold / property_n)
	local remainder_index = player.gold % property_n

	local i = 1
	for province, _ in pairs(player.property) do
		kit.orders.invest(
			province, 
			investment + (i <= remainder_index and 1 or 0)
		)
		
		i = i + 1
	end
end

module.surrender = function(player, target)
	for province, _ in pairs(kit.table.shallow_copy(player.property)) do
		province:set_owner(target)
	end

	target.gold = target.gold + player.gold
	player.gold = 0
	player.surrendered = true

	information.register.surrender(player, target)
end


return module