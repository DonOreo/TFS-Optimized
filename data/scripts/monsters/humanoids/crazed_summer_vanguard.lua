local mType = Game.createMonsterType("Crazed Summer Vanguard")
local monster = {}

monster.description = "a Crazed Summer Vanguard"
monster.experience = 5000
monster.outfit = {
	lookType = 1137,
	lookHead = 114,
	lookBody = 93,
	lookLegs = 3,
	lookFeet = 83,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 30077
monster.speed = 390
monster.manaCost = 0

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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	ignoreSpawnBlock = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I see colours, all colours! Or are these just illusions?", yell = false},
	{text = "La di da di doo!!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 85000, maxCount = 13},
	{name = "elven astral observer", chance = 30000, maxCount = 2},
	{name = "dream essence egg", chance = 8600},
	{name = "belted cape", chance = 9500},
	{name = "two handed sword", chance = 7400},
	{name = "seeds", chance = 8600},
	{id = 3307, chance = 6800}, -- scimitar
	{name = "knife", chance = 6600},
	{name = "dragon necklace", chance = 7150},
	{name = "magma amulet", chance = 5500},
	{name = "wand of dragonbreath", chance = 4800},
	{name = "wand of draconia", chance = 4800},
	{name = "magma boots", chance = 2900},
	{name = "sun fruit", chance = 900},
	{name = "bullseye potion", chance = 300}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -160, maxDamage = -530},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -270, maxDamage = -710, length = 3, spread = 0, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -380, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 5, effect = CONST_ME_EXPLOSIONAREA, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 70
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 70}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -30},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
