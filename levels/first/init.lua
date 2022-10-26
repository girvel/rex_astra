return {load = function(world)
	local planet, p = unpack(require "levels.first.provinces")

	local ai = {
		jadians = world:addEntity(require "levels.first.ai.jadians"),
		zanarthians = world:addEntity(require "levels.first.ai.zanarthians"),
	}

	player:own(p.reidan)
	ai.jadians:own(p.annar, p.venedai, p.jadia, p.annar, p.reimin)
	ai.zanarthians:own(p.zanartha, p.uxan)

	local narrator = world:addEntity(prototypes.narrator("levels/first/narrator"))

	return {
		ai = ai,
		provinces = p,
		narrator = narrator,
		planet = planet,
	}
end}
