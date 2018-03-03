local Roshan = {}
Roshan.Font = Renderer.LoadFont("Arial", 15, Enum.FontWeight.BOLD)
Roshan.NotifierText = ""
Roshan.AegisTime = 0
Roshan.NextTime = 0
time = 0
timedraw = 0

function Roshan.OnUpdate()
    time = os.clock()
    if time > timedraw then
        timedraw = 0
    end
end

function Roshan.OnUnitAnimation(animation)
    if not animation then return end
    local sqname = tostring(animation.sequenceName)

    if sqname == "roshan_attack" or sqname == "roshan_attack2" then
        timedraw = os.clock() + 5
    end
end

function Roshan.OnChatEvent(chatEvent)
	if not Engine.IsInGame then return end
	if chatEvent.type ~= 9 then return end
	if chatEvent.value ~= 150 then return end
	local time = ( GameRules.GetGameTime() - GameRules.GetGameStartTime() )
	Roshan.AegisTime = time + 300
	Roshan.NotifierText = math.floor(time / 60) .. ":" .. math.floor(time % 60)
end

function Roshan.OnDraw()
	if Heroes.GetLocal() == nil then 
		Roshan.NotifierText = ""
		Roshan.AegisTime = 0
	return end
	if timedraw ~= 0 then 
		local w, h = Renderer.GetScreenSize()
		local c = math.floor(w / 2)
		local size = 60
		Renderer.SetDrawColor(29, 32, 39, 100)
		Renderer.DrawFilledRect(c - (size / 2), math.floor(h * 0.00), size, 24)
		Renderer.SetDrawColor(0, 0, 0, 200)
		Renderer.DrawFilledRect(c - ((size / 2) - 2), math.floor(h * 0.065) + 2, size - 4, 20)
		Renderer.SetDrawColor(255, 255, 255, 255)
		Renderer.DrawTextCentered(Roshan.Font, c, math.floor(h * 0.065) + 11, "ROSHAN", 1)
		Renderer.SetDrawColor(255, 0, 0, 150)
		Renderer.DrawFilledRect(c - ((size / 2) - 2), math.floor(h * 0.065) + 22, size - 4, 2)
	end
	if Roshan.NotifierText == "" then return end

	local w, h = Renderer.GetScreenSize()
	local c = math.floor(w / 2)
	local size = 60
	local drawText = Roshan.NotifierText

	if Roshan.AegisTime ~= 0
	then 
		local time = ( GameRules.GetGameTime() - GameRules.GetGameStartTime() )
		local dif = Roshan.AegisTime - time
		if dif <= 0 then Roshan.AegisTime = 0 return end
		size = 80
		local sec = math.floor(dif % 60)
		if sec < 10 then sec = "0" .. sec end
		drawText = drawText .. " [" .. math.floor(dif / 60) .. ":" .. sec .. "]" 
	end
	
	Renderer.SetDrawColor(29, 32, 39, 100)
	Renderer.DrawFilledRect(c - (size / 2), math.floor(h * 0.04), size, 24)
	
	Renderer.SetDrawColor(0, 0, 0, 200)
	Renderer.DrawFilledRect(c - ((size / 2) - 2), math.floor(h * 0.04) + 2, size - 4, 20)
	
	Renderer.SetDrawColor(255, 255, 255, 255)
	Renderer.DrawTextCentered(Roshan.Font, c, math.floor(h * 0.04) + 11, drawText, 1)
	Renderer.SetDrawColor(255, 0, 0, 150)
	Renderer.DrawFilledRect(c - ((size / 2) - 2), math.floor(h * 0.04) + 22, size - 4, 2)
end

return Roshan