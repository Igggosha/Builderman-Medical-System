local head: Part = script.Parent.Parent:FindFirstChild("Head") or script.Parent.Parent:WaitForChild("Head")

local previousPainValue = 0

local hurtSounds: {Sound} = script.hurt:GetChildren()
local injuredSounds: {Sound} = script.injured:GetChildren()
local special: {Sound} = script.special:GetChildren()

for i,v in injuredSounds do
	v.Parent = head
end
for i,v in hurtSounds do
	v.Parent = head
end
for i,v in special do
	v.Parent = head
end


script.Parent.Vitals.Pain.Changed:Connect(function(newValue)
	if newValue - previousPainValue > 20 and not head:GetAttribute("yelling") then
		--print(script.Parent.Vitals.Pain.Value - previousPainValue)
		for i,v in hurtSounds do
			v:Stop()
		end
		hurtSounds[math.random(1, #hurtSounds)]:Play()
	end
	previousPainValue = newValue

	if script.Parent.Vitals.Pain.Value > 100 or script.Parent:GetAttribute("LeftArmBroken") or script.Parent:GetAttribute("RightArmBroken") or script.Parent:GetAttribute("RightLegBroken") or script.Parent:GetAttribute("LeftLegBroken") or script.Parent.Parent:FindFirstChild("Wound", true) then
		
		for i,v in injuredSounds do
			if v.Playing then return end
		end
		injuredSounds[math.random(1, #injuredSounds)]:Play()
	else
		for i,v in injuredSounds do
			v:Stop()
		end
	end


	
	
	
end)

script.Parent.Parent:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
	for i,v in hurtSounds do
		v:Stop()
		v:Destroy()
	end
	for i,v in injuredSounds do
		v:Stop()
		v:Destroy()
	end
	wait(1)
	script:Destroy()
end)