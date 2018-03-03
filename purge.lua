local AutoPurge = {}

function AutoPurge.OnUpdate()
    AutoPurge.Combo()
end	

function AutoPurge.Combo()
    local myHero = Heroes.GetLocal()
    local hero = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	local myMana = NPC.GetMana(myHero)
			
	if not hero then return end
	
	local nullifier = NPC.GetItem(myHero, "item_nullifier", true) 
	
	 if (NPC.HasModifier(hero, "modifier_ghost_state") or 
	   NPC.HasModifier(hero, "modifier_eul_cyclone") or 
	   NPC.HasModifier(hero, "modifier_item_ethereal_blade_ethereal") or
	   NPC.HasModifier(hero, "modifier_necrolyte_sadist_active")or
	   NPC.HasModifier(hero, "modifier_omninight_guardian_angel") or
	   NPC.HasModifier(hero, "modifier_item_glimmer_cape_fade")) then
	   if not NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.IsLinkensProtected(hero)
	   and nullifier and Ability.IsReady(nullifier) and NPC.IsEntityInRange(hero, myHero, Ability.GetCastRange(nullifier)) then Ability.CastTarget(nullifier, hero) return end
	end
end
return AutoPurge