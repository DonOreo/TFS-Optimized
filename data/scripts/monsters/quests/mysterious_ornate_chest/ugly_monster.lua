local mType = Game.createMonsterType("Ugly Monster")
local monster = {}

monster.description = "an ugly monster"
monster.experience = 650
monster.outfit = {
	lookType = 1218,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 13000
monster.maxHealth = 13000
monster.race = "blood"
monster.corpse = 31551
monster.speed = 140
monster.manaCost = 0

monster.events = {
	"UglyMonsterDeath",
	"UglyMonsterDrop"
}

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	ignoreSpawnBlock = false,
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
}

monster.loot = {
	{name = "cobra crossbow", chance = 670},
	{name = "cobra hood", chance = 670},
	{name = "cobra axe", chance = 670},
	{name = "cobra boots", chance = 670},
	{name = "cobra sword", chance = 670},
	{name = "cobra wand", chance = 670},
	{name = "cobra rod", chance = 670},
	{name = "cobra club", chance = 670}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="outfit", interval = 2000, chance = 10, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 10000, monster = "Ugly Monster"},
	{name ="drunk", interval = 2000, chance = 10, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 5000}
}

monster.defenses = {
	defense = 48,
	armor = 48,
	{name ="invisible", interval = 2000, chance = 8, effect = CONST_ME_HITAREA}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
