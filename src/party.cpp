/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "party.h"
#include "game.h"
#include "configmanager.h"
#include "events.h"

extern Game g_game;
extern ConfigManager g_config;
extern Events* g_events;

Party::Party(Player* leader) : leader(leader)
{
	leader->setParty(this);
}

void Party::disband()
{
	if (!g_events->eventPartyOnDisband(this)) {
		return;
	}

	Player* currentLeader = leader;
	leader = nullptr;

	currentLeader->setParty(nullptr);
	currentLeader->sendClosePrivate(CHANNEL_PARTY);
	g_game.updatePlayerShield(currentLeader);
	currentLeader->sendCreatureSkull(currentLeader);
	currentLeader->sendTextMessage(MESSAGE_INFO_DESCR, "Seu grupo foi desfeito.");

	for (Player* invitee : inviteList) {
		invitee->removePartyInvitation(this);
		currentLeader->sendCreatureShield(invitee);
	}
	inviteList.clear();

	for (Player* member : memberList) {
		member->setParty(nullptr);
		member->sendClosePrivate(CHANNEL_PARTY);
		member->sendTextMessage(MESSAGE_INFO_DESCR, "Seu grupo foi desfeito.");
	}

	for (Player* member : memberList) {
		g_game.updatePlayerShield(member);

		for (Player* otherMember : memberList) {
			otherMember->sendCreatureSkull(member);
		}

		member->sendCreatureSkull(currentLeader);
		currentLeader->sendCreatureSkull(member);
	}
	memberList.clear();
	delete this;
}

bool Party::leaveParty(Player* player)
{
	if (!player) {
		return false;
	}

	if (player->getParty() != this && leader != player) {
		return false;
	}

	if (!g_events->eventPartyOnLeave(this, player)) {
		return false;
	}

	bool missingLeader = false;
	if (leader == player) {
		if (!memberList.empty()) {
			if (memberList.size() == 1 && inviteList.empty()) {
				missingLeader = true;
			} else {
				passPartyLeadership(memberList.front(), true);
			}
		} else {
			missingLeader = true;
		}
	}

	//since we already passed the leadership, we remove the player from the list
	auto it = std::find(memberList.begin(), memberList.end(), player);
	if (it != memberList.end()) {
		memberList.erase(it);
	}

	player->setParty(nullptr);
	player->sendClosePrivate(CHANNEL_PARTY);
	g_game.updatePlayerShield(player);

	for (Player* member : memberList) {
		member->sendCreatureSkull(player);
		player->sendPlayerPartyIcons(member);
	}

	leader->sendCreatureSkull(player);
	player->sendCreatureSkull(player);
	player->sendPlayerPartyIcons(leader);

	// remove pending invitation icons from the screen
	for (Player* invitee : inviteList) {
		player->sendCreatureShield(invitee);
	}

	player->sendTextMessage(MESSAGE_INFO_DESCR, "Voc� saiu do grupo.");

	updateSharedExperience();

	clearPlayerPoints(player);

	std::ostringstream ss;
	ss << player->getName() << " saiu do grupo.";
	broadcastPartyMessage(MESSAGE_INFO_DESCR, ss.str());

	if (missingLeader || empty()) {
		disband();
	}

	return true;
}

bool Party::passPartyLeadership(Player* player, bool forceRemove /* = false*/)
{
	if (!player || leader == player || player->getParty() != this) {
		return false;
	}
	
	if (!g_events->eventPartyOnPassLeadership(this, player) && !forceRemove) {
		return false;
	}

	//Remove it before to broadcast the message correctly
	auto it = std::find(memberList.begin(), memberList.end(), player);
	if (it != memberList.end()) {
		memberList.erase(it);
	}

	std::ostringstream ss;
	ss << player->getName() << " � o lider do grupo agora.";
	broadcastPartyMessage(MESSAGE_INFO_DESCR, ss.str(), true);

	Player* oldLeader = leader;
	leader = player;

	memberList.insert(memberList.begin(), oldLeader);

	updateSharedExperience();

	for (Player* member : memberList) {
		member->sendCreatureShield(oldLeader);
		member->sendCreatureShield(leader);
	}

	for (Player* invitee : inviteList) {
		invitee->sendCreatureShield(oldLeader);
		invitee->sendCreatureShield(leader);
	}

	leader->sendCreatureShield(oldLeader);
	leader->sendCreatureShield(leader);

	player->sendTextMessage(MESSAGE_INFO_DESCR, "Voc� agora � o l�der do grupo.");
	return true;
}

