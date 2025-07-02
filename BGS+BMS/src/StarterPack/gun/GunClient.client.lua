-- TEST GUN

local player = game:GetService("Players").LocalPlayer
local firing = false
local firemode = "Safety"
local isEquipped = false
local jammed = false

local aiming = false
local RPM = 600
local timeWaited = 0

local bulletName = "Bullet762"

local magSize = 30
local currentMag = 30
local bulletsStored = 300

local aimingZoom = 40

local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local TS = game:GetService("TweenService")


local aimAnim: AnimationTrack
local reloadAnim: AnimationTrack

local VPaimAnim: AnimationTrack
local VPreloadAnim: AnimationTrack

local CFramePositionOffset = CFrame.new(0.5,0,-1)
local GunOffset = Instance.new("Vector3Value")
GunOffset.Value = Vector3.new(0.5,-0.3,-0.7)

local LArmOffset = Vector3.new(0,0,0)
local RArmOffset = Vector3.new(0,0,0)
local ArmsOffset = Vector3.new(-0.3,0,0.75)


local arms

local springModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Spring)
local viewportArmsSpring = springModule.new(0.05,30,20,0,0,0)

--local gui = player.PlayerGui.BGS_GUI


script.Parent.Equipped:Connect(function()
	isEquipped = true
	player.CameraMaxZoomDistance = 0
	script.Parent.Communications:FireServer("Equip")
	
	local animobj = Instance.new("Animation")
	animobj.AnimationId = "rbxassetid://17468457019"
	aimAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	aimAnim.Priority = Enum.AnimationPriority.Action
	aimAnim:Play()
	
	local viewgun = script.Parent:Clone()
	viewgun.Parent = camera
	viewgun.Name = "ViewportGun"
	viewgun.PrimaryPart = viewgun.AimPart
	viewgun:MoveTo(camera.CFrame.Position)
	
	
	arms = game:GetService("ReplicatedStorage").BGS_Engine.ViewportArms.Arms:Clone()
	arms.Parent = viewgun.Parent
	arms:PivotTo(camera.CFrame)
	--arms.HumanoidRootPart.RootWeld.Part1 =  viewgun.PrimaryPart
	
	viewgun.Parent = arms
	arms["Right Arm"].BodyAttach.Part1 = viewgun.Handle
	arms.PrimaryPart = viewgun.AimPart
	
	
	local animobj = Instance.new("Animation")
	animobj.AnimationId =  "rbxassetid://17468457019" --"rbxassetid://17489259537"

	if VPaimAnim then
		VPaimAnim:Stop()
	end
	VPaimAnim = arms:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	VPaimAnim.Priority = Enum.AnimationPriority.Action
	VPaimAnim:Play()
	
	game:GetService("UserInputService").MouseIconEnabled = false
	
	
	--player.PlayerGui.BGS_GUI.GunInfo.Visible = true
	
end)
script.Parent.Unequipped:Connect(function()
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
	
	--player.PlayerGui.BGS_GUI.GunInfo.Visible = false
end)


local function unjam()
	if (not script.Parent.Handle.Reload.Playing) and (not script.Parent.Handle.Bolt.Playing) and (not firing) then
		if jammed then
			jammed = false
		else
			if currentMag > 0 then
				currentMag -= 1
			end
		end
		--player.PlayerGui.BGS_GUI.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
		script.Parent.Communications:FireServer("bolt")
	end
end

local function reload()
	if (not jammed) and (not script.Parent.Handle.Reload.Playing) and (not script.Parent.Handle.Bolt.Playing) then
		
		local oldmag = currentMag
		if (script.Parent.AmmoStored.Value + currentMag) > magSize then
			currentMag = magSize
		else
			currentMag = script.Parent.AmmoStored.Value + currentMag
		end
		
		script.Parent.Communications:FireServer("reload", oldmag)
		
		if currentMag > 0 then
			--player.PlayerGui.BGS_GUI.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
		end
		
		--17468594560
		
		local animobj = Instance.new("Animation")
		animobj.AnimationId = "rbxassetid://17468594560"

		if aimAnim then
			aimAnim:Stop()
		end
		if VPaimAnim then
			VPaimAnim:Stop()
		end
		reloadAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
		reloadAnim.Priority = Enum.AnimationPriority.Action
		reloadAnim:Play()
		
		VPreloadAnim = arms.Humanoid.Animator:LoadAnimation(animobj)
		VPreloadAnim.Priority = Enum.AnimationPriority.Action
		VPreloadAnim:Play()
		
		reloadAnim.Ended:Wait()
		if VPaimAnim then
			VPaimAnim:Play()
		end
		
	end
end

