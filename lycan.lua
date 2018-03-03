local lycan = {}

lycan.ComboKey = Menu.AddKeyOption({"Hero Specific", "lycan"}, "Combo Key", Enum.ButtonCode.KEY_NONE)
lycan.Font = Renderer.LoadFont("Tahoma", 24, Enum.FontWeight.EXTRABOLD)
lycan.Attacking = false
lycan.AttackingTarget = nil
time = 0
delay = 0
delayq = 0

function lycan.OnUpdate()
    local myHero = Heroes.GetLocal()
    if not myHero then return end
    if not NPC.GetUnitName(myHero) == "npc_dota_hero_lycan" then return end
    time = os.clock()
    
    if Menu.IsKeyDownOnce(lycan.ComboKey) then
        if not lycan.Attacking then
            lycan.Attacking = true
            lycan.AttackingTarget = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
        else
            lycan.Attacking = not lycan.Attacking
            if not lycan.Attacking then
                lycan.AttackingTarget = nil
            end
        end
    end
    
    if lycan.AttackingTarget then
        if lycan.AttackingTarget then
            if not Entity.IsAlive(lycan.AttackingTarget) or Entity.IsDormant(lycan.AttackingTarget) then
                lycan.AttackingTarget = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
            end
        end
    end
    
    if time > delayq then
        lycan.AutoRaiseDead()
        delayq = os.clock() + 0.2
    end
    if lycan.Attacking and time > delay then
        lycan.AttackTarget(lycan.AttackingTarget)
        delay = os.clock() + 0.5
    end
end

function lycan.AttackTarget(enemy)
    local myHero = Heroes.GetLocal()
            for _, npc in ipairs(NPC.GetUnitsInRadius(myHero, 99999, Enum.TeamType.TEAM_FRIEND)) do
                if Entity.IsAlive(npc) and not Entity.IsDormant(npc) and Entity.GetHealth(npc) and (Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero)) then
                    for _, ability in ipairs(lycan.Abilities) do
                            if NPC.HasAbility(npc, ability) and Ability.IsCastable(NPC.GetAbility(npc, ability), NPC.GetMana(npc)) and Ability.IsReady(NPC.GetAbility(npc, ability)) and not Ability.IsInAbilityPhase(NPC.GetAbility(npc, ability)) and not NPC.IsLinkensProtected(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
                                if Ability.GetCastRange(NPC.GetAbility(npc, ability)) > 0 then
                                    if ability == "satyr_hellcaller_shockwave" then
                                        if NPC.HasAbility(npc, ability) and Ability.IsCastable(NPC.GetAbility(npc, ability), NPC.GetMana(npc)) and Ability.IsReady(NPC.GetAbility(npc, ability)) and not Ability.IsInAbilityPhase(NPC.GetAbility(npc, ability)) and NPC.IsEntityInRange(npc, enemy, 900) then
                                            Ability.CastTarget(NPC.GetAbility(npc, ability), enemy)
                                        end
                                        return
                                    end
                                    if ability == "spawnlord_master_freeze" or ability == "dark_troll_warlord_ensnare" or ability == "mud_golem_hurl_boulder" then
                                        if NPC.IsEntityInRange(npc, enemy, Ability.GetCastRange(NPC.GetAbility(npc, ability)) + NPC.GetCastRangeBonus(npc)) then
                                            Ability.CastTarget(NPC.GetAbility(npc, ability), enemy)
                                            return
                                        end
                                    end
                                    if ability == "necronomicon_archer_purge" then
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
                                            Ability.CastTarget(NPC.GetAbility(npc, ability), enemy)
                                            return
                                        end
                                    end
                                    if ability == "satyr_trickster_purge" then
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
                                        Ability.CastTarget(NPC.GetAbility(npc, ability), enemy)
                                        return
                                    else
                                        Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(enemy), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
                                    end
                                    end
                                end
                            end
                    end
                if NPC.HasAbility(npc, "centaur_khan_war_stomp") then
                    local clap = NPC.GetAbility(npc, "centaur_khan_war_stomp")
                    if NPC.IsEntityInRange(npc, enemy, 150) and Ability.IsReady(clap) then
                        Ability.CastNoTarget(clap)
                        return
                    end
                end
                if NPC.HasAbility(npc, "polar_furbolg_ursa_warrior_thunder_clap") then
                    local clap = NPC.GetAbility(npc, "polar_furbolg_ursa_warrior_thunder_clap")
                    if NPC.IsEntityInRange(npc, enemy, 200) and Ability.IsReady(clap) then
                        Ability.CastNoTarget(clap)
                        return
                    end
                end
                if enemy then
                    if not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_ATTACK_IMMUNE) then
                        for i = 1, NPCs.Count() do
                            local npc = NPCs.Get(i)
                            if Entity.GetHealth(npc) > 0 and Entity.IsSameTeam(myHero, npc) and (Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero)) and npc ~= myHero and NPC.GetUnitName(npc) ~= "npc_dota_courier" then
                            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, enemy, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
                            end
                        end
                    else
                        for i = 1, NPCs.Count() do
                            local npc = NPCs.Get(i)
                            if Entity.GetHealth(npc) > 0 and Entity.IsSameTeam(myHero, npc) and (Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero)) and npc ~= myHero and NPC.GetUnitName(npc) ~= "npc_dota_courier" then
                              Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(enemy), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
                            end
                        end
                    end
                end
            end
        end
