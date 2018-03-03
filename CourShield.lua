local CourShield = {}

CourShield.courier = nil

function CourShield.OnUpdate()
    local myHero = Heroes.GetLocal()
	if not myHero then return end
	if not CourShield.courier then
		CourShield.findCourier(myHero)
	end
	if CourShield.courier and Entity.GetHealth(CourShield.courier) ~= Entity.GetMaxHealth(CourShield.courier) then
		local shield = NPC.GetAbilityByIndex(CourShield.courier, 5)
		if shield and Ability.IsReady(shield) then
			Ability.CastNoTarget(shield)
		end
	end
end

function CourShield.findCourier(myHero)
	for i= 1, NPCs.Count() do
		local entity = NPCs.Get(i) 
		if entity and Entity.IsSameTeam(myHero, entity) and NPC.GetUnitName(entity) == "npc_dota_courier" and Entity.IsAlive(entity) then
			CourShield.courier = entity
		end 
	end
end

return CourShield