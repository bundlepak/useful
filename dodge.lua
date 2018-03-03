local Dodge = {}

local msg_queue = {}
local DELTA = 0.05
local ERROR = 0.2
local time = 0
local delayy = 0

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
        Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = projectile.source})
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
				Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = enemy})
			end
			local polarity = NPC.GetAbility(enemy, "magnataur_reverse_polarity")
			local polarity_range = 410
			if polarity and Ability.IsInAbilityPhase(polarity)
				and NPC.IsEntityInRange(myHero, enemy, polarity_range) then
				Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = enemy})
			end
			

			local lasso = NPC.GetAbility(enemy, "batrider_flaming_lasso")
			local lasso_range = 200
			if lasso and Ability.IsInAbilityPhase(lasso)
				and NPC.IsEntityInRange(myHero, enemy, lasso_range) then
				Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = enemy})
			end

			local duel = NPC.GetAbility(enemy, "legion_commander_duel")
			local duel_range = 150
			if duel and Ability.IsInAbilityPhase(duel)
				and NPC.IsEntityInRange(myHero, enemy, duel_range) then
				Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = enemy})
			end

			local crush = NPC.GetAbility(enemy, "slardar_slithereen_crush")
			local crush_range = 350
			if crush and Ability.IsInAbilityPhase(crush)
				and NPC.IsEntityInRange(myHero, enemy, crush_range) then
				Dodge.Update({time = GameRules.GetGameTime(); delay = 0; desc = ""; source = enemy})
			end			
		end
	end

end

function Dodge.TaskManagement(myHero)
	if not msg_queue or #msg_queue <= 0 then return end

	local info = table.remove(msg_queue, 1)
	if not info or not info.time or not info.delay then return end

	local currentTime = GameRules.GetGameTime()
	local diff = info.delay - ERROR
	local executeTime = info.time + math.max(diff, 0)

	if currentTime > executeTime + DELTA then return end
	if currentTime < executeTime - DELTA then Dodge.Update(info) return end

	Dodge.Defend(myHero, info.source)
end

function Dodge.Update(info)
	if not info then return end

	local myHero = Heroes.GetLocal()
	if not myHero then return end

	table.insert(msg_queue, info)
end

function Dodge.Defend(myHero, source)
    if not myHero then return end
	local myMana = NPC.GetMana(myHero)
	if time < delayy then return end

    if not NPC.IsSilenced(myHero) then 
        
        if NPC.GetUnitName(myHero) == "npc_dota_hero_life_stealer" then
            local rage = NPC.GetAbilityByIndex(myHero, 0)
            if rage and Ability.IsCastable(rage, myMana) then
				Ability.CastNoTarget(rage)
				delayy = os.clock() + 2
				return
            end
		end
		
        if NPC.GetUnitName(myHero) == "npc_dota_hero_juggernaut" then
            local spin = NPC.GetAbilityByIndex(myHero, 0)
            if spin and Ability.IsCastable(spin, myMana) then
				Ability.CastNoTarget(spin)
				delayy = os.clock() + 2
				return
            end
        end

	end
	
	local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
	if bkb and Ability.IsCastable(bkb, NPC.GetMana(myHero)) then
		if source then
			Ability.CastNoTarget(bkb)
			delayy = os.clock() + 2
			return
		end
	end
    
	local item = NPC.GetItem(myHero, "item_blade_mail", true)
	if item and Ability.IsCastable(item, NPC.GetMana(myHero)) then
		if source then
			Ability.CastNoTarget(item)
			delayy = os.clock() + 2
			return
		end
	end
end

return Dodge