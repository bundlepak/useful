local AutoPurge = {}
time = 0
delay = 0

function AutoPurge.OnUpdate()
	time = os.clock()
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	if not enemy then return end
	AutoPurge.Combo(myHero, enemy)
	if delay > time then return end
	AutoPurge.Units(myHero, enemy)
end	

function AutoPurge.Combo(myHero, enemy)
	local myMana = NPC.GetMana(myHero)
			
	local nullifier = NPC.GetItem(myHero, "item_nullifier", true) 
	local satyrpurge = NPC.GetAbility(myHero, "satyr_trickster_purge")

	if not enemy then return end
	
	if (NPC.HasModifier(enemy, "modifier_ghost_state") or 
	   NPC.HasModifier(enemy, "modifier_eul_cyclone") or 
	   NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or
	   NPC.HasModifier(enemy, "modifier_necrolyte_sadist_active")or
	   NPC.HasModifier(enemy, "modifier_omninight_guardian_angel") or
	   NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade")) 
	   then
			if not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.IsLinkensProtected(enemy) and nullifier and Ability.IsReady(nullifier) and NPC.IsEntityInRange(enemy, myHero, Ability.GetCastRange(nullifier)) then
				Ability.CastTarget(nullifier, enemy) 
				return 
			elseif not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.IsLinkensProtected(enemy) and satyrpurge and Ability.IsReady(satyrpurge) and NPC.IsEntityInRange(enemy, myHero, Ability.GetCastRange(satyrpurge)) then
				Ability.CastTarget(satyrpurge, enemy)
			end
	end
end

function AutoPurge.Units(myHero, enemy)
	if not enemy then return end
	for _, npc in ipairs(NPC.GetUnitsInRadius(myHero, 99999, Enum.TeamType.TEAM_FRIEND)) do
		if Entity.IsAlive(npc) and not Entity.IsDormant(npc) and Entity.GetHealth(npc) and (Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero)) then
			if NPC.HasAbility(npc, "necronomicon_archer_purge") and NPC.IsEntityInRange(npc, enemy, 600) then
				if (NPC.HasModifier(enemy, "modifier_ghost_state") or 
				NPC.HasModifier(enemy, "modifier_eul_cyclone") or 
				NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or
				NPC.HasModifier(enemy, "modifier_necrolyte_sadist_active")or
				NPC.HasModifier(enemy, "modifier_omninight_guardian_angel") or
				NPC.HasModifier(enemy, "modifier_windrunner_windrun")or
				NPC.HasModifier(enemy, "modifier_windrunner_windrun_invis") or
				NPC.HasModifier(enemy, "modifier_sven_warcry")or
				NPC.HasModifier(enemy, "modifier_lich_frost_armor") or
				NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_addition")or
				NPC.HasModifier(enemy, "modifier_ogre_magi_frost_armor") or
				NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade")) 
				and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) 
				and not NPC.IsLinkensProtected(enemy) then
					Ability.CastTarget(NPC.GetAbility(npc, "necronomicon_archer_purge"), enemy)
					return
				end
			end
			if NPC.HasAbility(npc, "satyr_trickster_purge") and NPC.IsEntityInRange(npc, enemy, 350) then
				if (NPC.HasModifier(enemy, "modifier_ghost_state") or 
				NPC.HasModifier(enemy, "modifier_eul_cyclone") or 
				NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or
				NPC.HasModifier(enemy, "modifier_necrolyte_sadist_active")or
				NPC.HasModifier(enemy, "modifier_omninight_guardian_angel") or
				NPC.HasModifier(enemy, "modifier_windrunner_windrun")or
				NPC.HasModifier(enemy, "modifier_windrunner_windrun_invis") or
				NPC.HasModifier(enemy, "modifier_sven_warcry")or
				NPC.HasModifier(enemy, "modifier_lich_frost_armor") or
				NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_addition")or
				NPC.HasModifier(enemy, "modifier_ogre_magi_frost_armor") or
				NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade")) 
				and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) 
				and not NPC.IsLinkensProtected(enemy) then
					Ability.CastTarget(NPC.GetAbility(npc, "satyr_trickster_purge"), enemy)
					return
				end
			end
		end
	end
	delay = os.clock() + 0.1
end
return AutoPurge