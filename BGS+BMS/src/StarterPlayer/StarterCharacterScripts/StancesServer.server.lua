local stances = {
	Standing = 1,
	Crouching = 2,
	Prone = 3
}
local TS = game:GetService("TweenService")

script.RemoteEvent.OnServerEvent:Connect(function(player, stance: number)
	if player ~= game:GetService("Players"):GetPlayerFromCharacter(script.Parent) then
		player:Kick("Shut up 走开，这里不欢迎你，你很恶心 (Biden blast)")
	end
	
	local neck: Motor6D = player.Character.Torso:FindFirstChild("Neck")
	local rootjoint: Motor6D = player.Character.HumanoidRootPart:FindFirstChild("RootJoint")
	local LH: Motor6D = player.Character.Torso:FindFirstChild("Left Hip")
	local RH: Motor6D = player.Character.Torso:FindFirstChild("Right Hip")
	
	if stance == stances.Standing then
		if neck then
			TS:Create(neck, TweenInfo.new(0.4), {C1 = CFrame.new(0, -0.5, 0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0)}):Play()
		end
		if rootjoint then
			TS:Create(rootjoint, TweenInfo.new(0.4),{C1 = CFrame.new(0, 0, 0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0)}):Play()
		end
		if LH then
			TS:Create(LH, TweenInfo.new(0.4), {C1 = CFrame.new(-0.5, 1, 0) * CFrame.fromOrientation(math.rad(0), math.rad(-90), 0)}):Play()
		end
		if RH then
			TS:Create(RH, TweenInfo.new(0.4), {C1 = CFrame.new(0.5, 1, 0) * CFrame.fromOrientation(math.rad(0), math.rad(90), 0)}):Play()
		end
	elseif stance == stances.Crouching then
		if neck then
			TS:Create(neck, TweenInfo.new(0.4), {C1 = CFrame.new(0, -0.5, 0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0)}):Play()
		end
		if rootjoint then
			TS:Create(rootjoint, TweenInfo.new(0.4), {C1 = CFrame.new(0, 1, 0) * CFrame.fromOrientation(math.rad(-90), math.rad(-180), 0)}):Play()
		end
		if LH then
			TS:Create(LH, TweenInfo.new(0.4), {C1 = CFrame.new(-0.5, 0, 0.2) * CFrame.fromOrientation(math.rad(0), math.rad(-90), math.rad(-30))}):Play()
		end
		if RH then
			TS:Create(RH, TweenInfo.new(0.4), {C1 = CFrame.new(0.5, 0, 0.2) * CFrame.fromOrientation(math.rad(0), math.rad(90), math.rad(30))}):Play()
		end
	elseif stance == stances.Prone then
		if neck then
			TS:Create(neck, TweenInfo.new(0.4), {C1 = CFrame.new(0, -0.5, 0) * CFrame.fromOrientation(math.rad(0), math.rad(180), 0)}):Play()
		end
		if rootjoint then
			TS:Create(rootjoint, TweenInfo.new(0.4),{C1 = CFrame.new(0, 0, 2.5) * CFrame.fromOrientation(math.rad(0), math.rad(0), math.rad(180))}):Play()
		end
		if LH then
			TS:Create(LH, TweenInfo.new(0.4), {C1 = CFrame.new(-0.5, 1, 0) * CFrame.fromOrientation(math.rad(0), math.rad(-90), 0)}):Play()
		end
		if RH then
			TS:Create(RH, TweenInfo.new(0.4), {C1 = CFrame.new(0.5, 1, 0) * CFrame.fromOrientation(math.rad(0), math.rad(90), 0)}):Play()
		end
	end
end)