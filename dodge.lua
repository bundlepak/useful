local Dodge = {}

local msg_queue = {}
local time = 0
local delay = 0

function Dodge.OnProjectile(projectile)
	if not projectile or not projectile.target then return end
	if projectile.isAttack then return end

	local myHero = Heroes.GetLocal()
	if not myHero then return end

	if projectile.target ~= myHero then return end
    if Entity.IsSameTeam(projectile.source, projectile.target) then return end
    local projectileName = tostring(projectile.name)
    if 
    projectileName == "skeletonking_hellfireblast" or
    projectileName == "alchemist_unstable_concoction_projectile" or
    projectileName == "vengeful_magic_missle" or
    projectileName == "sniper_assassinate" or
    projectileName == "windrunner_shackleshot" or
    projectileName == "chaos_knight_chaos_bolt" or
    projectileName == "sven_spell_storm_bolt" then
        Dodge.Update({source = projectile.source})
    end
	
end

function Dodge.OnUpdate()
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	time = os.clock()

	Dodge.TaskManagement(myHero)

	for i = 1, Heroes.Count() do
		local enemy = Heroes.Get(i)
		if enemy and not NPC.IsIllusion(enemy)
			and not Entity.IsSameTeam(myHero, enemy)
			and not Entity.IsDormant(enemy)
			and Entity.IsAlive(enemy) then

			-- axe's call
			local axe_call = NPC.GetAbility(enemy, "axe_berserkers_call")
			local call_range = 300
			if axe_call and Ability.IsInAbilityPhase(axe_call)
				and NPC.IsEntityInRange(myHero, enemy, call_range) then
				Dodge.Update({desc = axe_call})
			end
			local polarity = NPC.GetAbility(enemy, "magnataur_reverse_polarity")
			local polarity_range = 410
			if polarity and Ability.IsInAbilityPhase(polarity)
				and NPC.IsEntityInRange(myHero, enemy, polarity_range) then
				Dodge.Update({desc = polarity})
			end
			

			local lasso = NPC.GetAbility(enemy, "batrider_flaming_lasso")
			local lasso_range = 200
			if lasso and Ability.IsInAbilityPhase(lasso)
				and NPC.IsEntityInRange(myHero, enemy, lasso_range) then
				Dodge.Update({desc = lasso})
			end

			local duel = NPC.GetAbility(enemy, "legion_commander_duel")
			local duel_range = 150
			if duel and Ability.IsInAbilityPhase(duel)
				and NPC.IsEntityInRange(myHero, enemy, duel_range) then
				Dodge.Update({desc = duel})
			end

			local crush = NPC.GetAbility(enemy, "slardar_slithereen_crush")
			local crush_range = 350
			if crush and Ability.IsInAbilityPhase(crush)
				and NPC.IsEntityInRange(myHero, enemy, crush_range) then
				Dodge.Update({desc = crush})
			end			
		end
	end

end

function Dodge.TaskManagement(myHero)
	if not msg_queue or #msg_queue <= 0 then return end

	local info = table.remove(msg_queue, 1)

	Dodge.Defend(myHero, info.desc)
end

function Dodge.Update(info)
	if not info then return end

	local myHero = Heroes.GetLocal()
	if not myHero then return end

	table.insert(msg_queue, info)
end

function Dodge.Defend(myHero, desc)
    if not myHero then return end
	local myMana = NPC.GetMana(myHero)
	if time < delay then return end

    if not NPC.IsSilenced(myHero) then 
        
        if NPC.GetUnitName(myHero) == "npc_dota_hero_life_stealer" then
            local rage = NPC.GetAbilityByIndex(myHero, 0)
            if rage and Ability.IsCastable(rage, myMana) then
				Ability.CastNoTarget(rage)
				delay = os.clock() + 2
				return
            end
		end
		
        if NPC.GetUnitName(myHero) == "npc_dota_hero_juggernaut" then
            local spin = NPC.GetAbilityByIndex(myHero, 0)
            if spin and Ability.IsCastable(spin, myMana) then
				Ability.CastNoTarget(spin)
				delay = os.clock() + 2
				return
            end
		end

		if NPC.GetUnitName(myHero) == "npc_dota_hero_pugna" then
            local dicri = NPC.GetAbilityByIndex(myHero, 1)
            if desc and (Ability.GetName(desc) == "magnataur_reverse_polarity" or Ability.GetName(desc) == "axe_berserkers_call") and dicri and Ability.IsCastable(dicri, myMana) then
				Ability.CastTarget(dicri, myHero)
				delay = os.clock() + 2
				return
            end
		end
		
		if NPC.GetUnitName(myHero) == "npc_dota_hero_gyrocopter" then
            local flak = NPC.GetAbilityByIndex(myHero, 2)
            if desc and (Ability.GetName(desc) == "legion_commander_duel" or Ability.GetName(desc) == "axe_berserkers_call") and flak and Ability.IsCastable(flak, myMana) then
				Ability.CastNoTarget(flak)
				return
            end
        end

	end

	local sata = NPC.GetItem(myHero, "item_satanic", true)
	if desc and sata and (Ability.GetName(desc) == "legion_commander_duel" or Ability.GetName(desc) == "axe_berserkers_call") and Ability.IsCastable(sata, NPC.GetMana(myHero)) then
			Ability.CastNoTarget(sata)
			return
	end
	
	local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
	if bkb and Ability.IsCastable(bkb, NPC.GetMana(myHero)) then
			Ability.CastNoTarget(bkb)
			delay = os.clock() + 2
			return
	end
    
	local item = NPC.GetItem(myHero, "item_blade_mail", true)
	if item and Ability.IsCastable(item, NPC.GetMana(myHero)) then
			Ability.CastNoTarget(item)
			delay = os.clock() + 2
			return
	end
end

return Dodge