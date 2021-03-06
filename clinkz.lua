
local clinkz = {}

function clinkz.OnProjectile(projectile)
    if not projectile.isAttack or not projectile.target or not Entity.IsHero(projectile.target) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if projectile.source ~= myHero then return end
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_clinkz" then return end
	source = projectile.source
	target = projectile.target

	clinkz.Combo(myHero, source, target)
end

function clinkz.Combo(myHero, source, target)
	if NPC.HasModifier(source, "modifier_clinkz_wind_walk") then return end
	local myMana = NPC.GetMana(myHero)

	local Medallion  = NPC.GetItem(myHero, "item_medallion_of_courage", true)
	local SolarCrest  = NPC.GetItem(myHero, "item_solar_crest", true)
	local Orchid  = NPC.GetItem(myHero, "item_orchid", true)
	local BloodThorn  = NPC.GetItem(myHero, "item_bloodthorn", true)
	local RoA = NPC.GetItem( myHero, "item_rod_of_atos", true)
	local Hex = NPC.GetItem(myHero, "item_sheepstick", true)
	local ForceStaff = NPC.GetItem(myHero, "item_force_staff", true)
	local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
	local Halberd = NPC.GetItem(myHero, "item_heavens_halberd", true)
	local Diffus = NPC.GetItem(myHero, "item_diffusal_blade", true)
	local nullif = NPC.GetItem(myHero, "item_nullifier", true)	 
	
			if NPC.IsEntityInRange(target, myHero, 700) and not NPC.HasModifier(target, "modifier_item_lotus_orb") and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
				if Medallion and Ability.IsCastable(Medallion, 0) then Ability.CastTarget(Medallion,target) end
				if SolarCrest and Ability.IsCastable(SolarCrest, 0) then Ability.CastTarget(SolarCrest,target) end
				if NPC.IsLinkensProtected(target) then
					if Diffus and Ability.IsCastable(Diffus, myMana) then Ability.CastTarget(Diffus, target); end
					if RoA and Ability.IsCastable(RoA, myMana) then Ability.CastTarget(RoA, target); end
					if Halberd and Ability.IsCastable(Halberd, myMana) then Ability.CastTarget(Halberd, target); end
					if hurrican and Ability.IsCastable(hurrican, myMana) then Ability.CastTarget(hurrican, target); end
					if ForceStaff and Ability.IsCastable(ForceStaff, myMana) then Ability.CastTarget(ForceStaff, target); end
					if Hex and Ability.IsCastable(Hex, myMana - 100) and Orchid and Ability.IsCastable(Orchid, myMana) then Ability.CastTarget(Orchid,target) end
					if Hex and Ability.IsCastable(Hex, myMana - 100) and BloodThorn and Ability.IsCastable(BloodThorn, myMana) then Ability.CastTarget(BloodThorn,target) end
				end
				if not NPC.IsLinkensProtected(target) then
					if Hex and Ability.IsCastable(Hex, myMana) then Ability.CastTarget(Hex, target); end
					if Orchid and Ability.IsCastable(Orchid, myMana) then Ability.CastTarget(Orchid,target) end
					if BloodThorn and Ability.IsCastable(BloodThorn, myMana) then Ability.CastTarget(BloodThorn,target) end
					if nullif and Ability.IsCastable(nullif, myMana) then Ability.CastTarget(nullif, target); end
					if RoA and Ability.IsCastable(RoA, myMana) then Ability.CastTarget(RoA, target); end
				end
			end
end

return clinkz