bool Party::joinParty(Player& player)
{
	if (!g_events->eventPartyOnJoin(this, &player)) {
		return false;
	}

	// first player accepted the invitation
	// the party gets officially formed
	// the leader can no longer take invitations from others
	if (memberList.empty()) {
		leader->clearPartyInvitations();
	}

	// add player to the party
	memberList.push_back(&player);
	player.setParty(this);

	std::ostringstream ss;
	ss << player.getName() << " entrou no grupo.";
	broadcastPartyMessage(MESSAGE_INFO_DESCR, ss.str());

	// remove player pending invitations to this and other parties
	player.clearPartyInvitations();

	// update player icon on the screen
	g_game.updatePlayerShield(&player);

	// update player-member party icons
	for (Player* member : memberList) {
		member->sendCreatureSkull(&player);
		player.sendPlayerPartyIcons(member);
	}

	player.sendCreatureSkull(&player);
	leader->sendCreatureSkull(&player);
	player.sendPlayerPartyIcons(leader);
	
	// update player own skull
	player.sendCreatureSkull(&player);

	// show the new member who else is invited
	for (Player* invitee : inviteList) {
		player.sendCreatureShield(invitee);
	}

	// check the party eligibility for shared experience
	updateSharedExperience();

	const std::string& leaderName = leader->getName();
	ss.str(std::string());
	ss << "Voc� entrou no grupo de " << leaderName << ". Abra o canal do grupo para se comunicar com seus companheiros.";
	player.sendTextMessage(MESSAGE_INFO_DESCR, ss.str());
	return true;
}

bool Party::removeInvite(Player& player, bool removeFromPlayer/* = true*/)
{
	auto it = std::find(inviteList.begin(), inviteList.end(), &player);
	if (it == inviteList.end()) {
		return false;
	}

	inviteList.erase(it);

	leader->sendCreatureShield(&player);
	player.sendCreatureShield(leader);

	if (removeFromPlayer) {
		player.removePartyInvitation(this);
	}

	if (empty()) {
		disband();
	}

	return true;
}

void Party::revokeInvitation(Player& player)
{
	if (!g_events->eventPartyOnRevokeInvitation(this, &player)) {
		return;
	}
	
	std::ostringstream ss;
	ss << leader->getName() << " revogou " << (leader->getSex() == PLAYERSEX_FEMALE ? "sua" : "seu") << " convite.";
	player.sendTextMessage(MESSAGE_INFO_DESCR, ss.str());

	ss.str(std::string());
	ss << "Convite para " << player.getName() << " foi revogado.";
	leader->sendTextMessage(MESSAGE_INFO_DESCR, ss.str());

	removeInvite(player);
}

bool Party::invitePlayer(Player& player)
{
	if (isPlayerInvited(&player)) {
		return false;
	}

	std::ostringstream ss;
	ss << player.getName() << " foi convidado.";

	if (empty()) {
		ss << " Abra o canal do grupo para se comunicar com seus membros.";
		g_game.updatePlayerShield(leader);
		leader->sendCreatureSkull(leader);
	}

	leader->sendTextMessage(MESSAGE_INFO_DESCR, ss.str());

	inviteList.push_back(&player);
	player.addPartyInvitation(this);

	leader->sendCreatureShield(&player);
	player.sendCreatureShield(leader);

	// update the invitation status for other members
	for (Player* member : memberList) {
		member->sendCreatureShield(&player);
	}

	ss.str(std::string());
	ss << leader->getName() << " convidou voc� para seu grupo.";
	player.sendTextMessage(MESSAGE_INFO_DESCR, ss.str());
	return true;
}

bool Party::isPlayerInvited(const Player* player) const
{
	return std::find(inviteList.begin(), inviteList.end(), player) != inviteList.end();
}

