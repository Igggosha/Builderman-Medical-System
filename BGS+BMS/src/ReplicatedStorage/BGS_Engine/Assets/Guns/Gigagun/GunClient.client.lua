-- RPG7

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local firing = false
local firemode = "Safety"
local isEquipped = false
local jammed = false

local aiming = false
local RPM = 600
local timeWaited = 0

local bulletName = "BulletRPG"

local magSize = 88
local currentMag = 88

local currentAimingPos = 1
local aimingZooms = {
	50,
	70
}

local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local TS = game:GetService("TweenService")


local aimAnim: AnimationTrack
local reloadAnim: AnimationTrack

local VPaimAnim: AnimationTrack
local VPreloadAnim: AnimationTrack

local CFramePositionOffset = CFrame.new(0.5,0,-1)
local GunOffset = Instance.new("Vector3Value")
GunOffset.Value = Vector3.new(0.5,-0.3,-1.1)

local LArmOffset = Vector3.new(0,0,0)
local RArmOffset = Vector3.new(0,0,0)
--local ArmsOffset = Vector3.new(-0.3,0,1.75)


local arms
local viewgun
local springModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Spring)
local viewportArmsSpring = springModule.new(0.05,30,20,0,0,0)
local reloading = false

local idleAnimId = "rbxassetid://18634259694"
local reloadAnimId = "rbxassetid://18634375347"
local unjamAnimId = "rbxassetid://18398664196"
local aimAnimId = "rbxassetid://79170384571977"

local gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
local sprintAngle = Instance.new("NumberValue")
sprintAngle.Value = 40

local firingSound = script.Parent.Fire

function setArmProperties()
	if not arms then return end
	if player.Character:FindFirstChild("Left Arm") then
		arms["Left Arm"].Color = player.Character:FindFirstChild("Left Arm").Color
		arms["Left Arm"].Transparency = player.Character:FindFirstChild("Left Arm").Transparency

		--updateLeftArmAdditives()
	else
		arms["Left Arm"].Color = Color3.new(1, 1, 0)
		arms["Left Arm"].Transparency = 1
	end

	if player.Character:FindFirstChild("Right Arm") then
		arms["Right Arm"].Color = player.Character:FindFirstChild("Right Arm").Color
		arms["Right Arm"].Transparency = player.Character:FindFirstChild("Right Arm").Transparency

		--updateRightArmAdditives()
	else
		arms["Right Arm"].Color = Color3.new(1, 1, 0)
		arms["Right Arm"].Transparency = 1
	end
end

script.Parent.Equipped:Connect(function()
	sprintAngle.Value = 70
	gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
	isEquipped = true
	player.CameraMaxZoomDistance = 0
	script.Parent.Communications:FireServer("Equip")
	
	local animobj = Instance.new("Animation")
	animobj.AnimationId = idleAnimId
	aimAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	aimAnim.Priority = Enum.AnimationPriority.Action
	aimAnim:Play()
	
	viewgun = script.Parent:Clone()
	viewgun.Parent = camera
	viewgun.Name = "ViewportGun"
	viewgun.PrimaryPart = viewgun.AimPart
	viewgun:MoveTo(camera.CFrame.Position)
	
	for i,v in viewgun:GetDescendants() do
		if v:IsA("BasePart") then v.CanCollide = false end
	end
	
	
	arms = game:GetService("ReplicatedStorage").BGS_Engine.ViewportArms.Arms:Clone()
	arms.Parent = viewgun.Parent
	
	arms:PivotTo(camera.CFrame)
	--arms.HumanoidRootPart.RootWeld.Part1 =  viewgun.PrimaryPart
	arms["Left Arm"].CanCollide = false
	arms["Right Arm"].CanCollide = false
	arms.Torso.CanCollide = false
	
	
	viewgun.Parent = arms
	arms["Right Arm"].BodyAttach.Part1 = viewgun.Handle
	arms.PrimaryPart = viewgun.AimPart
	
	arms.Shirt.ShirtTemplate = player.Character:FindFirstChildWhichIsA("Shirt") and player.Character:FindFirstChildWhichIsA("Shirt").ShirtTemplate or ""
	setArmProperties()
	
	local animobj = Instance.new("Animation")
	animobj.AnimationId =  idleAnimId --"rbxassetid://17489259537"

	if VPaimAnim then
		VPaimAnim:Stop()
	end
	VPaimAnim = arms:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	VPaimAnim.Priority = Enum.AnimationPriority.Action
	VPaimAnim:Play()
	
	game:GetService("UserInputService").MouseIconEnabled = false
	
	
	gui.GunInfo.Visible = true
	
	script.Parent.Parent.BackpackEnabledManager.Reloading.Value = false
	reloading = false
end)

