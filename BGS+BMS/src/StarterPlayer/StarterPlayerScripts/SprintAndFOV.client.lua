local moving = false
local sprinting = false
local camera = workspace.CurrentCamera
local TS = game:GetService("TweenService")
local oldFOV = 70
local player = game:GetService("Players").LocalPlayer

local map = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Map)

local sprintAffector = Instance.new("NumberValue")
sprintAffector.Name = "SprintAffector"
sprintAffector.Parent = script

game:GetService("UserInputService").InputBegan:Connect(function(input, ignore)
	if ignore then return end
	
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
		moving = true
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		if player.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then return end
		sprinting = true
		
		TS:Create(sprintAffector, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Value = 14}):Play()
		
		local client = player.Character:FindFirstChild("BGS_Client")
		if not client then return end
		
		client.SetSprint:FireServer(true)
	elseif input.KeyCode == Enum.KeyCode.Space and (not player.Character:FindFirstChildWhichIsA("Tool")) then
		camera.CameraType = Enum.CameraType.Custom
		
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, ignore)
	if ignore then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		moving = false
		sprinting = false
		
		TS:Create(sprintAffector, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Value = 0}):Play()

		local client = player.Character:FindFirstChild("BGS_Client")
		if not client then return end
		
		
		
		client.SetSprint:FireServer(false)
	end
end)



game:GetService("RunService").RenderStepped:Connect(function(delta)
	if (not player) or (not player.Character) then return end
	
	local client = player.Character:FindFirstChild("BGS_Client")
	if not client then return end
	local legBreakModifier = 0
	
	if client:GetAttribute("LeftLegBroken") and not client:GetAttribute("LeftLegSplint") then
		legBreakModifier += 5
	end
	if client:GetAttribute("RightLegBroken") and not client:GetAttribute("RightLegSplint") then
		legBreakModifier += 5
	end
	
	local stanceModifier = (player.Character.StanceAndCameraManager.Stance.Value - 1) * 3
	local surrenderModifier = 0
	
	if client:GetAttribute("Surrendered") then
		surrenderModifier = 5
	end
	
	
	if script.NoWalk.Value then
		player.Character:FindFirstChildWhichIsA('Humanoid').WalkSpeed = 0
	else
	
		if sprinting then
			

			player.Character:FindFirstChildWhichIsA('Humanoid').WalkSpeed = math.max(20 - legBreakModifier - surrenderModifier - stanceModifier + map.map(client.AppliedMedication.AmountOfCaffeine.Value, 0, 1000, 0, 15), 2)

		else


			player.Character:FindFirstChildWhichIsA('Humanoid').WalkSpeed = math.max(12 - legBreakModifier - surrenderModifier - stanceModifier + map.map(client.AppliedMedication.AmountOfCaffeine.Value, 0, 1000, 0, 10), 2)
			
			
		end
	end
	
	if not player.Character:FindFirstChild("Drone") then
		camera.FieldOfView = 70 - script.AimAffector.Value + sprintAffector.Value
	end
end)

player.CharacterAdded:Connect(function()
	script.AimAffector.Value = 0
end)