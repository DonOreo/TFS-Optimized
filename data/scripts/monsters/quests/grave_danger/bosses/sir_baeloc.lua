local mType = Game.createMonsterType("Sir Baeloc")
local monster = {}

monster.description = "a Sir Baeloc"
monster.experience = 55000
monster.outfit = {
	lookType = 1222,
	lookHead = 57,
	lookBody = 81,
	lookLegs = 3,
	lookFeet = 93,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 250
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	ignoreSpawnBlock = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 3,
	summons = {
		{name = "Retainer of Baeloc", chance = 20, interval = 2000, count = 3}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", maxCount = 5, chance = 100000},
	{name = "crystal coin", maxCount = 2, chance = 50000},
	{name = "supreme health potion", maxCount = 6, chance = 35000},
	{name = "ultimate mana potion", maxCount = 20, chance = 32000},
	{name = "ultimate spirit potion", maxCount = 20, chance = 32000},
	{name = "mastermind potion", maxCount = 10, chance = 12000},
	{name = "berserk potion", maxCount = 10, chance = 12000},
	{name = "piece of draconian steel", maxCount = 4, chance = 9000},
	{id = 3039, chance = 12000, maxCount = 2}, -- red gem
	{name = "silver token", chance = 9500, maxCount = 2},
	{id = 23542, chance = 5200}, -- collar of blue plasma
	{id = 23544, chance = 5200}, -- collar of red plasma
	{name = "knight legs", chance = 11000},
	{name = "gold ingot", maxCount = 1, chance = 10000},
	{name = "violet gem", maxCount = 1, chance = 10000},
	{name = "yellow gem", maxCount = 1, chance = 10000},
	{id = 23529, chance = 5000}, -- ring of blue plasma
	{id = 23533, chance = 5000}, -- ring of red plasma
	{name = "skull staff", chance = 9000},
	{name = "young lich worm", chance = 5800},
	{name = "embrace of nature", chance = 1400},
	{id = 31592, chance = 1800}, -- signet ring
	{name = "terra helmet", chance = 750},
	{name = "final judgement", chance = 450},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -500, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 1800, chance = 40, type = COMBAT_MANADRAIN, minDamage = -300, maxDamage = -500, radius = 5, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 1800, chance = 89, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1200, length = 7, spread = 3, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
