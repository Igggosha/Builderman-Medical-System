game:GetService("Players").PlayerAdded:Connect(function(player)
	script.leaderstats:Clone().Parent = player
end)