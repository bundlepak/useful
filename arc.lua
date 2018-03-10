local ArcHelper= {}
ArcHelper.optionKey = Menu.AddKeyOption({ "Hero Specific","Arc Warden", "Hotkeys"}, "Clone Combo", Enum.ButtonCode.KEY_P)
ArcHelper.optionUseCloneDiffusalBlade = Menu.AddOption({ "Hero Specific","Arc Warden", "Items Usage"}, "Auto Use Clone Diffusal Blade", "Arc Warden Help Script")
ArcHelper.optionAutoUseCloneMidas = Menu.AddOption({ "Hero Specific","Arc Warden", "Items Usage"}, "Auto Use Clone Midas", "Arc Warden Help Script")
ArcHelper.optionAutoDefend = Menu.AddOption({ "Hero Specific","Arc Warden"}, "Clone autodefend", "Autoorchid/autohex etc.")
 
ArcHelper.cache = {}
time = 0
delay = 0
ArcHelper.clone = nil
ArcHelper.Attacking = false
ArcHelper.AttackingTarget = nil
ArcHelper.cloneTick = 0
ArcHelper.cloneHexTick = 0
ArcHelper.font = Renderer.LoadFont("Tahoma", 24, Enum.FontWeight.EXTRABOLD)
 
ArcHelper.enemyFountain = nil
ArcHelper.dummy = nil
ArcHelper.needTP = true
ArcHelper.useOrchidDuringHex = false
ArcHelper.useHurrican =  true
 
ArcHelper.mainTick = 0
ArcHelper.mainHexTick = 0
 
function ArcHelper.OnUpdate()
    local myHero = Heroes.GetLocal()
    if myHero == nill then return end
    local myName = NPC.GetUnitName(myHero)
    if myName ~= "npc_dota_hero_arc_warden" then return end
    time = os.clock()
    local ultimate = NPC.GetAbilityByIndex(myHero,5)

    if Menu.IsEnabled(ArcHelper.optionAutoUseCloneMidas) then 
        if time < delay then return end
        ArcHelper.useMidas(ArcHelper.clone) 
        ArcHelper.useMidas(myHero) 
        delay = os.clock() + 0.1
    end

    if Menu.IsKeyDownOnce(ArcHelper.optionKey) then
        if not ArcHelper.Attacking then
            ArcHelper.Attacking = true
        else
            ArcHelper.Attacking = not ArcHelper.Attacking
            ArcHelper.AttackingTarget = nil
        end
    end


    if ArcHelper.clone == nil and ultimate and Ability.GetLevel(ultimate)>0 then
        for i= 1, NPCs.Count() do
            local entity = NPCs.Get(i)
            if entity and NPC.IsEntityInRange(myHero, entity, 200) then
                local name = NPC.GetUnitName(entity)
                if name == "npc_dota_hero_arc_warden" and myHero~= entity  then
                    ArcHelper.clone = entity
                end
            end
        end
        return
    end
 
    if ArcHelper.clone and not Entity.IsAlive(ArcHelper.clone) and not Ability.IsReady(ultimate) then
        ArcHelper.AttackingTarget = nil
        ArcHelper.cloneTick = 0
        ArcHelper.useOrchidDuringHex = false
        return
    end
 
    
    ArcHelper.cloneAttack()
end
 
function ArcHelper.foundFountain(teamNum)
    for i = 1, NPCs.Count() do
        local npc = NPCs.Get(i)
 
        if Entity.GetTeamNum(npc) == teamNum and NPC.IsStructure(npc) then
            local name = NPC.GetUnitName(npc)
            if name ~= nil and name == "dota_fountain" then
                return NPC.GetAbsOrigin(npc)
            end
        end
    end
end
 
