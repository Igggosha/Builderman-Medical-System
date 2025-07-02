game:GetService("ReplicatedStorage").BGS_Engine.Events.UpdateLookDirection.OnServerEvent:Connect(function(player, mousePos, ry)
	for i,v in game:GetService("Players"):GetPlayers() do
		if v ~= player then
			game:GetService("ReplicatedStorage").BGS_Engine.Events.UpdateLookDirection:FireClient(v, player, mousePos, ry)
		end
	end
end)

