local player = game:GetService("Players").LocalPlayer
local foundCharacter = nil
local selectedCharacter = player.Character

local medsys = script.Parent.Parent.MedSys

local preparateEnum = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.PreparateEnum)
local preparateNames = preparateEnum.preparateNames

local medicEvent = game:GetService("ReplicatedStorage").BGS_Engine.Events.MedicEvent

local terminateMedApplication = false

local TS = game:GetService("TweenService")
local progressTween: Tween = nil
local applicationState = 0


game:GetService("UserInputService").InputBegan:Connect(function(input, ignore)
	if ignore then return end
	
	if input.KeyCode == Enum.KeyCode.LeftAlt then
		script.Parent.Visible = not script.Parent.Visible
		medsys.Visible = false
		script.Parent.Parent.SelectLimb.Visible = false
		script.Parent.Parent.SelectWound.Visible = false
		selectedCharacter = nil
		script.Parent.Other.Visible = false
		script.Parent.Self.Visible = false
		terminateMedApplication = true
		if progressTween then progressTween:Cancel() end
		progressTween = nil
		applicationState = 0
		medsys.Treatment.Progress.Label.Text = "Progress"
	
	end
end)


script.Parent.Medic.MouseButton1Down:Connect(function()
	--
	--if true then return end
	
	if script.Parent.Self.Visible then
		script.Parent.Self.Visible = false
		script.Parent.Other.Visible = false
	else
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {player.Character, workspace.CurrentCamera}
		local raycastResult = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.LookVector * 10, params)
		
		if raycastResult then
			local humanoid = raycastResult.Instance.Parent:FindFirstChildWhichIsA("Humanoid")
			
			local twistedTree = false
			
			if not humanoid then 
				twistedTree = true
				humanoid = raycastResult.Instance.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid") 
			end
			
			if humanoid then
				script.Parent.Self.Visible = true
				script.Parent.Other.Visible = true
				if not twistedTree then
					foundCharacter = raycastResult.Instance.Parent
				else
					foundCharacter = raycastResult.Instance.Parent.Parent.Parent
				end
				script.Parent.Other.Text = raycastResult.Instance.Parent.Name
			else
				script.Parent.Self.Visible = true
				script.Parent.Other.Visible = false
			end
		else
			script.Parent.Self.Visible = true
			script.Parent.Other.Visible = false
		end
	end
	
end)


script.Parent.Self.MouseButton1Down:Connect(function()
	medsys.Visible = true
	selectedCharacter = player.Character
	script.Parent.Visible = false
	medsys.Status.Title.Text = player.Name
end)

script.Parent.Other.MouseButton1Down:Connect(function()
	print(foundCharacter)
	if foundCharacter then
		medsys.Visible = true
		selectedCharacter = foundCharacter
		script.Parent.Visible = false
		medsys.Status.Title.Text = foundCharacter.Name
	end
end)




--------------------------------------------------------------------






