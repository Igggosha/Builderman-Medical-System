game.Players.PlayerAdded:connect(function(player)
	player.CharacterAdded:connect(function(character)
		local fallImpactScript = script.Impact:clone()
		fallImpactScript.Parent = character
		fallImpactScript.Disabled = false
	end)
end)
