local zandara = prototypes.planet(
	world, "Zandara", path("levels/first/sprites")
)
local planet = zandara:add_planet()


local p = {}

p.sod = zandara:add_province {
	name = "Coast of Sod",
	codename = "sod",
	anchor_position = vector {233, 35},
	fertility = .03,
	maximal_garrison = 8,
	contains_sea = true,
	fleet = 5,
	maximal_fleet = 15,
	fleet_p = vector {222, 39},
	owner = player,
}

p.annar = zandara:add_province {
	name = "Taiga of Annar",
	codename = "annar",
	anchor_position = vector {220, 66},
	fertility = .05,
	maximal_garrison = 17,
}

p.dowur = zandara:add_province {
	name = "Dowur lowlands",
	codename = "dowur",
	anchor_position = vector {248, 56},
	fertility = .12,
}

p.venedai = zandara:add_province {
	name = "Venedai reach",
	codename = "venedai",
	garrison = 2,
	anchor_position = vector {189, 77},
	fertility = .11,
}

p.zanartha = zandara:add_province {
	name = "Zanartha highland",
	codename = "zanartha",
	anchor_position = vector {236, 92},
	fertility = .06,
	maximal_garrison = 11,
	defense_k = 2.3,
}

p.jadia = zandara:add_province {
	name = "Jadia edge",
	codename = "jadia",
	fertility = .11,
	anchor_position = vector {170, 90},
	fleet = 0,
	maximal_fleet = 10,
	fleet_p = vector {160, 93},
}

p.reimin = zandara:add_province {
	name = "Reimin plains",
	codename = "reimin",
	fertility = .10,
	anchor_position = vector {220, 100},
}

p.uxan = zandara:add_province {
	name = "Uxan peaks",
	codename = "uxan",
	fertility = .02,
	anchor_position = vector {259, 98},
	maximal_garrison = 12,
	defense_k = 2.9,
}

p.reidan = zandara:add_province {
	name = "Reidan swamp",
	codename = "reidan",
	fertility = .15,
	anchor_position = vector {266, 66},
	garrison = 2,
}

p.lower_mikara = zandara:add_province {
	name = "Lower mikara",
	codename = "lower_mikara",
	fertility = .01,
	anchor_position = vector {186, 21},
}

p.higher_mikara = zandara:add_province {
	name = "Higher mikara",
	codename = "higher_mikara",
	fertility = .003,
	anchor_position = vector {171, 21},
}

p.antaris = zandara:add_province {
	name = "Antaris archipelago",
	codename = "antaris",
	fertility = .09,
	anchor_position = vector {85, 30},
	contains_sea = true,
}

p.devarus = zandara:add_province {
	name = "Devarus",
	codename = "devarus",
	fertility = .13,
	anchor_position = vector {75, 46},
}

p.fulthu = zandara:add_province {
	name = "Lost peninsula of Fulthu",
	codename = "fulthu",
	fertility = .14,
	anchor_position = vector {126, 73},
}

p.hexxa = zandara:add_province {
	name = "Hexxa rainforest",
	codename = "hexxa",
	fertility = .12,
	anchor_position = vector {160, 121},
}	

p.uskhal = zandara:add_province {
	name = "Uskhal jungles",
	codename = "uskhal",
	fertility = .16,
	anchor_position = vector {133, 123},
}


local w = {}

w.northern = zandara:add_waters {
	name = "Northern sea",
	codename = "northern",
	anchor_position = vector {209, 39},
	fleet_p = vector {209, 39},
}

w.mikara = zandara:add_waters {
	name = "Mikarian sea",
	codename = "mikara",
	anchor_position = vector {142, 30},
	fleet_p = vector {142, 30},
}

w.lower = zandara:add_waters {
	name = "Lower sea",
	codename = "lower",
	anchor_position = vector {159, 61},
	fleet_p = vector {159, 61},
}

w.higher = zandara:add_waters {
	name = "Higher sea",
	codename = "higher",
	anchor_position = vector {98, 44},
	fleet_p = vector {98, 44},
}

w.venedai = zandara:add_waters {
	name = "Venedai sea",
	codename = "venedai",
	anchor_position = vector {158, 62},
	fleet_p = vector {158, 62},
}

w.storms = zandara:add_waters {
	name = "Sea of storms",
	codename = "storms",
	anchor_position = vector {175, 47},
	fleet_p = vector {175, 47},
}

w.colds = zandara:add_waters {
	name = "Sea of colds",
	codename = "colds",
	anchor_position = vector {134, 45},
	fleet_p = vector {134, 45},
}

w.antaris = zandara:add_waters {
	name = "Antaris passage",
	codename = "antaris",
	anchor_position = vector {84, 38},
	fleet_p = vector {84, 38},
}	

w.fulthu = zandara:add_waters {
	name = "Fulthu passage",
	codename = "fulthu",
	anchor_position = vector {91, 61},
	fleet_p = vector {91, 61},
}

w.jadia = zandara:add_waters {
	name = "Jadian passage",
	codename = "jadia",
	anchor_position = vector {153, 79},
	fleet_p = vector {153, 79},
}

w.devil = zandara:add_waters {
	name = "Devil's passage",
	codename = "devil",
	anchor_position = vector {171, 111},
	fleet_p = vector {171, 111},
}

w.narrow = zandara:add_waters {
	name = "Narrow sea",
	codename = "narrow",
	anchor_position = vector {148, 102},
	fleet_p = vector {148, 102},
}

w.wide = zandara:add_waters {
	name = "Wide sea",
	codename = "wide",
	anchor_position = vector {103, 97},
	fleet_p = vector {103, 97},
}


p.sod:connect(p.annar, p.dowur, p.lower_mikara, w.northern)
p.annar:connect(
	p.dowur, p.uxan, p.zanartha, p.reimin, p.venedai, 
	w.northern, w.venedai
)
p.dowur:connect(p.reidan, p.uxan)
p.reidan:connect(p.uxan)
p.uxan:connect(p.zanartha, p.reimin)
p.zanartha:connect(p.reimin)
p.venedai:connect(p.reimin, p.jadia, w.venedai)
p.reimin:connect(p.jadia)
p.fulthu:connect(p.devarus, w.venedai)
p.devarus:connect(p.antaris)
p.antaris:connect(p.higher_mikara)
p.higher_mikara:connect(p.lower_mikara, w.northern)
p.lower_mikara:connect(w.northern)
w.northern:connect(w.storms, w.venedai)
w.storms:connect(w.colds, w.venedai)
w.colds:connect(w.venedai)

p.jadia:ferry(p.fulthu, w.jadia)


return {planet, p, w}