game:GetService("RunService").RenderStepped:Connect(function(delta)
	if medsys.Visible then
		local humanoid = selectedCharacter:FindFirstChildWhichIsA("Humanoid")
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		local thisClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		
		client = selectedCharacter:FindFirstChild("BGS_Client")
		thisClient = player.Character:FindFirstChild("BGS_Client")
		
		if not client or not thisClient then return end
		
		
		medsys.Vitals.Blood.BloodAmount.Size = UDim2.new(client.Vitals.Blood.Value / 5000,0,1,0)
		medsys.Vitals.Health.HealthAmount.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth,0,1,0)
		medsys.Vitals.HeartRate.Text = "Heart rate: ".. math.round(client.Vitals.HeartRate.Value) 
		

		medsys.Vitals.Pain.TextColor3 = Color3.fromRGB(255, 255, 255)
		if client.Vitals.Pain.Value <= 5 then
			medsys.Vitals.Pain.Text = "No pain"
		elseif client.Vitals.Pain.Value <= 50 then
			medsys.Vitals.Pain.Text = "Mild pain"
		elseif client.Vitals.Pain.Value <= 150 then
			medsys.Vitals.Pain.Text = "Strong pain"
		else
			medsys.Vitals.Pain.Text = "In agony"
			medsys.Vitals.Pain.TextColor3 = Color3.fromRGB(255, 10, 10)
		end
		
		
		medsys.Kit.ScrollingFrame.Gauze.Count.Text = thisClient.Kit.Gauze.Value
		medsys.Kit.ScrollingFrame.Tourniquet.Count.Text = thisClient.Kit.Tourniquet.Value
		medsys.Kit.ScrollingFrame.PlasticCover.Count.Text = thisClient.Kit.PlasticCover.Value
		medsys.Kit.ScrollingFrame.Splint.Count.Text = thisClient.Kit.Splint.Value
		medsys.Kit.ScrollingFrame.SutureKit.Count.Text = thisClient.Kit.SutureKit.Value
		medsys.Kit.ScrollingFrame.Painkiller.Count.Text = thisClient.Kit.Painkiller.Value
		medsys.Kit.ScrollingFrame.BloodBag.Count.Text = thisClient.Kit.Bloodbag.Value
		medsys.Kit.ScrollingFrame.Caffeine.Count.Text = thisClient.Kit.Caffeine.Value
		medsys.Kit.ScrollingFrame.Morphine.Count.Text = thisClient.Kit.Morphine.Value
		medsys.Kit.ScrollingFrame.Defibrillator.Count.Text = tostring(thisClient.Kit.Defibrillator.Value)
		medsys.Kit.ScrollingFrame.Epnephrine.Count.Text = thisClient.Kit.Epinephrine.Value
		
		if selectedCharacter:FindFirstChild("Wound", true) then
			medsys.Status.ScrollingFrame.HasPunctureWounds.Visible = true
		else
			medsys.Status.ScrollingFrame.HasPunctureWounds.Visible = false
		end
		
		medsys.Status.ScrollingFrame.TourniquetLeftArm.Visible = client:GetAttribute("LeftArmTourniquet")
		medsys.Status.ScrollingFrame.TourniquetRightArm.Visible = client:GetAttribute("RightArmTourniquet")
		medsys.Status.ScrollingFrame.TourniquetLeftLeg.Visible = client:GetAttribute("LeftLegTourniquet")
		medsys.Status.ScrollingFrame.TourniquetRightLeg.Visible = client:GetAttribute("RightLegTourniquet")
		
		
		medsys.Status.ScrollingFrame.LeftArmBroken.Visible = client:GetAttribute("LeftArmBroken")
		medsys.Status.ScrollingFrame.RightArmBroken.Visible = client:GetAttribute("RightArmBroken")
		medsys.Status.ScrollingFrame.LeftLegBroken.Visible = client:GetAttribute("LeftLegBroken")
		medsys.Status.ScrollingFrame.RightLegBroken.Visible = client:GetAttribute("RightLegBroken")
		
		if humanoid.Health <= 0 then 
			medsys.Status.ScrollingFrame.Consciousness.Text = "Dead"
		elseif client:GetAttribute("ClinicalDeath") then
			medsys.Status.ScrollingFrame.Consciousness.Text = "Dying"
		elseif client:GetAttribute("Unconscious") then
			medsys.Status.ScrollingFrame.Consciousness.Text = "Unconscious"
		else
			medsys.Status.ScrollingFrame.Consciousness.Text = "Conscious"
		end
		
		if humanoid.Health > 95 then
			medsys.Status.ScrollingFrame.Risk.Text = "Healthy"
		elseif humanoid.Health > 75 then
			medsys.Status.ScrollingFrame.Risk.Text = "Low risk"
		elseif humanoid.Health > 50 then
			medsys.Status.ScrollingFrame.Risk.Text = "Medium risk"
		elseif humanoid.Health > 0 then
			medsys.Status.ScrollingFrame.Risk.Text = "High risk"
		else
			medsys.Status.ScrollingFrame.Risk.Text = "It's over."
		end
		
		
		if thisClient:GetAttribute("Unconscious") or thisClient:GetAttribute("ClinicalDeath") then
			script.Parent.Visible = false
			medsys.Visible = false
			script.Parent.Parent.SelectLimb.Visible = false
			script.Parent.Parent.SelectWound.Visible = false
			selectedCharacter = nil
			script.Parent.Other.Visible = false
			script.Parent.Self.Visible = false
			terminateMedApplication = true
			if progressTween then progressTween:Cancel() end
			progressTween = nil
			applicationState = 0
			medsys.Treatment.Progress.Label.Text = "Progress"
		end
		
		
	end
end)




---------------------------------------------------

local Tbuttons = medsys.Treatment.Buttons

Tbuttons.Field.MouseButton1Down:Connect(function()
	medsys.Treatment.NoTab.Visible = false
	medsys.Treatment.Field.Visible = true
	medsys.Treatment.Heart.Visible = false
	medsys.Treatment.Medicines.Visible = false
	medsys.Treatment.Further.Visible = false
end)

Tbuttons.Heart.MouseButton1Down:Connect(function()
	medsys.Treatment.NoTab.Visible = false
	medsys.Treatment.Field.Visible = false
	medsys.Treatment.Heart.Visible = true
	medsys.Treatment.Medicines.Visible = false
	medsys.Treatment.Further.Visible = false
end)

