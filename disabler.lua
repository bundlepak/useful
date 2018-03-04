local disabler= {}

local time = 0
local delay = 0

function disabler.OnUpdate()
    local myHero = Heroes.GetLocal()
    if not myHero then return end
    time = os.clock()
    local myTeam = Entity.GetTeamNum(myHero)
    for i= 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        local sameTeam = Entity.GetTeamNum(enemy) == myTeam
        if not sameTeam and not NPC.IsDormant(enemy) and Entity.GetHealth(enemy) > 0 then
            local dagger = NPC.GetItem(enemy,"item_blink")
            if dagger and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(dagger) > 4 and Ability.SecondsSinceLastUse(dagger)<=1 and Ability.SecondsSinceLastUse(dagger)>0 then
                disabler.Disable(myHero, enemy)
            end 
            local ck = NPC.GetAbility(enemy, "chaos_knight_reality_rift")
            if ck and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(ck) > 4 and Ability.SecondsSinceLastUse(ck)<=1 and Ability.SecondsSinceLastUse(ck)>0 then
                disabler.Disable(myHero, enemy)
            end
            local void = NPC.GetAbility(enemy, "faceless_void_time_walk")
            if void and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(void) > 4 and Ability.SecondsSinceLastUse(void)<=1 and Ability.SecondsSinceLastUse(void)>0 then
                disabler.Disable(myHero, enemy)
            end
            local pa = NPC.GetAbility(enemy, "phantom_assassin_phantom_strike")
            if pa and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(pa) > 4 and Ability.SecondsSinceLastUse(pa)<=1 and Ability.SecondsSinceLastUse(pa)>0 then
                disabler.Disable(myHero, enemy)
            end
            local slark = NPC.GetAbility(enemy, "slark_pounce")
            if slark and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(slark) > 4 and Ability.SecondsSinceLastUse(slark)<=1 and Ability.SecondsSinceLastUse(slark)>0 then
                disabler.Disable(myHero, enemy)
            end
            local qop = NPC.GetAbility(enemy, "queenofpain_blink")
            if qop and NPC.IsEntityInRange(myHero, enemy, 700) and Ability.GetCooldownLength(qop) > 4 and Ability.SecondsSinceLastUse(qop)<=1 and Ability.SecondsSinceLastUse(qop)>0 then
                disabler.Disable(myHero, enemy)
            end
            
        end 
    end 
end

function disabler.Disable(myHero, enemy)
    if time < delay then return end
    if NPC.IsLinkensProtected(enemy) or NPC.HasModifier(enemy, "modifier_item_lotus_orb") or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or disabler.IsDisabled(enemy) then return end
    local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
    local bloodthorn = NPC.GetItem(myHero,"item_bloodthorn")
    local orchid = NPC.GetItem(myHero,"item_orchid")
    local sheepstick = NPC.GetItem(myHero,"item_sheepstick")
    local abyssal_blade = NPC.GetItem(myHero,"	item_abyssal_blade")
    local lion = NPC.GetAbility(myHero, "lion_voodoo")
    local shaman = NPC.GetAbility(myHero, "shadow_shaman_voodoo")
    local sky = NPC.GetAbility(myHero, "skywrath_mage_ancient_seal")
    local ns = NPC.GetAbility(myHero, "night_stalker_crippling_fear")
    local gyro = NPC.GetAbility(myHero, "gyrocopter_homing_missile")
    local dk = NPC.GetAbility(myHero, "dragon_knight_dragon_tail")
    local drow = NPC.GetAbility(myHero, "drow_ranger_wave_of_silence")
    local lone = NPC.GetAbility(myHero, "lone_druid_savage_roar")
    local razor = NPC.GetAbility(myHero, "razor_static_link")
    if sheepstick and Ability.IsReady(sheepstick) then
        Ability.CastTarget(sheepstick, enemy)
        delay = os.clock() + 2 return
    end 
    if lion and Ability.IsReady(lion) then
        Ability.CastTarget(lion, enemy)
        delay = os.clock() + 2 return
    end 
    if hurrican and Ability.IsReady(hurrican) then
        Ability.CastTarget(hurrican, enemy)
        delay = os.clock() + 2 return
    end 
    if shaman and Ability.IsReady(shaman) then
        Ability.CastTarget(shaman, enemy)
        delay = os.clock() + 2 return
    end 
    if razor and Ability.IsReady(razor) then
        Ability.CastTarget(razor, enemy)
        delay = os.clock() + 2 return
    end 
    if hurrican and Ability.IsReady(hurrican) and NPC.IsEntityInRange(myHero, enemy, 350) then
        Ability.CastTarget(hurrican, enemy)
        return
    end 
    if gyro and Ability.IsReady(gyro) then
        Ability.CastTarget(gyro, enemy)
        delay = os.clock() + 2 return
    end 
    if NPC.GetUnitName(enemy) == "npc_dota_hero_slark" then return end
    if abyssal_blade and Ability.IsReady(abyssal_blade) then
        Ability.CastTarget(abyssal_blade, enemy)
        delay = os.clock() + 2 return
    end 
    if dk and Ability.IsReady(dk) and NPC.IsEntityInRange(myHero, enemy, 150) then
        Ability.CastTarget(dk, enemy)
        delay = os.clock() + 2 return
    end 
    if bloodthorn and Ability.IsReady(bloodthorn) then
        Ability.CastTarget(bloodthorn, enemy)
        delay = os.clock() + 2 return
    end 
    if orchid and Ability.IsReady(orchid) then
        Ability.CastTarget(orchid, enemy)
        delay = os.clock() + 2 return
    end 
    if sky and Ability.IsReady(sky) then
        Ability.CastTarget(sky, enemy)
        delay = os.clock() + 2 return
    end 
    if ns and Ability.IsReady(ns) and NPC.IsEntityInRange(myHero, enemy, 350) then
        Ability.CastTarget(ns, enemy)
        delay = os.clock() + 2 return
    end 
    if drow and Ability.IsReady(drow)then
        Ability.CastPosition(drow, Entity.GetAbsOrigin(enemy))
        delay = os.clock() + 2 return
    end 
    if lone and Ability.IsReady(lone) and NPC.IsEntityInRange(myHero, enemy, 325) then
        Ability.CastNoTarget(lone)
        delay = os.clock() + 2 return
    end 

end

function disabler.IsDisabled(enemy)
    if not Entity.IsAlive(enemy) then return true end
    if NPC.IsStunned(enemy) then return true end
    if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then return true end
    if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_SILENCED) then return true end
    return false
  end


return disabler