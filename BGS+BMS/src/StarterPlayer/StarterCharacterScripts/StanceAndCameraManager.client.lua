local camera = workspace.CurrentCamera
local player = game:GetService("Players").LocalPlayer
local walkingMultiplier = 0
local calmMultiplier = 1

local JumpVector = Instance.new("Vector3Value")
JumpVector.Value = Vector3.new(0,0,0)

local TS = game:GetService("TweenService")

local SpringModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Spring)
local cameraSpring = SpringModule.new(0.01,20,2,0,0,0)
local cameraSpringHorizontal = SpringModule.new(0.01,20,2,0,0,0)

local cameraAffectorVector = Instance.new("Vector3Value") 
cameraAffectorVector.Value = Vector3.new(0,0,0)

local cameraPosObject = Instance.new("CFrameValue")
cameraPosObject.Parent = camera
cameraPosObject.Name = "trueCFrame"

game:GetService("RunService"):BindToRenderStep("SetupCameraCFrame", 2000, function(delta: number)
	--print(time())
	--camera.CFrame *= CFrame.new(0,10,0)
	--camera.CFrame:Lerp(
	--print(cameraSpring)
	if player.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then return end
	
	local charspeed = math.min(math.round(player.Character.Torso.AssemblyLinearVelocity.Magnitude / 12 * 100) / 100,2)
	--print(charspeed)
	
	camera.CFrame = camera.CFrame:Lerp(camera.CFrame * CFrame.fromOrientation(
		math.abs( math.sin(time()*0.5)/1000 * calmMultiplier + math.sin(time()*3 * charspeed )/200 * walkingMultiplier) - 0.2 * math.pi / 200 * walkingMultiplier - 0.2 * math.pi /1000 * calmMultiplier + cameraSpring.Offset*1.5 * delta * 60 , 
		math.cos(time()*3 * charspeed ) * walkingMultiplier / 400 + cameraSpringHorizontal.Offset*1.5 ,
		0), 0.2)
	camera.CFrame *= (CFrame.new(0,math.sin(time()*2)/15, 0) * CFrame.new(camera.CFrame:VectorToObjectSpace(cameraAffectorVector.Value)))
	--print(walkingMultiplier)
	
	
	if charspeed > 0 then
		if walkingMultiplier < charspeed then
			walkingMultiplier += delta * 20
		elseif walkingMultiplier > charspeed then
			walkingMultiplier = charspeed
		end
		if calmMultiplier > 0 then
			calmMultiplier -= delta*20
		elseif calmMultiplier < 0 then
			calmMultiplier = 0
		end
	else
		if walkingMultiplier > 0 then
			walkingMultiplier -= delta * 20
		else
			walkingMultiplier = 0
		end
		if calmMultiplier < 1 then
			calmMultiplier += delta*20
		elseif calmMultiplier > 1 then
			calmMultiplier = 1
		end
	end
	
	cameraPosObject.Value = camera.CFrame
end)


script.Jump.Event:Connect(function(value: Vector3)
	
	--cameraSpring:AddVelocity(value.Y)
	
	cameraSpring:AddVelocity(value.Y + math.abs(cameraSpring.Velocity) * 2.3)
	cameraSpringHorizontal:AddVelocity(value.X)
	print(cameraSpring.Velocity )
	--if not JumpTween then
	--	JumpTween = TS:Create(JumpVector, TweenInfo.new(duration, Enum.EasingStyle.Back), {Value = value})
	--else
	--	JumpTween.
	--end
	
end)

local stances = {
	Standing = 1,
	Crouching = 2,
	Prone = 3
}
local stanceImageIDs = {
	Standing = 'rbxthumb://type=Asset&id=17869273231&w=420&h=420',
	Crouching = 'rbxthumb://type=Asset&id=17869274616&w=420&h=420',
	Prone = 'rbxthumb://type=Asset&id=17869275523&w=420&h=420'
}
local stance = stances.Standing

game:GetService("UserInputService").InputBegan:Connect(function(input, ignore)
	if ignore or player.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then return end
	
	
	if input.KeyCode == Enum.KeyCode.C then
		if stance < stances.Prone then stance += 1 end
		script.Parent.StancesServer.RemoteEvent:FireServer(stance)
	elseif input.KeyCode == Enum.KeyCode.X then
		if stance > stances.Standing then stance -= 1 end
		script.Parent.StancesServer.RemoteEvent:FireServer(stance)
	else 
		return
	end
	
	
	if stance == stances.Standing then
		TS:Create(cameraAffectorVector, TweenInfo.new(0.4), {Value = Vector3.new(0,0,0)}):Play()
		player.PlayerGui.BGS_GUI.PersonIndicator.Indicator.Image = stanceImageIDs.Standing
	elseif stance == stances.Crouching then
		TS:Create(cameraAffectorVector, TweenInfo.new(0.4), {Value = Vector3.new(0,-1,0)}):Play()
		player.PlayerGui.BGS_GUI.PersonIndicator.Indicator.Image = stanceImageIDs.Crouching
	elseif stance == stances.Prone then
		TS:Create(cameraAffectorVector, TweenInfo.new(0.4), {Value = Vector3.new(0,-2.5,0)}):Play()
		player.PlayerGui.BGS_GUI.PersonIndicator.Indicator.Image = stanceImageIDs.Prone
	end
	
	script.Stance.Value = stance
end)