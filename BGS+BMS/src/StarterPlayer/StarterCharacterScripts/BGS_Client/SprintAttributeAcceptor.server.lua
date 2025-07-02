script.Parent.SetSprint.OnServerEvent:Connect(function(player: Player, value: boolean)
	if player.Character == script.Parent.Parent then
		script.Parent:SetAttribute("Sprinting", value)
	end
end)