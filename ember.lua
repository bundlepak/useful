local Ember = {}

function Ember.OnUpdate()
    local myHero = Heroes.GetLocal()
    if not myHero then return end
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_ember_spirit" then return end
	local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	local Chains = NPC.GetAbilityByIndex(myHero, 0)
	if NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_caster") and Chains and Ability.IsReady(Chains) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		if NPC.IsEntityInRange(myHero, enemy, 50) then
			Ability.CastNoTarget(Chains)
		end
	end
end

return Ember