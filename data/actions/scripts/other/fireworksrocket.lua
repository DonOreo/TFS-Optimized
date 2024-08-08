function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if fromPosition.x ~= CONTAINER_POSITION then
		fromPosition:sendMagicEffect(math.random(CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_BLUE))
	else
		local position = player:getPosition()
		position:sendMagicEffect(CONST_ME_HITBYFIRE)
		position:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
		player:say("Ai! Em vez disso, coloque-o no ch�o da pr�xima vez.", TALKTYPE_MONSTER_SAY)
		player:addHealth(-10)
	end

	item:remove()
	return true
end
