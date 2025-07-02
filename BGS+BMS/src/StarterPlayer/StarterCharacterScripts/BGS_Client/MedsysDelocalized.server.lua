local client = script.Parent
local map = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Map)

local sprintHeartbeatModifier = 0
local randomHeartbeatModifier = math.random(-10,10)
local ragdollModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Ragdoll)


--------------------------


function collapse(character: Model)
	
	if character.BGS_Client:GetAttribute("Unconscious") then return end
	
	--ragdollModule.Ragdoll(character)
	character.BGS_Client:SetAttribute("Unconscious", true)
	if character:FindFirstChildWhichIsA("Tool") then
		if game:GetService("Players"):GetPlayerFromCharacter(character) then
			character:FindFirstChildWhichIsA("Tool").Parent = game:GetService("Players"):GetPlayerFromCharacter(character).Backpack
		else
			character:FindFirstChildWhichIsA("Tool"):Destroy()
		end
	end
end


--------------------------


game:GetService("RunService").Heartbeat:Connect(function(delta)
	if not script.Parent then return end
	local character = script.Parent.Parent
	
	if not character:FindFirstChild("Torso") then return end
	
	client.AppliedMedication.AmountOfCaffeine.Value = math.max(0, client.AppliedMedication.AmountOfCaffeine.Value - delta)
	client.AppliedMedication.AmountOfMorphine.Value = math.max(0, client.AppliedMedication.AmountOfMorphine.Value - delta)
	client.AppliedMedication.AmountOfEpinephrine.Value = math.max(0, client.AppliedMedication.AmountOfEpinephrine.Value - (delta * 5))
	
	--------------------
	local LAB = 0
	if character.Torso:FindFirstChild("Left Shoulder") then
		for _, instance: Instance in character["Left Arm"]:GetDescendants() do
			if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
				LAB += instance.BleedingRate.Value
			elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
				LAB += math.min(0.2, instance.BleedingRate.Value / 10)
			end
		end
	end

	if client:GetAttribute("LeftArmTourniquet") and LAB > 0.4 then
		LAB = 0.4
	end
	
	
	local RAB = 0
	if character.Torso:FindFirstChild("Right Shoulder") then
		for _, instance: Instance in character["Right Arm"]:GetDescendants() do
			if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
				RAB += instance.BleedingRate.Value
			elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
				RAB += math.min(0.2, instance.BleedingRate.Value / 10)
			end
		end
	end
	
	if client:GetAttribute("RightArmTourniquet") and RAB > 0.4 then
		RAB  = 0.4
	end
	
	
	local LLB = 0
	if character.Torso:FindFirstChild("Left Hip") then
		for _, instance: Instance in character["Left Leg"]:GetDescendants() do
			if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
				LLB += instance.BleedingRate.Value
			elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
				LLB += math.min(0.2, instance.BleedingRate.Value / 10)
			end
		end
	end
	
	if client:GetAttribute("LeftLegTourniquet") and LLB > 0.4 then
		LLB = 0.4
	end
	
	
	local RLB = 0
	if character.Torso:FindFirstChild("Right Hip") then
		for _, instance: Instance in character["Right Leg"]:GetDescendants() do
			if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
				RLB += instance.BleedingRate.Value
			elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
				RLB += math.min(0.2, instance.BleedingRate.Value / 10)
			
			end
		end
	end
	
	if client:GetAttribute("RightLegTourniquet") and RLB > 0.4 then
		RLB = 0.4
	end
	
	
	local TB = 0
	for _, instance: Instance in character["Torso"]:GetChildren() do
		if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
			TB += instance.BleedingRate.Value
		elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
			TB += math.min(0.2, instance.BleedingRate.Value / 10)
		end
	end
	for _, instance: Instance in character["Head"]:GetChildren() do
		if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
			TB += instance.BleedingRate.Value
		elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
			TB += math.min(0.2, instance.BleedingRate.Value / 10)
		end
	end
	if character:FindFirstChild("Lungs") then
		for _, instance: Instance in character["Lungs"]:GetChildren() do
			if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.Covered.Value then
				TB += instance.BleedingRate.Value
			elseif instance.Name == "Wound" and instance.Covered and instance.Covered.Value then
				TB += math.min(0.2, instance.BleedingRate.Value / 10)
			end
		end
	end
	for _, instance: Instance in character["HumanoidRootPart"]:GetChildren() do
		if instance:IsA("BasePart") and instance.Name == "Wound" and not instance.IsBandaged.Value then
			TB += instance.BleedingRate.Value
		elseif instance.Name == "Wound" and instance.IsBandaged and instance.IsBandaged.Value then
			TB += math.min(0.2, instance.BleedingRate.Value / 10)
		end
	end
	--------------------
	
	if character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
		client.Vitals.Blood.Value = math.clamp(client.Vitals.Blood.Value + (0.01 - LAB - LLB - RAB - RLB - TB) * delta, 0, 5000)

		client.Vitals.Pain.Value = math.max(0, client.Vitals.Pain.Value - 2 * delta)
	else
		client.Vitals.Blood.Value = math.clamp(client.Vitals.Blood.Value + (0 - LAB - LLB - RAB - RLB - TB) * delta, 0, 5000)
	end
	
	if client.Vitals.Blood.Value <= 0 and character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
		character:FindFirstChildWhichIsA("Humanoid").Health = 0
	elseif client.Vitals.Blood.Value < 1000 and not client:GetAttribute("Unconscious") then
		collapse(character)
	end
	
	if character:FindFirstChildWhichIsA("Humanoid").Health <= 0 and not client:GetAttribute("Unconscious") then
		
		client.Vitals.HeartRate.Value = 0
		client.Vitals.IsHavingAHeartAttack.Value = false
		client:SetAttribute("ClinicalDeath", true)
		collapse(character)
		
	
	elseif (not client.Vitals.IsHavingAHeartAttack.Value) and (not client:GetAttribute("ClinicalDeath")) then
		--client.Vitals.HeartRate.Value -= sprintHeartbeatModifier
		
		if client:GetAttribute("Sprinting") then
			sprintHeartbeatModifier = math.clamp(sprintHeartbeatModifier + delta, 0, 70)
		elseif not client:GetAttribute("Sprinting") then
			sprintHeartbeatModifier = math.clamp(sprintHeartbeatModifier - delta, 0, 70)
		end
		
		local baseHeartrateValue = 70
		if client:GetAttribute("Unconscious") then
			baseHeartrateValue = 35
		end
		
		client.Vitals.HeartRate.Value = math.max(
			  baseHeartrateValue
				+ sprintHeartbeatModifier 
				+ randomHeartbeatModifier
				+ map.map(client.AppliedMedication.AmountOfCaffeine.Value, 0, 1000, 0, 150)   -- dose 200, 30 bpm
				+ map.map(client.AppliedMedication.AmountOfEpinephrine.Value, 0, 300, 0, 150) -- dose 100, 50 bpm
				- map.map(client.AppliedMedication.AmountOfMorphine.Value, 0, 1000, 0, 330)   -- dose 100, 33 bpm
		,0)
	
		
 		
	elseif client.Vitals.IsHavingAHeartAttack.Value and not client:GetAttribute("ClinicalDeath") then
		client.Vitals.HeartRate.Value = 270 + math.random(-10,10)
	elseif client:GetAttribute("ClinicalDeath") then
		client.Vitals.HeartRate.Value = 0
		client.Vitals.IsHavingAHeartAttack.Value = false
	end
	
	
	if client.Vitals.HeartRate.Value > 220     --client.AppliedMedication.AmountOfCaffeine.Value > 500 
		and (not client.Vitals.IsHavingAHeartAttack.Value) and (not client:GetAttribute("ClinicalDeath")) then
		
		local roll = math.random(math.clamp(client.Vitals.HeartRate.Value,0,300), 400)
		if roll == 399 then
			client.Vitals.IsHavingAHeartAttack.Value = true
			client:SetAttribute("Unconscious", true)
			--ragdollModule.Ragdoll(character)
		end
	end
	
	if client.Vitals.HeartRate.Value <= 20 and not client:GetAttribute("ClinicalDeath") then
		if math.random(0,100) == 50 then
			client:SetAttribute("ClinicalDeath", true)
			collapse(character)
			client.Vitals.HeartRate.Value = 0
		end
		
	elseif client.Vitals.HeartRate.Value <= 35 and not client:GetAttribute("Unconscious") then
		
		client:SetAttribute("ClinicalDeath", false)
		collapse(character)
	end
	
	--if client.Vitals.IsHavingAHeartAttack.Value and not client:GetAttribute("Unconscious") then
	--	ragdollModule.Ragdoll(character)
	--	client:SetAttribute("Unconscious", true)
	--end
	
	if client.Vitals.Pain.Value > 200 and not client:GetAttribute("Unconscious") then
		collapse(character)
	end
	
	
	if (not client.Vitals.IsHavingAHeartAttack.Value) and (not client:GetAttribute("ClinicalDeath")) and client.Vitals.HeartRate.Value > 35 and client:GetAttribute("Unconscious") and client.Vitals.Blood.Value > 1000 and client.Vitals.Pain.Value < 19 and not client.CarryValues.CarriedBy.Value then
		print("RISE")
		--ragdollModule.Unragdoll(character)
		client:SetAttribute("Unconscious", false)
	end
	
	
	if client:GetAttribute("ClinicalDeath") or client.Vitals.IsHavingAHeartAttack.Value then
		client.Vitals.TimeLeftBeforeBrainDeath.Value -= delta
	else
		client.Vitals.TimeLeftBeforeBrainDeath.Value = 45
	end
	
	if client.Vitals.TimeLeftBeforeBrainDeath.Value <= 0 and character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
		character:FindFirstChildWhichIsA("Humanoid").Health = 0
	end
	
	
	if client:GetAttribute("LeftArmTourniquet") then
		client.AppliedMedication.TimeTourniquetLA.Value += delta
	else
		client.AppliedMedication.TimeTourniquetLA.Value = math.max(0,
			client.AppliedMedication.TimeTourniquetLA.Value - delta)
	end
	if client:GetAttribute("LeftLegTourniquet") then
		client.AppliedMedication.TimeTourniquetLL.Value += delta
	else
		client.AppliedMedication.TimeTourniquetLL.Value = math.max(0,
			client.AppliedMedication.TimeTourniquetLL.Value - delta)
	end
	if client:GetAttribute("RightArmTourniquet") then
		client.AppliedMedication.TimeTourniquetRA.Value += delta
	else
		client.AppliedMedication.TimeTourniquetRA.Value = math.max(0,
			client.AppliedMedication.TimeTourniquetRA.Value - delta)
	end
	if client:GetAttribute("RightLegTourniquet") then
		client.AppliedMedication.TimeTourniquetRL.Value += delta
	else
		client.AppliedMedication.TimeTourniquetRL.Value = math.max(0,
			client.AppliedMedication.TimeTourniquetRL.Value - delta)
	end
	
	if client.AppliedMedication.TimeTourniquetRL.Value > 60 then
		local limb: Part = character:FindFirstChild("Right Leg")
		if limb and character.Torso:FindFirstChild("Right Hip") then
			limb.BrickColor = BrickColor.new("Black")
			client.Vitals.Pain.Value += 3 * delta
		end
	end
	if client.AppliedMedication.TimeTourniquetRA.Value > 60 then
		local limb: Part = character:FindFirstChild("Right Arm")
		if limb and character.Torso:FindFirstChild("Right Shoulder") then
			limb.BrickColor = BrickColor.new("Black")
			client.Vitals.Pain.Value += 3 * delta
		end
	end
	if client.AppliedMedication.TimeTourniquetLA.Value > 60 then
		local limb: Part = character:FindFirstChild("Left Arm")
		if limb and character.Torso:FindFirstChild("Left Shoulder") then
			limb.BrickColor = BrickColor.new("Black")
			client.Vitals.Pain.Value += 3 * delta
		end
	end
	if client.AppliedMedication.TimeTourniquetLL.Value > 60 then
		local limb: Part = character:FindFirstChild("Left Leg")
		if limb and character.Torso:FindFirstChild("Left Hip") then
			limb.BrickColor = BrickColor.new("Black")
			client.Vitals.Pain.Value += 3 * delta
		end
	end
	
	
	
	
end)


