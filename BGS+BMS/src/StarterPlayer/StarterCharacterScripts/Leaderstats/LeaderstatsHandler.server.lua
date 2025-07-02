local character: Model = script.Parent.Parent

local humanoid: Humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid")

humanoid.Died:Connect(function()
	
	if game:GetService("Players"):GetPlayerFromCharacter(character) then
		game:GetService("Players"):GetPlayerFromCharacter(character).leaderstats.Deaths.Value += 1
	else
		return
	end
	
	if humanoid:GetAttribute("LastDamagedBy") then
		local otherPlayer = game:GetService("Players"):FindFirstChild(humanoid:GetAttribute("LastDamagedBy"))
		if otherPlayer and otherPlayer ~= game:GetService("Players"):GetPlayerFromCharacter(character) then
			otherPlayer.leaderstats.Kills.Value += 1
		end
	end
end)