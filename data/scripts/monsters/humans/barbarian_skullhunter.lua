local mType = Game.createMonsterType("Barbarian Skullhunter")
local monster = {}

monster.description = "a barbarian skullhunter"
monster.experience = 85
monster.outfit = {
	lookType = 254,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 96,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 135
monster.maxHealth = 135
monster.race = "blood"
monster.corpse = 18066
monster.speed = 168
monster.manaCost = 450

monster.changeTarget = {
	interval = 60000,
	chance = 0
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
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
	{text = "You will become my trophy.", yell = false},
	{text = "Fight harder, coward.", yell = false},
	{text = "Show that you are a worthy opponent.", yell = false}
}

monster.loot = {
	{id = 2920, chance = 6680}, -- torch
	{name = "gold coin", chance = 8240, maxCount = 30},
	{id = 3052, chance = 300}, -- life ring
	{id = 3114, chance = 3000}, -- skull
	{name = "knife", chance = 1067},
	{name = "brass helmet", chance = 2200},
	{name = "viking helmet", chance = 860},
	{name = "scale armor", chance = 440},
	{name = "brown piece of cloth", chance = 500},
	{name = "crystal sword", chance = 100},
	{name = "fur boots", chance = 100},
	{name = "ragnir helmet", chance = 100},
	{name = "health potion", chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60}
}

monster.defenses = {
	defense = 0,
	armor = 8
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
