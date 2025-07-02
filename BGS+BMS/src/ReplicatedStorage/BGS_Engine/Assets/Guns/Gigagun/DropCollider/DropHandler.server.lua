local tool = script.Parent.Parent

script.Parent.Drop.OnServerEvent:Connect(function(player)
	--if player.Character ~= script.Parent.Parent.Parent then return end
	if script.Parent.Parent.Parent:IsA("Model") then 
		script.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid"):UnequipTools()
	end
	local backpack: Backpack = tool.Parent
	local player: Player = backpack.Parent

	script.Parent.CanCollide = true
	tool.Parent = workspace.BGS.DroppedTools
	tool:MoveTo(player.Character.Head.Position + Vector3.new(0,1,0))

	script.Parent.ProximityPrompt.Enabled = true
end)

script.Parent.ProximityPrompt.Triggered:Connect(function(player)
	tool.Parent = player.Backpack
	script.Parent.CanCollide = false
	script.Parent.ProximityPrompt.Enabled = false
end)