Tbuttons.Medicines.MouseButton1Down:Connect(function()
	medsys.Treatment.NoTab.Visible = false
	medsys.Treatment.Field.Visible = false
	medsys.Treatment.Heart.Visible = false
	medsys.Treatment.Medicines.Visible = true
	medsys.Treatment.Further.Visible = false
end)

Tbuttons.Further.MouseButton1Down:Connect(function()
	medsys.Treatment.NoTab.Visible = false
	medsys.Treatment.Field.Visible = false
	medsys.Treatment.Heart.Visible = false
	medsys.Treatment.Medicines.Visible = false
	medsys.Treatment.Further.Visible = true
end)

---------------------------------------------------

local response = 0

game:GetService("ReplicatedStorage").BGS_Engine.Events.PromptPreparateApplication.OnClientInvoke = function(preparate: number, asker: Player)
	response = 0
	script.Parent.Parent.AcceptMedApplication.Visible = true
	
	script.Parent.Parent.AcceptMedApplication.TextLabel.Text = asker.Name.." is trying to give you "..preparateNames[preparate+1]
	
	repeat wait() until response ~= 0
	
	if response == -1 then return false
	elseif response == 1 then return true
	end
end

script.Parent.Parent.AcceptMedApplication.Decline.MouseButton1Down:Connect(function()
	script.Parent.Parent.AcceptMedApplication.Visible = false
	response = -1
end)

script.Parent.Parent.AcceptMedApplication.Accept.MouseButton1Down:Connect(function()
	script.Parent.Parent.AcceptMedApplication.Visible = false
	response = 1
end)


---------------------------------------------------

local function selectWound()
	medsys.Visible = false
	script.Parent.Parent.SelectWound.Visible = true
	terminateMedApplication = false
	
	local toDisconnect: {RBXScriptConnection} = {}
	local guis: {BillboardGui} = {}
	local selectedWound: BasePart = nil
	
	for _, inst in selectedCharacter:GetDescendants() do
		if inst:IsA("BasePart") and inst.Name == "Wound" and inst:FindFirstChild("SelectThisWound") then
			local gui: BillboardGui = inst.SelectThisWound:Clone()
			if inst.Parent.Name == "Lungs" then
				gui.Select.BackgroundColor3 = Color3.fromRGB(96, 120, 255)
			end
			gui.Parent = player.PlayerGui
			gui.Enabled = true
			table.insert(guis, gui)
			
			toDisconnect[_] = gui.Select.MouseButton1Down:Connect(function()
				selectedWound = inst
				print("selected!")
			end)
		end
	end
	
	while true do
		if selectedWound ~= nil then break end
		if not selectedCharacter then break end
		if (player.Character.Head.Position - selectedCharacter.Head.Position).Magnitude > 30 then break end
		if player.Character:FindFirstChildWhichIsA("Humanoid").Health < 0 then break end
		if terminateMedApplication then break end
		wait()
	end
	print("left the waiting loop")
	
	for _, i in toDisconnect do
		i:Disconnect()
	end
	for _, board in guis do
		board:Destroy()
	end
	
	if not terminateMedApplication then
		script.Parent.Parent.SelectWound.Visible = false
		medsys.Visible = true
	end
	return selectedWound
end


local selectedLimb = nil
local limbGui = script.Parent.Parent.SelectLimb

local function selectLimb(includeTorso: boolean)
	medsys.Visible = false
	limbGui.Visible = true
	limbGui.Torso.Visible = includeTorso
	selectedLimb = nil
	terminateMedApplication = false
	
	limbGui.LeftArm.Visible = (selectedCharacter.Torso:FindFirstChild("Left Shoulder") ~= nil)
	limbGui.RightArm.Visible = (selectedCharacter.Torso:FindFirstChild("Right Shoulder") ~= nil)
	limbGui.LeftLeg.Visible = (selectedCharacter.Torso:FindFirstChild("Left Hip") ~= nil)
	limbGui.RightLeg.Visible = (selectedCharacter.Torso:FindFirstChild("Right Hip") ~= nil)
	

	while true do
		if selectedLimb ~= nil then break end
		if not selectedCharacter then break end
		if (player.Character.Head.Position - selectedCharacter.Head.Position).Magnitude > 30 then break end
		if player.Character:FindFirstChildWhichIsA("Humanoid").Health < 0 then break end
		if terminateMedApplication then break end
		wait()
	end
	print("left the waiting loop")


	if not terminateMedApplication then
		limbGui.Visible = false
		medsys.Visible = true
	end
	return selectedLimb
end


limbGui.Torso.Button.MouseButton1Down:Connect(function()
	selectedLimb = selectedCharacter["Torso"]
end)

limbGui.LeftArm.Button.MouseButton1Down:Connect(function()
	selectedLimb = selectedCharacter["Left Arm"]
end)

