local event = game:GetService("ReplicatedStorage").BGS_Engine.Events.Surrender

event.OnServerEvent:Connect(function(player, action, target: Model)
	if action == "Surrender" then
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		client = player.Character:FindFirstChild("BGS_Client")
		client:SetAttribute("Surrendered", true)
		player.Character.BackpackEnabledManager.Surrendered.Value = true
	elseif action == "Liberate" then
		if (player.Character:GetPivot().Position - target:GetPivot().Position ).Magnitude > 20 then 
			return 
		end
		
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		client = target:FindFirstChild("BGS_Client")
		client:SetAttribute("Surrendered", false)		
		target.BackpackEnabledManager.Surrendered.Value = false
		
		local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(target)
		if not targetPlayer then return end
		
		event:FireClient(targetPlayer, "Liberated")
	
	end
end)