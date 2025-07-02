local parachuteDeployed = false


function parachuteNextStep()
	if not parachuteDeployed then
		local parachute = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Parachute:Clone()
		parachute.Parent = script.Parent.Parent
		parachute:PivotTo(script.Parent.CFrame)
		script.Parent.BallSocketConstraint.Attachment1 = parachute.WeldPoint.Attachment
		parachute.Chute.Open:Play()
		parachuteDeployed = true
	else
		if script.Parent.Parent:FindFirstChild("Parachute") then
			local player =  game:GetService("Players"):GetPlayerFromCharacter(script.Parent.Parent)
			if player then
				if player.PlayerGui:FindFirstChild("ParachuteGUI") then
					player.PlayerGui.ParachuteGUI:Destroy()
				end
			end
			script.Parent.Parent:FindFirstChild("Parachute"):Destroy()
			script.Parent:Destroy()

		end
	end
end


script.Parent.ActivateParachute.OnServerEvent:Connect(parachuteNextStep)

script.Parent.ClickDetector.MouseClick:Connect(parachuteNextStep)