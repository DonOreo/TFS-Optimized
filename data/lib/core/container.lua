function getLootRandom()
	return math.random(0, MAX_LOOTCHANCE) / configManager.getNumber(configKeys.RATE_LOOT)
end

function getListOfContainerItems(container)
    if not container:isContainer() then
        return false
    end

    local containers, items = {}, {}
    table.insert(containers, container)
    while #containers > 0 do
        for i = 0, containers[1]:getSize() - 1 do  
            local item = containers[1]:getItem(i)
            table.insert(items, item)
            if item:isContainer() then
                table.insert(containers, item)
            end
        end
        table.remove(containers, 1)
    end

    return items
end

function Container.isContainer(self)
	return true
end

function Container.createLootItem(self, item)
	if self:getEmptySlots() == 0 then
		return true
	end

	local itemCount = 0
	local randvalue = getLootRandom()
	local itemType = ItemType(item.itemId)
	
	if randvalue < item.chance then
		if itemType:isStackable() then
			itemCount = randvalue % item.maxCount + 1
		else
			itemCount = 1
		end
	end

	while itemCount > 0 do
		local count = math.min(100, itemCount)
		
		local subType = count
		if itemType:isFluidContainer() then
			subType = math.max(0, item.subType)
		end
		
		local tmpItem = Game.createItem(item.itemId, subType)
		if not tmpItem then
			return false
		end

		if tmpItem:isContainer() then
			for i = 1, #item.childLoot do
				if not tmpItem:createLootItem(item.childLoot[i]) then
					tmpItem:remove()
					return false
				end
			end

			if #item.childLoot > 0 and tmpItem:getSize() == 0 then
				tmpItem:remove()
				return true
			end
		end

		if item.subType ~= -1 then
			tmpItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, item.subType)
		end

		if item.actionId ~= -1 then
			tmpItem:setActionId(item.actionId)
		end

		if item.text and item.text ~= "" then
			tmpItem:setText(item.text)
		end

		local ret = self:addItemEx(tmpItem)
		if ret ~= RETURNVALUE_NOERROR then
			tmpItem:remove()
		end

		itemCount = itemCount - count
	end
	return true
end