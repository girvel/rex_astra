return {load = function(world)
	local planet, p, w = unpack(require "levels.first.provinces")

	local ai = {
		jadians = world:addEntity(require "levels.first.ai.jadians"),
		zanarthians = world:addEntity(require "levels.first.ai.zanarthians"),
	}

	player:own(p.reidan)
	ai.jadians:own(p.annar, p.venedai, p.jadia, p.annar, p.reimin)
	ai.zanarthians:own(p.zanartha, p.uxan)

	local narrator = world:addEntity(require "levels.first.narrator")

	return {
		ai = ai,
		provinces = p,
		waters = w,
		narrator = narrator,
		planet = planet,
	}
end}
