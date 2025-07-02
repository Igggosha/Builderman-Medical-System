game:GetService("RunService").Heartbeat:Connect(function()
	for i,v in workspace.Characters:GetDescendants() do
		if v:IsA("Configuration") and v.Name == "BGS_Client" and v:FindFirstChild("CarryValues") then
			local thisClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
			thisClient = v
			local thisCharacter: Model = thisClient.Parent
			
			if thisClient.CarryValues.Carrying.Value then
				local carriedCharacter: Model = thisClient.CarryValues.Carrying.Value
				carriedCharacter:PivotTo(thisCharacter.Torso.CFrame * CFrame.new( Vector3.new(2,1.5,0)) * CFrame.fromOrientation(math.rad(90),0,0)) --* CFrame.new(thisCharacter.Torso.CFrame:VectorToObjectSpace(Vector3.new(4,-4,0)))
				--carriedCharacter:PivotTo(thisCharacter.Torso.CFrame * CFrame.new(thisCharacter.Torso.CFrame:VectorToObjectSpace(Vector3.new(0,0,-5))))
			end
		end
	end
end)