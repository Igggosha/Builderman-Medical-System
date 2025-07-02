script.Parent["Hev Charger"].body.ProximityPrompt.Triggered:Connect(function(player)
	if not script.Parent["Hev Charger"].body.charger.Playing then
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		client = player.Character:FindFirstChild("BGS_Client")
		
		if not client then return end
		
		client.Kit.Bloodbag.Value = math.max(client.Kit.Bloodbag.Value, 1)
		client.Kit.Caffeine.Value = math.max(client.Kit.Caffeine.Value, 3)
		client.Kit.Defibrillator.Value = true
		client.Kit.Epinephrine.Value = math.max(client.Kit.Epinephrine.Value, 3)
		client.Kit.Gauze.Value = math.max(client.Kit.Bloodbag.Value, 5)
		client.Kit.Morphine.Value = math.max(client.Kit.Morphine.Value, 3)
		client.Kit.Painkiller.Value = math.max(client.Kit.Painkiller.Value, 10)
		client.Kit.PlasticCover.Value = math.max(client.Kit.PlasticCover.Value, 3)
		client.Kit.Splint.Value = math.max(client.Kit.Splint.Value, 2)
		client.Kit.SutureKit.Value = math.max(client.Kit.SutureKit.Value, 3)
		client.Kit.Tourniquet.Value = math.max(client.Kit.Tourniquet.Value, 3)
		
		script.Parent["Hev Charger"].body.charger:Play()
	end
end)