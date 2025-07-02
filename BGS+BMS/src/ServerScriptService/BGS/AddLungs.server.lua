game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		local lungs = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Lungs:Clone()
		lungs.Parent = character
		lungs.CFrame = character.Torso.CFrame * CFrame.new(0,0.2,0)
		lungs.WeldConstraint.Part1 = character.Torso
	end)
end)