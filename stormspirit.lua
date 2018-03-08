
local storm_spirit = {}

storm_spirit.ComboKey = Menu.AddKeyOption({"Hero Specific", "storm"}, "Combo Key", Enum.ButtonCode.KEY_NONE)
storm_spirit.Font = Renderer.LoadFont("Tahoma", 24, Enum.FontWeight.EXTRABOLD)

storm_spirit.Attacking = false

function storm_spirit.OnUpdate()
	if Menu.IsKeyDownOnce(storm_spirit.ComboKey) then
        if not storm_spirit.Attacking then
            storm_spirit.Attacking = true
        else
            storm_spirit.Attacking = not storm_spirit.Attacking
        end
    end
end

function storm_spirit.OnProjectile(projectile)
    if not projectile.isAttack or not projectile.target or not Entity.IsHero(projectile.target) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if projectile.source ~= myHero then return end
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_storm_spirit" then return end
	target = projectile.target

	if not storm_spirit.Attacking then return end
	storm_spirit.Combo(myHero, target)
	storm_spirit.overload(myHero, target)
end

function storm_spirit.Combo(myHero, target)
	local myMana = NPC.GetMana(myHero)
	local Orchid  = NPC.GetItem(myHero, "item_orchid", true)
	local BloodThorn  = NPC.GetItem(myHero, "item_bloodthorn", true)
	local RoA = NPC.GetItem( myHero, "item_rod_of_atos", true)
	local Hex = NPC.GetItem(myHero, "item_sheepstick", true)
	local ForceStaff = NPC.GetItem(myHero, "item_force_staff", true)
	local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
	local Halberd = NPC.GetItem(myHero, "item_heavens_halberd", true)
	local Diffus = NPC.GetItem(myHero, "item_diffusal_blade", true)
	local nullif = NPC.GetItem(myHero, "item_nullifier", true)	 
	local vortex = NPC.GetAbility(myHero, "storm_spirit_electric_vortex")
	
			if NPC.IsEntityInRange(target, myHero, 700) and not NPC.HasModifier(target, "modifier_item_lotus_orb") and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
				if vortex and Ability.IsCastable(vortex, myMana) and NPC.IsEntityInRange(target, myHero, 450) and NPC.HasItem(myHero, "item_ultimate_scepter", true) then Ability.CastNoTarget(vortex) end
				if NPC.IsLinkensProtected(target) then
					if RoA and Ability.IsCastable(RoA, myMana) then Ability.CastTarget(RoA, target) end
					if Halberd and Ability.IsCastable(Halberd, myMana) then Ability.CastTarget(Halberd, target) end
					if hurrican and Ability.IsCastable(hurrican, myMana) then Ability.CastTarget(hurrican, target) end
					if ForceStaff and Ability.IsCastable(ForceStaff, myMana) then Ability.CastTarget(ForceStaff, target) end
					if Hex and Ability.IsCastable(Hex, myMana - 100) and Orchid and Ability.IsCastable(Orchid, myMana) then Ability.CastTarget(Orchid,target) Ability.CastTarget(Hex, target) end
					if Hex and Ability.IsCastable(Hex, myMana - 100) and BloodThorn and Ability.IsCastable(BloodThorn, myMana) then Ability.CastTarget(BloodThorn,target) Ability.CastTarget(Hex, target) end
				end
				if not NPC.IsLinkensProtected(target) then
					if vortex and Ability.IsCastable(vortex, myMana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) and NPC.IsEntityInRange(target, myHero, 300) and not NPC.HasItem(myHero, "item_ultimate_scepter", true) then Ability.CastTarget(vortex, target) end
					if Hex and Ability.IsCastable(Hex, myMana) and not NPC.IsStunned(target) then Ability.CastTarget(Hex, target) end
					if Orchid and Ability.IsCastable(Orchid, myMana) then Ability.CastTarget(Orchid,target) end
					if BloodThorn and Ability.IsCastable(BloodThorn, myMana) then Ability.CastTarget(BloodThorn,target) end
					if nullif and Ability.IsCastable(nullif, myMana) then Ability.CastTarget(nullif, target) end
					if RoA and Ability.IsCastable(RoA, myMana) then Ability.CastTarget(RoA, target) end
				end
			end
end

function storm_spirit.overload(myHero, target)
	local remnant = NPC.GetAbility(myHero, "storm_spirit_static_remnant")
	local ulti = NPC.GetAbility(myHero, "storm_spirit_ball_lightning")
	if not NPC.HasModifier(target, "modifier_storm_spirit_overload") then
		if remnant and Ability.IsReady(remnant) then
			Ability.CastNoTarget(remnant)
		elseif ulti and Ability.IsReady(ulti) then
			local heroPosition = NPC.GetAbsOrigin(myHero)
			local distance = storm_spirit.InFront(myHero, heroPosition)
			distance:SetZ(0)
			distance:Normalize()
			distance:Scale(1)
		
			local dir = heroPosition + distance
			Ability.CastPosition(ulti, dir)
		end
	end
end

function storm_spirit.OnDraw()
    local myHero = Heroes.GetLocal()
    if not myHero then return end

    if NPC.GetUnitName(myHero) == "npc_dota_hero_storm_spirit" then 
        local w, h = Renderer.GetScreenSize()
		local c = math.floor(w / 2.2)
        if storm_spirit.Attacking then 
          Renderer.SetDrawColor(255, 255, 255, 255)
          Renderer.DrawText(storm_spirit.Font, c, 40, "ON", 1)
        else
          Renderer.SetDrawColor(255, 255, 255, 255)
          Renderer.DrawText(storm_spirit.Font, c, 40, "OFF", 1)
        end
    end
end

function storm_spirit.InFront(myHero, heroPosition)
	local vec = Entity.GetRotation(myHero):GetVectors()
	if vec then
		local x = heroPosition:GetX() + vec:GetX()
		local y = heroPosition:GetY() + vec:GetY()
		return Vector(x,y,0)
	end
end

return storm_spirit