void Party::updateAllPartyIcons()
{
	for (Player* member : memberList) {
		for (Player* otherMember : memberList) {
			member->sendCreatureShield(otherMember);
		}

		member->sendCreatureShield(leader);
		leader->sendCreatureShield(member);
	}
	leader->sendCreatureShield(leader);
}

void Party::broadcastPartyMessage(MessageClasses msgClass, const std::string& msg, bool sendToInvitations /*= false*/)
{
	for (Player* member : memberList) {
		member->sendTextMessage(msgClass, msg);
	}

	leader->sendTextMessage(msgClass, msg);

	if (sendToInvitations) {
		for (Player* invitee : inviteList) {
			invitee->sendTextMessage(msgClass, msg);
		}
	}
}

void Party::updateSharedExperience()
{
	if (sharedExpActive) {
		bool result = canEnableSharedExperience();
		if (result != sharedExpEnabled) {
			sharedExpEnabled = result;
			updateAllPartyIcons();
		}
	}
}

bool Party::setSharedExperience(Player* player, bool sharedExpActive)
{
	if (!player || leader != player) {
		return false;
	}

	if (this->sharedExpActive == sharedExpActive) {
		return true;
	}

	this->sharedExpActive = sharedExpActive;

	if (sharedExpActive) {
		this->sharedExpEnabled = canEnableSharedExperience();

		if (this->sharedExpEnabled) {
			leader->sendTextMessage(MESSAGE_INFO_DESCR, "A experi�ncia compartilhada agora est� ativa.");
		} else {
			leader->sendTextMessage(MESSAGE_INFO_DESCR, "A experi�ncia compartilhada foi ativada, mas alguns membros da sua parte est�o inativos.");
		}
	} else {
		leader->sendTextMessage(MESSAGE_INFO_DESCR, "A experi�ncia compartilhada foi desativada.");
	}

	updateAllPartyIcons();
	return true;
}

void Party::shareExperience(uint64_t experience, Creature* source/* = nullptr*/)
{
	uint64_t shareExperience = experience;
	g_events->eventPartyOnShareExperience(this, shareExperience);

	for (Player* member : memberList) {
		member->onGainSharedExperience(shareExperience, source);
	}
	leader->onGainSharedExperience(shareExperience, source);
}

bool Party::canUseSharedExperience(const Player* player) const
{
	if (memberList.empty()) {
		return false;
	}

	uint32_t highestLevel = leader->getLevel();
	for (Player* member : memberList) {
		if (member->getLevel() > highestLevel) {
			highestLevel = member->getLevel();
		}
	}

	uint32_t minLevel = static_cast<uint32_t>(std::ceil((static_cast<float>(highestLevel) * 2) / 3));
	if (player->getLevel() < minLevel) {
		return false;
	}

	if (!Position::areInRange<30, 30, 1>(leader->getPosition(), player->getPosition())) {
		return false;
	}

	if (!player->hasFlag(PlayerFlag_NotGainInFight)) {
		//check if the player has healed/attacked anything recently
		auto it = ticksMap.find(player->getID());
		if (it == ticksMap.end()) {
			return false;
		}

		uint64_t timeDiff = OTSYS_TIME() - it->second;
		if (timeDiff > static_cast<uint64_t>(g_config.getNumber(ConfigManager::PZ_LOCKED))) {
			return false;
		}
	}
	return true;
}

bool Party::canEnableSharedExperience()
{
	if (!canUseSharedExperience(leader)) {
		return false;
	}

	for (Player* member : memberList) {
		if (!canUseSharedExperience(member)) {
			return false;
		}
	}
	return true;
}

void Party::updatePlayerTicks(Player* player, uint32_t points)
{
	if (points != 0 && !player->hasFlag(PlayerFlag_NotGainInFight)) {
		ticksMap[player->getID()] = OTSYS_TIME();
		updateSharedExperience();
	}
}

void Party::clearPlayerPoints(Player* player)
{
	auto it = ticksMap.find(player->getID());
	if (it != ticksMap.end()) {
		ticksMap.erase(it);
		updateSharedExperience();
	}
}

bool Party::canOpenCorpse(uint32_t ownerId) const
{
	if (Player* player = g_game.getPlayerByID(ownerId)) {
		return leader->getID() == ownerId || player->getParty() == this;
	}
	return false;
}