end


function lycan.OnDraw()
    local myHero = Heroes.GetLocal()
    if not myHero then return end

    if NPC.GetUnitName(myHero) == "npc_dota_hero_lycan" then 
        local w, h = Renderer.GetScreenSize()
        local c = math.floor(w / 2.2)
        if lycan.Attacking then 
          Renderer.SetDrawColor(255, 255, 255, 255)
          Renderer.DrawText(lycan.Font, c, 40, "ON", 1)
        else
          Renderer.SetDrawColor(255, 255, 255, 255)
          Renderer.DrawText(lycan.Font, c, 40, "OFF", 1)
        end
    end
end

function lycan.AutoRaiseDead()
    local myHero = Heroes.GetLocal()
      for i = 1, NPCs.Count() do
        local npc = NPCs.Get(i)
        if Entity.GetOwner(myHero) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, myHero) then
          if NPC.HasAbility(npc, "dark_troll_warlord_raise_dead") and Entity.IsAlive(npc) then
            local RaiseDead = NPC.GetAbility(npc, "dark_troll_warlord_raise_dead")
            local npcMana = NPC.GetMana(npc)
            local npcLocation = NPC.GetAbsOrigin(npc) 
            if Ability.IsReady(RaiseDead) and Ability.IsCastable(RaiseDead, npcMana) and not Ability.IsInAbilityPhase(RaiseDead) and Ability.GetCooldownTimeLeft(RaiseDead) == 0.0 then
              for i = 1, NPCs.Count() do
                local npc = NPCs.Get(i)
                if Entity.GetHealth(npc) <= 0 and not Entity.IsDormant(npc) and (NPC.GetAbsOrigin(npc)-npcLocation):Length2D() < 500 then -- change to 550 if no problems?
                  Ability.CastNoTarget(RaiseDead)
                  break
                end
              end
            end
          end
        end
    end
end

lycan.Abilities = {
    "forest_troll_high_priest_heal",
    "harpy_storm_chain_lightning",
    "centaur_khan_war_stomp",
    "satyr_trickster_purge",
    "satyr_soulstealer_mana_burn",
    "ogre_magi_frost_armor",
    "mud_golem_hurl_boulder",
    "satyr_hellcaller_shockwave",
    "polar_furbolg_ursa_warrior_thunder_clap",
    "enraged_wildkin_tornado",
    "dark_troll_warlord_ensnare",
    "dark_troll_warlord_raise_dead",
    "black_dragon_fireball",
    "big_thunder_lizard_slam",
    "big_thunder_lizard_frenzy",
    "spawnlord_master_stomp",
    "spawnlord_master_freeze",
    "necronomicon_archer_purge"
}

return lycan