player.Character:WaitForChild("Right Arm").Changed:Connect(setArmProperties)
player.Character:WaitForChild("Left Arm").Changed:Connect(setArmProperties)

function unequipped()
	unaim()
	gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
	isEquipped = false
	player.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
	script.Parent.Communications:FireServer("Unequip")

	if aimAnim then
		aimAnim:Stop()
	end
	if camera:FindFirstChild("ViewportGun") then
		camera.ViewportGun:Destroy()
	end
	if camera:FindFirstChild("Arms") then
		camera.Arms:Destroy()
		arms = nil
	end

	game:GetService("UserInputService").MouseIconEnabled = true

	gui.GunInfo.Visible = false
	TS:Create(player.PlayerScripts.SprintAndFOV.AimAffector, TweenInfo.new(0.3), {Value = 0}):Play()
	
	player.Character.BackpackEnabledManager.Reloading.Value = false
	reloading = false
end




local function unjam()
	if (not firing) and (not reloading) then
		gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
		reloading = true
		if jammed then
			jammed = false
		else
			if currentMag > 0 then
				currentMag -= 1
			end
		end
		gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
		
		script.Parent.Communications:FireServer("bolt")
		
		local animobj = Instance.new("Animation")
		animobj.AnimationId = unjamAnimId

		local unjamAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
		unjamAnim.Priority = Enum.AnimationPriority.Action2
		unjamAnim:Play()

		local VPunjamAnim = arms.Humanoid.Animator:LoadAnimation(animobj)
		VPunjamAnim.Priority = Enum.AnimationPriority.Action2
		VPunjamAnim:Play()

		unjamAnim.Ended:Wait()
		reloading = false
		
	end
end

local function reload()
	if (not jammed) and (not reloading) and currentMag < 1 and script.Parent.AmmoStored.Value > 0 then
		gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
		reloading = true
		local oldmag = currentMag
		if (script.Parent.AmmoStored.Value + currentMag) > magSize then
			currentMag = magSize
		else
			currentMag = script.Parent.AmmoStored.Value + currentMag
		end
		
		script.Parent.Communications:FireServer("reload", oldmag)
		
		if currentMag > 0 then
			gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
			local co = coroutine.create(function()
				wait(0.3)
				viewgun.rpg.rocket.Transparency = 0
			end)
			coroutine.resume(co)
		end
		
		
		local animobj = Instance.new("Animation")
		animobj.AnimationId = reloadAnimId

		reloadAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
		reloadAnim.Priority = Enum.AnimationPriority.Action2
		reloadAnim:Play(0)
		
		VPreloadAnim = arms.Humanoid.Animator:LoadAnimation(animobj)
		VPreloadAnim.Priority = Enum.AnimationPriority.Action2
		VPreloadAnim:Play(0)
		
		script.Parent.Parent.BackpackEnabledManager.Reloading.Value = true
		
		reloadAnim.Ended:Wait()
		reloading = false

		script.Parent.Parent.BackpackEnabledManager.Reloading.Value = false
	end
end

local function spawnBullet()
	gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI")
	currentMag -= 1
	if currentMag == 0 then
		gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
	end
	
	local roll = 0
	if roll == 1 then
		jammed = true
		gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 0, 0)
		script.Parent.Communications:FireServer("click")
		return
	end
	
	player.PlayerScripts.BGS_Player.Fire:Fire(bulletName, viewgun.rpg.rocket.CFrame.Position)
	firingSound:Play()
	script.Parent.Communications:FireServer("fire")
	player.Character.StanceAndCameraManager.Jump:Fire(Vector3.new(math.random(-80,80)/100,math.random(90,150)/100,0))
	
	viewportArmsSpring:AddVelocity(-1.5)
	
	viewgun.rpg.rocket.Transparency = 1
	
	--local co = coroutine.create(function()
	--	TS:Create(viewgun.Model.metal.bolt, TweenInfo.new(0.05, Enum.EasingStyle.Quart), {C1 = CFrame.new(0.4,0,0)}):Play()
	--	wait(0.05)
	--	TS:Create(viewgun.Model.metal.bolt, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {C1 = CFrame.new(0,0,0)}):Play()
	--end)

	--coroutine.resume(co)
