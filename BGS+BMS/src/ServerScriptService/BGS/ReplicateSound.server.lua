game:GetService("ReplicatedStorage").BGS_Engine.Events.PlaySound.OnServerEvent:Connect(function(player, sound: Sound, clone: boolean)
	for i,v in game:GetService("Players"):GetPlayers() do
		if v ~= player then
			game:GetService("ReplicatedStorage").BGS_Engine.Events.PlaySound:FireClient(v, sound, clone)
		end
	end
end)