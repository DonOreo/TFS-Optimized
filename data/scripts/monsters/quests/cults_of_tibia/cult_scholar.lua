local mType = Game.createMonsterType("Cult Scholar")
local monster = {}

monster.description = "a cult scholar"
monster.experience = 1100
monster.outfit = {
	lookType = 145,
	lookHead = 19,
	lookBody = 77,
	lookLegs = 3,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 1650
monster.maxHealth = 1650
monster.race = "blood"
monster.corpse = 22017
monster.speed = 260
monster.manaCost = 390

monster.changeTarget = {
	interval = 4000,
	chance = 20
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	ignoreSpawnBlock = true,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The Secrets are ours alone!", yell = false}
}

monster.loot = {
	{id = 3446, chance = 90450, maxCount = 10}, -- bolt
	{id = 3031, chance = 75410, maxCount = 30}, -- gold coin
	{id = 3592, chance = 15400}, -- grapes
	{id = 239, chance = 12340, maxCount = 2}, -- great health potion
	{id = 3577, chance = 5000}, -- meat
	{id = 3349, chance = 830}, -- crossbow
	{id = 3563, chance = 760}, -- green tunic
	{id = 3048, chance = 700, maxCount = 2}, -- might ring
	{id = 3003, chance = 1000}, -- rope
	{id = 3572, chance = 1000}, -- scarf
	{id = 2815, chance = 830}, -- scroll
	{id = 3028, chance = 830}, -- small diamond
	{id = 3279, chance = 130}, -- war hammer
	{id = 3269, chance = 830}, -- halberd
	{id = 3415, chance = 330}, -- guardian shield
	{id = 3371, chance = 230}, -- knight legs
	{id = 3369, chance = 200} -- warrior helmet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -580}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 20, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
