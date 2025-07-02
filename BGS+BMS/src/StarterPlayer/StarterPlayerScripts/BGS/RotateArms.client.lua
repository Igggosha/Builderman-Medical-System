local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

function rotateJoints(player: Player, mousePos: Vector3, ry: number)
	local LS: Motor6D = player.Character.Torso:FindFirstChild("Left Shoulder")
	local RS: Motor6D = player.Character.Torso:FindFirstChild("Right Shoulder")
	local neck: Motor6D = player.Character.Torso:FindFirstChild("Neck")

	local hit = (player.Character.Torso.Position.Y - mousePos.Y)/100
	local mag = (player.Character.Torso.Position - mousePos).Magnitude/100
	local offset = hit/mag

	if LS then
		if player.Character:FindFirstChildWhichIsA("Tool") then
			LS.C0 = LS.C0:Lerp(CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0) * CFrame.fromEulerAnglesXYZ(0, 0, offset),0.5)
		else
			LS.C0 = CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
		end
	end
	if RS then
		if player.Character:FindFirstChildWhichIsA("Tool") then
			RS.C0 = RS.C0:Lerp(CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0) * CFrame.fromEulerAnglesXYZ(0, 0, -offset),0.5)
		else
			RS.C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
		end
	end


	if neck then		
		neck.C0 = CFrame.new(0, 1, 0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0) * CFrame.fromOrientation(-ry, 0, 0)
	end
end

game:GetService("RunService").PreRender:Connect(function()

	if (not player.Character) or (not player.Character:FindFirstChild("Torso")) then return end
	
	local mousePos = mouse.Hit.Position
	local ry, rx, rz = camera.CFrame:ToEulerAnglesYXZ()
	game:GetService("ReplicatedStorage").BGS_Engine.Events.UpdateLookDirection:FireServer(mouse.Hit.Position, ry)

	rotateJoints(player, mousePos, ry)
end)

game:GetService("ReplicatedStorage").BGS_Engine.Events.UpdateLookDirection.OnClientEvent:Connect(function(player, mousePos, ry)
	rotateJoints(player, mousePos, ry)
end)