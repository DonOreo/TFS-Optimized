local event = Event()
event.onDropLoot = function(self, corpse)
    local mType = self:getType()
    if mType:isRewardBoss() then
        corpse:registerReward()
        return
    end

    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
        return
    end

    local player = Player(corpse:getCorpseOwner())
    if not player then
        return false
    end

	-- Raids Fonticak Token
    if self:getStorageValue(monsterRaidStorages.FONTICAK_TOKEN) == 1 then
        if math.random(100) <= 30 then
			local itemCount = math.random(1, 7)
			corpse:addItem(3043, itemCount)
      
			local position = corpse:getPosition()
			for i = 1, 10 do
            addEvent(function()
                position:sendMagicEffect(CONST_ME_LOOT_HIGHLIGHT)
				end, i * 1000)
			end

			local animatedText = position:getTile():getTopCreature()
			if animatedText then
				animatedText:say("Dropped!", TALKTYPE_MONSTER_SAY)
			end
		end
    end
	------

    if player:getStamina() > 840 then
        local monsterLoot = mType:getLoot()

        for i = 1, #monsterLoot do
            local chance = monsterLoot[i].chance
            chance = chance
            monsterLoot[i].chance = chance

            local item = corpse:createLootItem(monsterLoot[i])
            if not item then
                print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
            end
        end

        local text = ("Loot of %s: %s."):format(mType:getNameDescription(), corpse:getContentDescription())
        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            if player:getStorageValue(Storage.STORAGEVALUE_LOOT) == 1 then
                sendChannelMessage(4, TALKTYPE_CHANNEL_O, text)
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, text)
            end
        end
    else
        local text = ("Loot of %s: nothing (due to low stamina)."):format(mType:getNameDescription())
        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            if player:getStorageValue(Storage.STORAGEVALUE_LOOT) == 1 then
                sendChannelMessage(4, TALKTYPE_CHANNEL_O, text)
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, text)
            end
        end
    end
end

event:register()