local function spawnBullet()
	currentMag -= 1
	if currentMag == 0 then
		--gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
	end

	local roll = math.random(1,200)
	if roll == 1 then
		jammed = true
		--gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 0, 0)
		script.Parent.Communications:FireServer("click")
		return
	end

	player.PlayerScripts.BGS_Player.Fire:Fire(bulletName)
	script.Parent.Communications:FireServer("fire")
	player.Character.StanceAndCameraManager.Jump:Fire(Vector3.new(0,4,0))
	
	viewportArmsSpring:AddVelocity(-3)
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

game:GetService("UserInputService").InputBegan:Connect(function(input, ignore)
	if ignore or not isEquipped then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		firing = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = not aiming
		if aiming then
		--17468264167
			local animobj = Instance.new("Animation")
			animobj.AnimationId = "rbxassetid://17468264167"
			
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
			
			
		else
			
			
			TS:Create(GunOffset, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Value = Vector3.new(0.5,-0.3,-0.7)}):Play()
			
			--TS:Create(script.Parent.PrimaryPart, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {CFrame = player.Character["Right Arm"].CFrame * player.Character["Right Arm"].BodyAttach.C1}):Play()
			--script.Parent.PrimaryPart.Anchored = false
			--player.Character["Right Arm"].BodyAttach.Enabled = true
			if aimAnim then
				aimAnim:Stop()
			end
			--17468457019
			local animobj = Instance.new("Animation")
			animobj.AnimationId = "rbxassetid://17468457019"
			aimAnim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
			aimAnim.Priority = Enum.AnimationPriority.Action
			aimAnim:Play()
			
			--aimAnim.Ended:Wait()
			--if camera:FindFirstChild("ViewportGun") then
			--	camera.ViewportGun:Destroy()
			--end
		end
		
	elseif input.KeyCode == Enum.KeyCode.V then
		
		if firemode == "Safety" then
			firemode = "Semi"
		elseif firemode == "Semi" then
			firemode = "Auto"
		elseif firemode == "Auto" then
			firemode = "Safety"
		end
		print(firemode)
		
	elseif input.KeyCode == Enum.KeyCode.R then
		reload()
	elseif input.KeyCode == Enum.KeyCode.F then
		unjam()
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
			--gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1,1,1)
		else
			--gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(1, 0, 0)
		end
	else	
		--gui.GunInfo.JammedIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
	end
end)


local gunBobCF = CFrame.new()
local walkingMultiplier = 0
local calmMultiplier = 1



game:GetService("RunService").PreRender:Connect(function(delta)
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
				walkingMultiplier += delta * 20
			end
			if walkingMultiplier > player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude then
				walkingMultiplier = player.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude
			end
			
			if calmMultiplier > 0 then
				calmMultiplier -= delta*20
			end
			if calmMultiplier < 0 then
				calmMultiplier = 0
			end
		else
			if walkingMultiplier > 0 then
				walkingMultiplier -= delta * 20
			end
			if walkingMultiplier < 0 then
				walkingMultiplier = 0
			end
			
			if calmMultiplier < 1 then
				calmMultiplier += delta*20
			end
			if calmMultiplier > 1 then
				calmMultiplier = 1
			end
		end
		

		gunBobCF = CFrame.new(
			math.sin(time() % (2 * math.pi) * 1.5) / 3 * calmMultiplier 
				+ math.sin(time() % (2 * math.pi) * 6)* walkingMultiplier,
			
			math.cos(time() % (2 * math.pi) * 2 ) / 1.5 * calmMultiplier 
				+ math.cos(time() % (2 * math.pi) * 9 ) * walkingMultiplier,
			0
			
		) 
		
		arms:PivotTo(camera.CFrame * CFrame.new(GunOffset.Value) * CFrame.fromOrientation(0,math.rad(180),0))
		
		if aiming then
			arms:PivotTo(arms:GetPivot():Lerp(arms:GetPivot() * gunBobCF * CFrame.fromOrientation(viewportArmsSpring.Offset * 50, 0, 0 ), 0.025))
		else
			arms:PivotTo(arms:GetPivot():Lerp(arms:GetPivot() * gunBobCF * CFrame.fromOrientation(viewportArmsSpring.Offset * 50, 0, 0 ), 0.05))
		end
		
		
		
		
		
		
		
		arms["Left Arm"].CanCollide = false
		arms["Right Arm"].CanCollide = false
		arms.Torso.CanCollide = false
		--arms:MoveTo(camera.CFrame.Position + Vector3.new(0,-3,0))
	end
	

	
	--local gui = player.PlayerGui.BGS_GUI
	
	--gui.GunInfo.AmmoLeft.Label.Text = math.round(script.Parent.AmmoStored.Value / magSize)
	
	----print(firemode)
	--gui.GunInfo.Firemode.Text = ""
	--gui.GunInfo.Firemode.Text = firemode
	
end)