function ArcHelper.autoDefend(myHero)
    if not myHero then return end
    local myTeam = Entity.GetTeamNum(myHero)
    local mainHero = Heroes.GetLocal()
 
    local orchid = NPC.GetItem(myHero,"item_orchid")
    local bloodthorn = NPC.GetItem(myHero,"item_bloodthorn")
    local hex = NPC.GetItem(myHero, "item_sheepstick")
    local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
 
    if not orchid and not bloodthorn and not hex and not hurrican then return end
    for i= 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        local sameTeam = Entity.GetTeamNum(enemy) == myTeam
        if not sameTeam and not NPC.IsDormant(enemy) and Entity.GetHealth(enemy) > 0 then
            local dagger = NPC.GetItem(enemy,"item_blink")
            if dagger and NPC.IsEntityInRange(myHero, enemy, 800) and Ability.GetCooldownLength(dagger) > 4 and Ability.SecondsSinceLastUse(dagger)<=1 and Ability.SecondsSinceLastUse(dagger)>0 then
                local orchid_main = NPC.GetItem(mainHero,"item_orchid")
                local bloodthorn_main = NPC.GetItem(mainHero,"item_bloodthorn")
                local hex_main = NPC.GetItem(mainHero, "item_sheepstick")
                local hurrican_main = NPC.GetItem(mainHero,"item_hurricane_pike")
                local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
                 if not NPC.IsSilenced(enemy) then
                    if NPC.IsEntityInRange(myHero, mainHero,1000) and NPC.IsEntityInRange(mainHero,enemy, 1000) then
                        if (not orchid or not Ability.IsReady(orchid_main)) and (not bloodthorn or not Ability.IsReady(bloodthorn_main)) and (not hex or not Ability.IsReady(hex_main)) then
                            if hex and Ability.IsReady(hex) then
                                Ability.CastTarget(hex, enemy)
                            return
                            end
                            if bloodthorn and Ability.IsReady(bloodthorn) then
                                Ability.CastTarget(bloodthorn, enemy)
                                return
                            end
                            if orchid and Ability.IsReady(orchid) then
                                Ability.CastTarget(orchid, enemy)
                                return
                            end
                            if NPC.IsEntityInRange(mainHero,enemy, 400) and hurrican and Ability.IsReady(hurrican) then
                                Ability.CastTarget(hurrican, enemy)
                                return
                            end
                           
                    else
                        if hex and Ability.IsReady(hex) then
                            Ability.CastTarget(hex, enemy)
                        return
                        end
                        if bloodthorn and Ability.IsReady(bloodthorn) then
                            Ability.CastTarget(bloodthorn, enemy)
                            return
                        end
                        if orchid and Ability.IsReady(orchid) then
                            Ability.CastTarget(orchid, enemy)
                            return
                        end
                        if hurrican and Ability.IsReady(hurrican) then
                            Ability.CastTarget(hurrican, enemy)
                            return
                        end
                    end
                end
            end
        end
    end
end
end
 
function ArcHelper.closerToFountain(myHero, creep)
    local creepPos = Entity.GetAbsOrigin(creep)
    local dist1 = creepPos -  ArcHelper.enemyFountain
    local len1 = dist1:Length2D()
    local dist2 = Entity.GetAbsOrigin(myHero) - ArcHelper.enemyFountain
    local len2 = dist2:Length2D()
    if len2 < len1 then return true end
    return false
end
 
