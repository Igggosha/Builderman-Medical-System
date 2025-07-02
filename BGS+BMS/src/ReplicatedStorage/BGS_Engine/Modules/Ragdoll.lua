local Ragdoll = {}
local TS = game:GetService("TweenService")

function Ragdoll.Ragdoll(character: Model)
	if game:GetService("RunService"):IsClient() then return end
	
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	
	if humanoid then
		humanoid.PlatformStand = true
		humanoid.AutoRotate = false
	end
	local LHip: Motor6D = character.Torso:FindFirstChild("Left Hip")
	local RHip: Motor6D = character.Torso:FindFirstChild("Right Hip")
	local rootJoint: Motor6D = character.HumanoidRootPart:FindFirstChild("RootJoint")
	
	if LHip then
		TS:Create(LHip, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {C1 = LHip.C1 * CFrame.fromOrientation(0,0,math.rad(45))}):Play()
	end
	if RHip then
		TS:Create(RHip, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {C1 = RHip.C1 * CFrame.fromOrientation(0,0,math.rad(-45))}):Play()
	end
	if rootJoint then
		TS:Create(rootJoint, TweenInfo.new(0.05), {C1 = CFrame.new(0,0,0) * CFrame.fromOrientation(math.rad(-70), math.rad(-180), 0)}):Play()
	end
	wait(.05)
	
	for _, p in character:GetDescendants() do
		if p:IsA("Motor6D") and p.Enabled and p.Name ~= "RootJoint" and (not p:FindFirstAncestorWhichIsA("Tool")) then
			p.Enabled = false
			if p.Parent:FindFirstChild(p.Name.." Ball") then
				
				p.Parent:FindFirstChild(p.Name.." Ball").Enabled = true
			else
				local a0 = Instance.new("Attachment")
				a0.Parent = p.Part0
				a0.CFrame = p.C0
				
				local a1 = Instance.new("Attachment")
				a1.Parent = p.Part1
				a1.CFrame = p.C1
				
				local ball = Instance.new("BallSocketConstraint")
				ball.Parent = p.Parent
				ball.Name = p.Name.." Ball"
				ball.Attachment0 = a0
				ball.Attachment1 = a1
				
				if p.Part1.Name == "Head" then
					ball.LimitsEnabled = true
					ball.UpperAngle = 70
				end
				
			end
		
		elseif (p.Name == "Left Arm" or p.Name == "Right Arm" or p.Name == "Left Leg" or p.Name == "Right Leg") and p:IsA("BasePart") then
			if p.Parent:FindFirstChild(p.Name.."CoverPart") then
				p.Parent:FindFirstChild(p.Name.."CoverPart").CanCollide = true
			else
				local cover = Instance.new("Part")
				cover.Size = p.Size
				cover.CFrame = p.CFrame
				cover.Name = p.Name.."CoverPart"
				cover.Parent = p.Parent
				local weld = Instance.new("WeldConstraint")
				weld.Parent = cover
				weld.Part0 = cover
				weld.Part1 = p
				cover.Transparency = 1
			end
		elseif (p.Name == "Head") and p:IsA("BasePart") then
			if p.Parent:FindFirstChild(p.Name.."CoverPart") then
				p.Parent:FindFirstChild(p.Name.."CoverPart").CanCollide = true
			else
				local cover = Instance.new("Part")
				cover.Size = p.Size - Vector3.new(0.2,0.2,0.2)
				cover.Shape = Enum.PartType.Ball
				cover.CFrame = p.CFrame
				cover.Name = p.Name.."CoverPart"
				cover.Parent = p.Parent
				local weld = Instance.new("WeldConstraint")
				weld.Parent = cover
				weld.Part0 = cover
				weld.Part1 = p
				cover.Transparency = 1
			end
		end
	end
	
	if LHip then
		LHip.C1 = CFrame.new(-0.5,1,0) * CFrame.fromOrientation(0, math.rad(-90), 0)
	end
	if RHip then
		RHip.C1 = CFrame.new(0.5,1,0) * CFrame.fromOrientation(0, math.rad(90), 0)
	end
end

function Ragdoll.Unragdoll(character: Model)
	if game:GetService("RunService"):IsClient() then return end
	
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
	end
	
	for _, p in character:GetDescendants() do
		if p:IsA("BallSocketConstraint") and p.Enabled then
			p.Enabled = false
		elseif p:IsA("Motor6D") and not p.Enabled then
			p.Enabled = true
		end
		
		if (p.Name == "Left ArmCoverPart" or p.Name == "Right ArmCoverPart" or p.Name == "Left LegCoverPart" or p.Name == "Right LegCoverPart" or p.Name == "HeadCoverPart") and p:IsA("BasePart") then
			p.CanCollide = false
		end
	end
	
	local LHip: Motor6D = character.Torso:FindFirstChild("Left Hip")
	local RHip: Motor6D = character.Torso:FindFirstChild("Right Hip")
	local rootJoint: Motor6D = character.HumanoidRootPart:FindFirstChild("RootJoint")
	
	if LHip then
		LHip.C1 = CFrame.new(-0.5,1,0) * CFrame.fromOrientation(0, math.rad(-90), 0)
	end
	if RHip then
		RHip.C1 = CFrame.new(0.5,1,0) * CFrame.fromOrientation(0, math.rad(90), 0)
	end
	if rootJoint then
		rootJoint.C1 = CFrame.new(0,0,0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0)
	end
end
	
return Ragdoll