limbGui.LeftLeg.Button.MouseButton1Down:Connect(function()
	selectedLimb = selectedCharacter["Left Leg"]
end)

limbGui.RightArm.Button.MouseButton1Down:Connect(function()
	selectedLimb = selectedCharacter["Right Arm"]
end)

limbGui.RightLeg.Button.MouseButton1Down:Connect(function()
	selectedLimb = selectedCharacter["Right Leg"]
end)


local applicationDebounce = false


game:GetService("ReplicatedStorage").BGS_Engine.Events.MedicEvent.OnClientEvent:Connect(function(action: string) 
	if action == "Accepted" then
		medsys.Treatment.Progress.Label.Text = "Applying..."
		applicationState = 1
		if progressTween then
			progressTween:Play()
		end
	elseif action == "Declined" then
		medsys.Treatment.Progress.Label.Text = "Player declined treatment."
		applicationState = -1
		progressTween = nil
	elseif action == "Noitem" then
		medsys.Treatment.Progress.Label.Text = "Not enough items."
		applicationState = -1
		progressTween = nil
	end
end)


local function delayWithProgressBar(preparate: number)
	applicationDebounce = true
	applicationState = 0
	medsys.Treatment.Progress.Bar.Size = UDim2.new(0,0,1,0)
	medsys.Treatment.Progress.Label.Text = "Asking the player..."
	progressTween = TS:Create(medsys.Treatment.Progress.Bar, TweenInfo.new(preparateEnum.waitingTimes[preparate+1], Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)})
	
	while applicationState == 0 do
		wait()
		if terminateMedApplication or applicationState == -1 then 
			applicationDebounce = false
			return 
		end
	end
	
	wait(preparateEnum.waitingTimes[preparate+1])
	applicationDebounce = false
	medsys.Treatment.Progress.Label.Text = "Done"
end


-------------------------------------------------
-- MED BUTTONS
-------------------------------------------------
-- field

medsys.Treatment.Field.Gauze.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	terminateMedApplication = false
	local wound = selectWound()
	
	
	
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.Gauze, selectedCharacter, nil, wound)
	
	delayWithProgressBar(preparateEnum.Gauze)
end)

medsys.Treatment.Field.Tourniquet.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	terminateMedApplication = false
	local limb = selectLimb(false)
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.Tourniquet, selectedCharacter, limb, nil)
	
	delayWithProgressBar(preparateEnum.Tourniquet)
end)

medsys.Treatment.Field.Splint.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	terminateMedApplication = false
	local limb = selectLimb(false)
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.Splint, selectedCharacter, limb, nil)

	delayWithProgressBar(preparateEnum.Splint)
end)

medsys.Treatment.Field.PlasticCover.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	terminateMedApplication = false
	local wound = selectWound()
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.PlasticCover, selectedCharacter, nil, wound)
	
	delayWithProgressBar(preparateEnum.PlasticCover)
end)


-- heart

medsys.Treatment.Heart.CPR.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.CPR, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.CPR)
end)

medsys.Treatment.Heart.Defibrillator.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.Defibrillator, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.Defibrillator)
end)

-- medicines

medsys.Treatment.Medicines.Painkiller.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.Painkiller, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.Painkiller)
end)

medsys.Treatment.Medicines.Morphine.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.Morphine, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.Morphine)
end)

medsys.Treatment.Medicines.Caffeine.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.Caffeine, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.Caffeine)
end)

medsys.Treatment.Medicines.Epinephrine.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.Epinephrine, selectedCharacter, nil, nil)
	
	delayWithProgressBar(preparateEnum.Epinephrine)
end)

-- further

medsys.Treatment.Further.SutureKit.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	terminateMedApplication = false
	local wound = selectWound()
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.SutureKit, selectedCharacter, nil, wound)
	
	delayWithProgressBar(preparateEnum.SutureKit)
end)

medsys.Treatment.Further.BloodBag.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.BloodBag, selectedCharacter, nil, nil)

	delayWithProgressBar(preparateEnum.BloodBag)
end)

medsys.Treatment.Further.DrawBlood.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	medicEvent:FireServer(preparateEnum.DrawBlood, selectedCharacter, nil, nil)

	delayWithProgressBar(preparateEnum.DrawBlood)
end)

medsys.Treatment.Further.Amputation.MouseButton1Down:Connect(function()
	if applicationDebounce then return end
	local limb = selectLimb(false)
	if terminateMedApplication then 
		terminateMedApplication = false
		return 
	end
	medicEvent:FireServer(preparateEnum.Amputation, selectedCharacter, limb, nil)
	
	delayWithProgressBar(preparateEnum.Amputation)
end)