function ArcHelper.cloneAttack()
    if not ArcHelper.clone or not Entity.IsAlive(ArcHelper.clone) then return end
   
    if Menu.IsEnabled(ArcHelper.optionAutoDefend) then
        ArcHelper.autoDefend(ArcHelper.clone)
    end
 
    if os.clock() < ArcHelper.cloneTick then return end
    local myHero = Heroes.GetLocal()
    local flux = NPC.GetAbilityByIndex(ArcHelper.clone, 0)
    local magnetic = NPC.GetAbilityByIndex(ArcHelper.clone, 1)
    local spark = NPC.GetAbilityByIndex(ArcHelper.clone, 2)
    local orchid = NPC.GetItem(ArcHelper.clone,"item_orchid")
    local bloodthorn = NPC.GetItem(ArcHelper.clone,"item_bloodthorn")
    local mjollnir = NPC.GetItem(ArcHelper.clone,"item_mjollnir")
    local hex = NPC.GetItem(ArcHelper.clone,"item_sheepstick")
    local dagger = NPC.GetItem(ArcHelper.clone,"item_blink")
    local phase = NPC.GetItem(ArcHelper.clone,"item_phase_boots")
    local shadowblade = NPC.GetItem(ArcHelper.clone,"item_invis_sword")
    local silver_edge = NPC.GetItem(ArcHelper.clone,"item_silver_edge")
    local invisible_candidate_blade = shadowblade
    local force = NPC.GetItem(ArcHelper.clone,"item_force_staff")
    local hurrican = NPC.GetItem(ArcHelper.clone,"item_hurricane_pike")
    local dragon_lance = NPC.GetItem(ArcHelper.clone,"item_dragon_lance")
    local diffusal = NPC.GetItem(ArcHelper.clone,"item_diffusal_blade")
    local null = NPC.GetItem(ArcHelper.clone,"item_nullifier")
 
   
 
    local myRange = NPC.GetAttackRange(ArcHelper.clone)
    if dragon_lance or hurrican then
        myRange = myRange + 140
    end
 
    if silver_edge then
        invisible_candidate_blade = silver_edge
    end
 
    if ArcHelper.Attacking then
        if not ArcHelper.AttackingTarget or not Entity.IsAlive(ArcHelper.AttackingTarget) or not NPC.IsEntityInRange(ArcHelper.AttackingTarget, ArcHelper.clone, 2500) then
            ArcHelper.AttackingTarget = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
            if not ArcHelper.AttackingTarget  then return end
            if not NPC.IsEntityInRange(ArcHelper.AttackingTarget, ArcHelper.clone, 2500) then
                ArcHelper.AttackingTarget =  nil
            end
        if ArcHelper.AttackingTarget then
                local hits = ArcHelper.calculateHits(ArcHelper.clone, ArcHelper.AttackingTarget)
                local hitsDuringHex = 7/NPC.GetAttackTime(ArcHelper.clone)*2
                if not NPC.IsEntityInRange(myHero,ArcHelper.AttackingTarget, 800) then
                    hitsDuringHex = hitsDuringHex /2
                end
                ArcHelper.useOrchidDuringHex =  hitsDuringHex <= hits*0.8
            end
        end
        if ArcHelper.AttackingTarget then
            if dagger and Ability.IsReady(dagger) then
                if NPC.IsEntityInRange(ArcHelper.clone,ArcHelper.AttackingTarget, 1500) then
                    ArcHelper.useDagger(ArcHelper.clone, dagger, Entity.GetAbsOrigin(ArcHelper.AttackingTarget))
                else
                    Player.AttackTarget(Players.GetLocal(), ArcHelper.clone, ArcHelper.AttackingTarget)
                    ArcHelper.cloneTick = os.clock() + 0.05
                end
                return
            end
 
            if invisible_candidate_blade
                and Ability.IsReady(invisible_candidate_blade)
                and ArcHelper.isEnougthMana(ArcHelper.clone, invisible_candidate_blade) then
                    Ability.CastNoTarget(invisible_candidate_blade)
                    ArcHelper.cloneTick = os.clock() + 0.05
                return
            end
 
            if NPC.IsLinkensProtected(ArcHelper.AttackingTarget) then
                if Ability.IsReady(flux) and ArcHelper.isEnougthMana(ArcHelper.clone, flux) then
                    ArcHelper.cloneTick = os.clock() + 0.05
                    Ability.CastTarget(flux,ArcHelper.AttackingTarget)
                    return
                end
            end
           
            if NPC.HasModifier(ArcHelper.clone,"modifier_item_silver_edge_windwalk")
                or NPC.HasModifier(ArcHelper.clone,"modifier_item_invisibility_edge_windwalk") then
               
                if NPC.IsEntityInRange(ArcHelper.AttackingTarget, ArcHelper.clone, 700) then
                    Player.AttackTarget(Players.GetLocal(), ArcHelper.clone, ArcHelper.AttackingTarget)
                    ArcHelper.cloneTick = os.clock() + 0.05
                    return
                else
                    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, ArcHelper.AttackingTarget, Vector(), ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, ArcHelper.clone, queue, true)
                    ArcHelper.cloneTick = os.clock() + 0.05
                end
                return
            end
 
            if diffusal and Ability.IsReady(diffusal)
                and not NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_item_diffusal_blade_slow") and
                not NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff")
                and not NPC.IsStunned(ArcHelper.AttackingTarget) then
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(diffusal,ArcHelper.AttackingTarget)
                return
            end
           
            if null and Ability.IsReady(null)
                and not NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_item_nullifier_mute") and
                not NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_item_nullifier_mute")
                and not NPC.IsStunned(ArcHelper.AttackingTarget) then
               
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(null,ArcHelper.AttackingTarget)
                return
            end
 
            if hurrican and Ability.IsReady(hurrican)
                and ArcHelper.isEnougthMana(ArcHelper.clone, hurrican)
                and ArcHelper.isTarget(ArcHelper.clone,ArcHelper.AttackingTarget, 1800)
                and not NPC.IsEntityInRange(ArcHelper.AttackingTarget, ArcHelper.clone, 500)
                    and ArcHelper.useHurrican then
               
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(hurrican,ArcHelper.clone)
                return
            end
           
            if force and Ability.IsReady(force) and ArcHelper.isTarget(ArcHelper.clone,ArcHelper.AttackingTarget, 1800) and not NPC.IsEntityInRange(ArcHelper.AttackingTarget, ArcHelper.clone, 500) and ArcHelper.useHurrican then
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(force,ArcHelper.clone)
                return
            end
 
 
            if hex and Ability.IsReady(hex)
                and ArcHelper.isEnougthMana(ArcHelper.clone, hex)
                and not NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff")
                and not NPC.IsStunned(ArcHelper.AttackingTarget) then
               
                Ability.CastTarget(hex,ArcHelper.AttackingTarget)
                ArcHelper.cloneTick = os.clock() + 0.05
                return
            end
 
            if hex and Ability.IsReady(hex)
                and ArcHelper.isEnougthMana(ArcHelper.clone, hex)
                and NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff")
                and ArcHelper.isEnougthMana(ArcHelper.clone, hex) then
               
                local modifier = NPC.GetModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff")
                ArcHelper.cloneHexTick = Modifier.GetCreationTime(modifier) + 3.35
                if os.clock() > ArcHelper.cloneHexTick then
                    Ability.CastTarget(hex,ArcHelper.AttackingTarget)
                    return
                end
            end
 
            if bloodthorn and Ability.IsReady(bloodthorn)
                and ArcHelper.isEnougthMana(ArcHelper.clone, bloodthorn)
                and (not NPC.IsSilenced(ArcHelper.AttackingTarget) or NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff") and ArcHelper.useOrchidDuringHex) then
               
                Ability.CastTarget(bloodthorn,ArcHelper.AttackingTarget)
            end
           
            if orchid and Ability.IsReady(orchid)
                and ArcHelper.isEnougthMana(ArcHelper.clone, orchid)
                and (not NPC.IsSilenced(ArcHelper.AttackingTarget) or NPC.HasModifier(ArcHelper.AttackingTarget, "modifier_sheepstick_debuff") and ArcHelper.useOrchidDuringHex) then
               
                Ability.CastTarget(orchid,ArcHelper.AttackingTarget)
            end
 
            if mjollnir and Ability.IsReady(mjollnir) and ArcHelper.isEnougthMana(ArcHelper.clone, mjollnir) then
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(mjollnir,ArcHelper.clone)
                return
            end
           
            if phase and Ability.IsReady(phase) then
                Ability.CastNoTarget(phase)
                return
            end
           
            if Ability.IsReady(flux) and ArcHelper.isEnougthMana(ArcHelper.clone, flux) then
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastTarget(flux,ArcHelper.AttackingTarget)
                return
            end
            if Ability.IsReady(spark) and ArcHelper.isEnougthMana(ArcHelper.clone, spark) then
                ArcHelper.cloneTick = os.clock() + 0.05
                Ability.CastPosition(spark,NPC.GetAbsOrigin(ArcHelper.AttackingTarget))
                return
            end
            Player.AttackTarget(Players.GetLocal(), ArcHelper.clone, ArcHelper.AttackingTarget)
            ArcHelper.cloneTick = os.clock() + NPC.GetAttackTime(myHero)/2
        end
    end
end
 
function ArcHelper.OnDraw()
    local myHero = Heroes.GetLocal()
 
    ArcHelper.DrawCloneMidasMsg()
    ArcHelper.DrawCloneSwitchMsg()
end
 
function ArcHelper.useDagger(myHero, dagger, vector)
    if dagger == nill or not Ability.IsReady(dagger) then return end
    local dir = vector - NPC.GetAbsOrigin(myHero)
    dir:SetZ(0)
    dir:Normalize()
    dir:Scale(1199)
 
    local destination = NPC.GetAbsOrigin(myHero) + dir
    Ability.CastPosition(dagger, vector)
end
 
function ArcHelper.useMidas(myHero)
    if not myHero or not Entity.IsAlive(myHero) then return end
    if NPC.HasModifier(myHero,"modifier_item_silver_edge_windwalk") or NPC.HasModifier(myHero,"modifier_item_invisibility_edge_windwalk") then return end
    local midas = NPC.GetItem(myHero, "item_hand_of_midas")
    if not midas then return end
    local teamNum = Entity.GetTeamNum(myHero)
    local entity = Input.GetNearestUnitToCursor(teamNum, Enum.TeamType.TEAM_ENEMY)
        if ArcHelper.isMidasableCreep(myHero, entity) and Ability.IsReady(midas) then
            Ability.CastTarget(midas, entity)
            return
        end
end
 
function ArcHelper.isMidasableCreep(myHero, entity)
    if entity and
        not Entity.IsSameTeam(myHero, entity)
        and (NPC.IsCreep(entity)
        or NPC.IsLaneCreep(entity)
        or NPC.IsNeutral(entity))
        and not NPC.IsAncient(entity)
        and NPC.IsEntityInRange(myHero, entity, 800) then
            local name = NPC.GetUnitName(entity)
            local w, h = Renderer.GetScreenSize()
            if name == "npc_dota_neutral_black_dragon"
                or name == "npc_dota_neutral_black_drake"
                or name == "npc_dota_neutral_black_dragon"
                or name == "npc_dota_neutral_blue_dragonspawn_sorcerer"
                or name == "npc_dota_neutral_blue_dragonspawn_overseer"
                or name == "npc_dota_neutral_granite_golem"
                or name == "npc_dota_neutral_elder_jungle_stalker"
                or name == "npc_dota_neutral_prowler_acolyte"
                or name == "npc_dota_neutral_prowler_shaman"
                or name == "npc_dota_neutral_rock_golem"
                or name == "npc_dota_neutral_small_thunder_lizard"
                or name == "npc_dota_neutral_jungle_stalker"
                or name == "npc_dota_neutral_big_thunder_lizard"
                or name == "npc_dota_roshan" then
                    return false
            end
            return true
    end
    return false
end
 
function ArcHelper.calculateHits(myHero, enemy)
    if not myHero or not enemy then return end
    local trueDamage = NPC.GetDamageMultiplierVersus(myHero, enemy) * (NPC.GetTrueDamage(myHero) * NPC.GetArmorDamageMultiplier(enemy))
    local pos = NPC.GetAbsOrigin(enemy)
    local x, y, visible = Renderer.WorldToScreen(pos)
    local healthLeft = Entity.GetHealth(enemy)
    local hitCount = math.ceil(healthLeft/trueDamage)
    return hitCount
end
 
function ArcHelper.isTarget(source,target, range)
    local angle = Entity.GetRotation(source)
    local angleOffset = Angle(0, 45, 0)
    angle:SetYaw(angle:GetYaw() + angleOffset:GetYaw())
    local x,y,z = angle:GetVectors()
    local direction = x + y + z
    local name = NPC.GetUnitName(target)
    direction:SetZ(0)
 
    local radius = 50
    local origin = Entity.GetAbsOrigin(source)
 
    local pointsNum = math.floor(range/55) + 1
    for i = pointsNum,1,-1 do
        direction:Normalize()
        direction:Scale(50*(i-1))
        local pos = direction + origin
        if NPC.IsPositionInRange(target, pos, radius + NPC.GetHullRadius(target), 0) then
            return true
        end
    end
    return false
end
 
function ArcHelper.DrawCloneMidasMsg()
    if not ArcHelper.clone then return end
    local midas = NPC.GetItem(ArcHelper.clone,  "item_hand_of_midas")
    local bot = NPC.GetItem(ArcHelper.clone,    "item_travel_boots")
    local bot2 = NPC.GetItem(ArcHelper.clone,   "item_travel_boots_2")
        if bot2 then bot = bot2 end
    local w, h = Renderer.GetScreenSize()
 
    if midas then
        Renderer.DrawTextCentered(ArcHelper.font, w-200, 100, "Midas:"..math.floor(Ability.GetCooldownTimeLeft(midas)), 1)
    end
 
    if bot then
        Renderer.DrawTextCentered(ArcHelper.font, w-200, 150, "Bot:"..math.floor(Ability.GetCooldownTimeLeft(bot)), 1)
    end
end
 
function ArcHelper.DrawCloneSwitchMsg()
    local w, h = Renderer.GetScreenSize()
    local c = math.floor(w / 2.2)
    Renderer.SetDrawColor(255, 0, 255)
    if ArcHelper.Attacking then
        Renderer.DrawText(ArcHelper.font, c, 40, "ON", 1)
    else
        Renderer.DrawText(ArcHelper.font, c, 40, "OFF", 1)
    end
 
    end
 
 
function ArcHelper.isEnougthMana(myHero, ability)
    return NPC.GetMana(myHero) > Ability.GetManaCost(ability)
end
 
return ArcHelper