end

local function fire()
	if (not jammed) and (not script.Parent.Handle.Reload.Playing) and (not script.Parent.Handle.Bolt.Playing) then
		if currentMag > 0 then
			if firemode == "Safety" then 
				script.Parent.Communications:FireServer("click")
				firing = false
			elseif firemode == "Semi" then
				spawnBullet()
				firing = false
			elseif firemode == "Auto" then
				if timeWaited > (60 / RPM) then
					spawnBullet()
					timeWaited = 0
				end
			end
		else
			script.Parent.Communications:FireServer("click")
			firing = false
		end
	elseif jammed and (not script.Parent.Handle.Reload.Playing) and (not script.Parent.Handle.Bolt.Playing) then
		script.Parent.Communications:FireServer("click")
		firing = false
	end
	
end

function unaim()
	TS:Create(player.PlayerScripts.SprintAndFOV.AimAffector, TweenInfo.new(0.3), {Value = 0}):Play()

	TS:Create(GunOffset, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Value = Vector3.new(0.5,-0.3,-1.1)}):Play()

	if aimAnim then
		aimAnim:Stop()
	end
	--18362011002
	local animobj = Instance.new("Animation")
	animobj.AnimationId = idleAnimId
	aimAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	aimAnim.Priority = Enum.AnimationPriority.Action
	aimAnim:Play()
end

game:GetService("UserInputService").InputBegan:Connect(function(input, ignore)
	if ignore or not isEquipped then return end
	
	
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if math.round(sprintAngle.Value) > 0 then return end
		if reloading then return end
		firing = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		if math.round(sprintAngle.Value) > 0 then return end
		aiming = not aiming
		if aiming then
		--17468264167
			local animobj = Instance.new("Animation")
			animobj.AnimationId = aimAnimId
			
			if aimAnim then
				aimAnim:Stop()
			end
			aimAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
			aimAnim.Priority = Enum.AnimationPriority.Action
			aimAnim:Play()
			--17489259537
			
			
			
			TS:Create(GunOffset, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Value = Vector3.new(0,0,0)}):Play()
			
			--player.Character["Right Arm"].BodyAttach.Enabled = false
			--script.Parent.PrimaryPart.Anchored = true
			--TS:Create(script.Parent.PrimaryPart, TweenInfo.new(3, Enum.EasingStyle.Quart), {CFrame = camera.CFrame}):Play()
			
			TS:Create(player.PlayerScripts.SprintAndFOV.AimAffector, TweenInfo.new(0.3), {Value = 70 - aimingZooms[currentAimingPos]}):Play()
		else
			
			unaim()
			
		end
		
	elseif input.KeyCode == Enum.KeyCode.V then
		if reloading then return end
		
		if firemode == "Safety" then
			firemode = "Semi"
		elseif firemode == "Semi" then
			firemode = "Auto"
		elseif firemode == "Auto" then
			firemode = "Safety"
		end
		print(firemode)
		
	elseif input.KeyCode == Enum.KeyCode.R then
		if math.round(sprintAngle.Value) > 0 then return end
		if reloading then return end
		
		reload()
	elseif input.KeyCode == Enum.KeyCode.F then
		return
		
		
	elseif input.KeyCode == Enum.KeyCode.T then
		
		currentAimingPos += 1
		if currentAimingPos > #aimingZooms then
			currentAimingPos = 1
		end
		
		TS:Create(player.PlayerScripts.SprintAndFOV.AimAffector, TweenInfo.new(0.3), {Value = 70 - aimingZooms[currentAimingPos]}):Play()
		
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, ignore)
	if ignore or not isEquipped then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		firing = false
		
	end
end)


game:GetService("RunService").RenderStepped:Connect(function(delta)
	timeWaited += delta
	if not isEquipped then return end
	if firing then
		fire()
	end
	
	if currentMag > 0 then
		if not jammed then
			gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1,1,1)
		else
			gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 0, 0)
		end
	else	
		gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
	end
	
	
end)


local gunBobCF = CFrame.new()
local walkingMultiplier = 0
local calmMultiplier = 1

