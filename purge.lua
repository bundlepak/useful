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
			if NPC.IsLinkensProtected(enemy) or NPC.HasModifier(enemy, "modifier_item_lotus_orb") or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then return end
			if nullifier and Ability.IsReady(nullifier) and NPC.IsEntityInRange(enemy, myHero, Ability.GetCastRange(nullifier)) then
				Ability.CastTarget(nullifier, enemy) 
				return 
			elseif satyrpurge and Ability.IsReady(satyrpurge) and NPC.IsEntityInRange(enemy, myHero, Ability.GetCastRange(satyrpurge)) then
				Ability.CastTarget(satyrpurge, enemy)
			end
	end
end

function AutoPurge.Units(myHero, enemy)
	if not enemy then return end
        for i= 1, NPCs.Count() do
            local entity = NPCs.Get(i)
            local name = NPC.GetUnitName(entity)
            if name == "npc_dota_hero_arc_warden" and myHero~= entity  then
				local nullifier = NPC.GetItem(entity, "item_nullifier", true) 
				if nullifier and Ability.IsReady(nullifier) and NPC.IsEntityInRange(entity, enemy, 600) then
					if (NPC.HasModifier(enemy, "modifier_ghost_state") or 
					NPC.HasModifier(enemy, "modifier_eul_cyclone") or 
					NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or
					NPC.HasModifier(enemy, "modifier_necrolyte_sadist_active")or
					NPC.HasModifier(enemy, "modifier_omninight_guardian_angel") or
					NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade")) then
						Ability.CastTarget(nullifier, enemy)
					end
				end
            end
        end
	for _, npc in ipairs(NPC.GetUnitsInRadius(myHero, 99999, Enum.TeamType.TEAM_FRIEND)) do
		if Entity.IsAlive(npc) and not Entity.IsDormant(npc) and Entity.GetHealth(npc) and (Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero)) then
			if NPC.IsLinkensProtected(enemy) or NPC.HasModifier(enemy, "modifier_item_lotus_orb") or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then return end
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
				NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade"))  then
					local necropurge = NPC.GetAbility(npc, "necronomicon_archer_purge")
					if necropurge and Ability.IsReady(necropurge) then
						Ability.CastTarget(necropurge, enemy)
						return
					end
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
				NPC.HasModifier(enemy, "modifier_item_glimmer_cape_fade")) then
					local satyrNpcpurge = NPC.GetAbility(npc, "satyr_trickster_purge")
					if satyrNpcpurge and Ability.IsReady(satyrNpcpurge) then
						Ability.CastTarget(satyrNpcpurge, enemy)
						return
					end
				end
			end
		end
	end
	delay = os.clock() + 0.1
end
return AutoPurge