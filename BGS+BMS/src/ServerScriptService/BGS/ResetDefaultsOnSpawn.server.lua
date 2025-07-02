game:GetService("Players").PlayerAdded:Connect(function(player)
	local humanoid
	
	player.CharacterAdded:Connect(function(character)
		humanoid = character:FindFirstChildWhichIsA("Humanoid")
		
		
		
		humanoid.Died:Connect(function()
			if character:FindFirstChildWhichIsA("Tool") then character:FindFirstChildWhichIsA("Tool").Parent = player.Backpack end
		end)
	end)
	
end)


game:GetService("ReplicatedStorage").BGS_Engine.Events.Die.OnServerEvent:Connect(function(player)
	player.Character.Humanoid:TakeDamage(100)
	
end)