local charspeed
local rotCF = Instance.new("CFrameValue", script)
game:GetService("RunService"):BindToRenderStep("SetVPGunCFrame", 10000, function(delta: number)
	--for _, p in script.Parent:GetDescendants() do
	--	if p:IsA("BasePart") then
	--		--p.LocalTransparencyModifier = 1
	--	end
	--end
	if not isEquipped then return end

	if arms then
		--print("??")
		if player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude > 0 then
			if walkingMultiplier < player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude then
				walkingMultiplier += delta * 6
			end
			if walkingMultiplier > player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude then
				walkingMultiplier = player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude
			end

			if calmMultiplier > 0 then
				calmMultiplier -= delta* 6
			end
			if calmMultiplier < 0 then
				calmMultiplier = 0
			end
		else
			if walkingMultiplier > 0 then
				walkingMultiplier -= delta * 6
			end
			if walkingMultiplier < 0 then
				walkingMultiplier = 0
			end

			if calmMultiplier < 1 then
				calmMultiplier += delta* 6
			end
			if calmMultiplier > 1 then
				calmMultiplier = 1
			end
		end

		charspeed = math.min(math.round(player.Character.Torso.AssemblyLinearVelocity.Magnitude / 16*100)/100, 1.5)

		if aiming then
			gunBobCF = gunBobCF:Lerp( CFrame.new(
				math.sin(time() % (2 * math.pi) * 1.5) / 10 * calmMultiplier 
					+ math.sin(time() % (2 * math.pi) * 6)* walkingMultiplier,

				math.abs(math.cos(time() % (2 * math.pi)) / 8 * calmMultiplier 
					+ math.cos(time() * 8 * charspeed % (2 * math.pi)  ) * walkingMultiplier * charspeed),
				0
				) , 0.1)
		else
			gunBobCF = gunBobCF:Lerp( CFrame.new(
				math.sin(time() % (2 * math.pi)) / 3 * calmMultiplier 
					+ math.sin(time() * 8 * charspeed % (2 * math.pi) )* walkingMultiplier * charspeed ,

				math.abs(math.cos(time() % (2 * math.pi)) / 3 * calmMultiplier 
					+ math.cos(time() * 8 * charspeed % (2 * math.pi)  ) * walkingMultiplier * charspeed),
				0
			) , 0.1)
		end

		local sprintCF = CFrame.fromOrientation(math.rad(sprintAngle.Value), math.rad(sprintAngle.Value), 0)

		--arms:PivotTo(camera.CFrame * CFrame.new(GunOffset.Value) * CFrame.fromOrientation(0,math.rad(180),0))

		game:GetService("TweenService"):Create(rotCF, TweenInfo.new(0.1), {Value = camera.CFrame.Rotation}):Play()
		arms:PivotTo(CFrame.new(camera.CFrame.Position) * rotCF.Value * CFrame.new(GunOffset.Value) * CFrame.fromOrientation(0,math.rad(180),0))

		if aiming then
			arms:PivotTo(arms:GetPivot():Lerp(arms:GetPivot() * gunBobCF * CFrame.fromOrientation(viewportArmsSpring.Offset * 50, 0, 0 ), 0.025))
		else
			arms:PivotTo(arms:GetPivot():Lerp(arms:GetPivot() * gunBobCF * CFrame.fromOrientation(viewportArmsSpring.Offset * 50, 0, 0 ), 0.05))
		end


		arms:PivotTo(arms:GetPivot() * sprintCF )




		if player.Character.BGS_Client:GetAttribute("Sprinting") then
			aiming = false
			unaim()
			game:GetService("TweenService"):Create(sprintAngle, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Value = 40}):Play()

		else
			game:GetService("TweenService"):Create(sprintAngle, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Value = 0}):Play()
		end

		--print(camera.CFrame.Position.Y)




		arms["Left Arm"].CanCollide = false
		arms["Right Arm"].CanCollide = false
		arms.Torso.CanCollide = false
		--arms:MoveTo(camera.CFrame.Position + Vector3.new(0,-3,0))
	end





	gui.GunInfo.AmmoLeft.Label.Text = math.round(script.Parent.AmmoStored.Value / magSize)

	--print(firemode)
	gui.GunInfo.Firemode.Text = ""
	gui.GunInfo.Firemode.Text = firemode

end)


script.Parent.Unequipped:Connect(unequipped)
if script.Parent:WaitForChild("DropCollider") then
	script.Parent.DropCollider.DropClientsideHook.Event:Connect(unequipped)
end