return {load = function(world)
	local planet, p, w = unpack(require "levels.first.provinces")

	local ai = {
		jadians = world:addEntity(require "levels.first.ai.jadians"),
		zanarthians = world:addEntity(require "levels.first.ai.zanarthians"),
	}

	p.reidan:put_garrison(2, player)

	p.annar:put_garrison(4, ai.jadians)
	p.venedai:put_garrison(2, ai.jadians)
	p.jadia:put_garrison(1, ai.jadians)
	p.reimin:put_garrison(1, ai.jadians)

	p.zanartha:put_garrison(8, ai.zanarthians)
	p.uxan:put_garrison(7, ai.zanarthians)

	local narrator = world:addEntity(require "levels.first.narrator")

	return {
		ai = ai,
		provinces = p,
		waters = w,
		narrator = narrator,
		planet = planet,
	}
end}
