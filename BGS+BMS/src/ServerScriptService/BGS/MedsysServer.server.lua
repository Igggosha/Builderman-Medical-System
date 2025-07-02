local engine = game:GetService("ReplicatedStorage").BGS_Engine
local preparateEnum = require(engine.Modules.PreparateEnum)
local ragdollModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Ragdoll)


function heal(humanoid: Humanoid, amount: number)
	if humanoid.Health + amount > humanoid.MaxHealth then
		humanoid:TakeDamage(-(humanoid.MaxHealth - humanoid.Health))
	else
		humanoid:TakeDamage(-amount)
	end
end


engine.Events.MedicEvent.OnServerEvent:Connect(function(player: Player, preparate: number, target: Model, limb: BasePart?, wound: BasePart?)
	if (not preparate) or (not target) then
		player:Kick("卐卐卐卐卐 Dont exploit in my game")
	end

	if (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
		warn("Too far away!")
		return
	end
	
	--print(player)
	--print(preparate)
	--print(target)
	--print(limb)
	--print(wound)

	local targetClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
	targetClient = target:FindFirstChild("BGS_Client")
	local playerClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
	playerClient = player.Character:FindFirstChild("BGS_Client")

	if (not targetClient) or (not playerClient) then
		warn("No client!")
		return
	end
	
	-------------------------------------
	
	
	local function promptPreparateApplication(): boolean
		if player.Character ~= target then
			local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(target)
			if targetPlayer and not targetClient:GetAttribute("Unconscious") and target:FindFirstChildWhichIsA("Humanoid").Health > 0 then
				return engine.Events.PromptPreparateApplication:InvokeClient(targetPlayer, preparate, player)
			else
				return true
			end
		else 
			return true
		end
	end
	
	
	
	
	-----------------------------------------------------
	
	
	if preparate == preparateEnum.Gauze and wound then
		print("sending request to client to apply gauze")
		
		local despacedName = string.gsub(wound.Parent.Name, " ", "")
		
		if not wound.IsBandaged.Value then
			if playerClient.Kit.Gauze.Value > 0 then
				if not promptPreparateApplication() then 
					engine.Events.MedicEvent:FireClient(player, "Declined")
					return 
				end
				engine.Events.MedicEvent:FireClient(player, "Accepted")
				playerClient.Kit.Gauze.Value -= 1
				
				wait(preparateEnum.waitingTimes[preparate+1])
				if not player or not player.Character or not playerClient or not target or not targetClient 
					or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
					return
				end
				
				if wound.Parent.Name ~= "Lungs" then
					wound.IsBandaged.Value = true
					if targetClient:GetAttribute(despacedName.."Tourniquet") then
						wound.Particles.Rate = 0.1
					else
						wound.Particles.Rate = 0.5
					end
					
				end
			else
				engine.Events.MedicEvent:FireClient(player, "Noitem")
				return
				
			end
		else
			if not promptPreparateApplication() then 
				engine.Events.MedicEvent:FireClient(player, "Declined")
				return 
			end
			engine.Events.MedicEvent:FireClient(player, "Accepted")
			
			wait(preparateEnum.waitingTimes[preparate+1])
			if not player or not player.Character or not playerClient or not target or not targetClient 
				or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
				return
			end
			
			playerClient.Kit.Gauze.Value += 1
			wound.IsBandaged.Value = false
			if targetClient:GetAttribute(despacedName.."Tourniquet") then
				wound.Particles.Rate = 1
			else
				wound.Particles.Rate = 7
			end
		end
			
		
		
		
	elseif preparate == preparateEnum.Tourniquet and limb then
		
		local despacedName = string.gsub(limb.Name, " ", "")
		if targetClient:GetAttribute(despacedName.."Tourniquet") == false then
			if playerClient.Kit.Tourniquet.Value < 1 then
				engine.Events.MedicEvent:FireClient(player, "Noitem")
				return
			end
			if not promptPreparateApplication() then 
				engine.Events.MedicEvent:FireClient(player, "Declined")
				return 
			end
			engine.Events.MedicEvent:FireClient(player, "Accepted")
			print("adding tourniquet")
			playerClient.Kit.Tourniquet.Value -= 1
			wait(preparateEnum.waitingTimes[preparate+1])
			if not player or not player.Character or not playerClient or not target or not targetClient 
				or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
				return
			end
			
			targetClient:SetAttribute(despacedName.."Tourniquet", true)
			
			local visual = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Tourniquet:Clone()
			visual.Parent = limb
			visual:PivotTo(limb.CFrame)
			visual.Main.BodyAttach.Part1 = limb
			
			for _, inst in limb:GetChildren() do
				if inst.Name == "Wound" and not inst.IsBandaged.Value then
					inst.Particles.Rate = 1
				elseif inst.Name == "Wound" and inst.IsBandaged.Value then
					inst.Particles.Rate = 0.1
				end
			end
			
		elseif targetClient:GetAttribute(despacedName.."Tourniquet") then
			if not promptPreparateApplication() then 
				engine.Events.MedicEvent:FireClient(player, "Declined")
				return 
			end
			engine.Events.MedicEvent:FireClient(player, "Accepted")
			print("removing tourniquet")
			wait(preparateEnum.waitingTimes[preparate+1])
			if not player or not player.Character or not playerClient or not target or not targetClient 
				or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
				return
			end
			playerClient.Kit.Tourniquet.Value += 1
			targetClient:SetAttribute(despacedName.."Tourniquet", false)
			if limb:FindFirstChild("Tourniquet") then limb.Tourniquet:Destroy() end
			
			for _, inst in limb:GetChildren() do
				if inst.Name == "Wound" and not inst.IsBandaged.Value then
					wound.Particles.Rate = 7
				elseif inst.Name == "Wound" and inst.IsBandaged.Value then
					wound.Particles.Rate = 0.5
				end
			end
		else
			print("nah")
		end

		
		
		
	elseif preparate == preparateEnum.PlasticCover then
		
		print("sending request to client to apply plastic cover")
		
			
		if not wound.Covered.Value then
			if playerClient.Kit.PlasticCover.Value > 0 then
				if not promptPreparateApplication() then 
					engine.Events.MedicEvent:FireClient(player, "Declined")
					return 
				end
				engine.Events.MedicEvent:FireClient(player, "Accepted")
				playerClient.Kit.PlasticCover.Value -= 1
				wait(preparateEnum.waitingTimes[preparate+1])
				if not player or not player.Character or not playerClient or not target or not targetClient 
					or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
					return
				end
				if wound.Parent.Name == "Lungs" then
					wound.Covered.Value = true
					wound.Particles.Rate = 0.5
				end
			else
				engine.Events.MedicEvent:FireClient(player, "Noitem")
			end
		else 
			if not promptPreparateApplication() then 
				engine.Events.MedicEvent:FireClient(player, "Declined")
				return 
			end
			engine.Events.MedicEvent:FireClient(player, "Accepted")
			wait(preparateEnum.waitingTimes[preparate+1])
			if not player or not player.Character or not playerClient or not target or not targetClient 
				or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
				return
			end
			playerClient.Kit.PlasticCover.Value += 1
			wound.Covered.Value = false
			wound.Particles.Rate = 7
		end
		
		
	elseif preparate == preparateEnum.SutureKit and wound then
		if playerClient.Kit.SutureKit.Value > 0 then
			if not promptPreparateApplication() then
				engine.Events.MedicEvent:FireClient(player, "Declined")
				return
			end
			engine.Events.MedicEvent:FireClient(player, "Accepted")
			playerClient.Kit.SutureKit.Value -= 1
			wait(preparateEnum.waitingTimes[preparate+1])
			if not player or not player.Character or not playerClient or not target or not targetClient 
				or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
				return
			end
			wound:Destroy()
		else
			engine.Events.MedicEvent:FireClient(player, "Noitem")
		end
		
	elseif preparate == preparateEnum.Painkiller then
		if playerClient.Kit.Morphine.Value < 1 then 
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return 
		end
		
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		targetClient.AppliedMedication.AmountOfMorphine.Value += 10
		targetClient.Vitals.Pain.Value = math.max(targetClient.Vitals.Pain.Value - 10, 0)
		
	elseif preparate == preparateEnum.Morphine then
		
		if playerClient.Kit.Morphine.Value < 1 then 
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return 
		end

		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")

		playerClient.Kit.Morphine.Value -= 1
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		targetClient.AppliedMedication.AmountOfMorphine.Value += 100
		targetClient.Vitals.Pain.Value = math.max(targetClient.Vitals.Pain.Value - 100, 0)
		
	elseif preparate == preparateEnum.Caffeine then
		
		if playerClient.Kit.Caffeine.Value < 1 then 
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return 
		end
		
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		
		playerClient.Kit.Caffeine.Value -= 1
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		
		targetClient.AppliedMedication.AmountOfCaffeine.Value += 200
		heal(target:FindFirstChildWhichIsA("Humanoid"),30)
		
		
	elseif preparate == preparateEnum.BloodBag then
		
		if playerClient.Kit.Bloodbag.Value < 1 then
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return
		end
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		playerClient.Kit.Bloodbag.Value -= 1
		
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		targetClient.Vitals.Blood.Value = math.clamp(targetClient.Vitals.Blood.Value + 2000, 0, 5000)
		
	elseif preparate == preparateEnum.Splint and limb then
		
		if playerClient.Kit.Splint.Value < 1 then
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return
		end
		
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		
		playerClient.Kit.Splint.Value -= 1
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		local despacedName = string.gsub(limb.Name, " ", "")
		targetClient:SetAttribute(despacedName.."Broken", false) --placeholder
		
		
	elseif preparate == preparateEnum.CPR then
		
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		if targetClient:GetAttribute("ClinicalDeath") then
			targetClient:SetAttribute("ClinicalDeath", false)
		end
		
	elseif preparate == preparateEnum.DrawBlood then
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		if targetClient.Vitals.Blood.Value > 2000 then
			targetClient.Vitals.Blood.Value -= 2000
			playerClient.Kit.Bloodbag.Value += 1
		end
		
	elseif preparate == preparateEnum.Defibrillator then
		
		if not playerClient.Kit.Defibrillator.Value then
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return
		end
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		if target:FindFirstChildWhichIsA("Humanoid").Health <= 0 then return end
		
		if targetClient:GetAttribute("ClinicalDeath") then
			targetClient:SetAttribute("ClinicalDeath", false)
		end 
		
		if targetClient.Vitals.IsHavingAHeartAttack.Value and target:FindFirstChildWhichIsA("Humanoid").Health > 0 then
			targetClient.Vitals.IsHavingAHeartAttack.Value = false
			if not targetClient:GetAttribute("Unconscious") and not targetClient:GetAttribute("ClinicalDeath") then
				ragdollModule.Unragdoll(target)
			end
		else
			target:FindFirstChildWhichIsA("Humanoid"):TakeDamage(20)
		end
		
	elseif preparate == preparateEnum.Epinephrine then
		if playerClient.Kit.Epinephrine.Value < 1 then 
			engine.Events.MedicEvent:FireClient(player, "Noitem")
			return 
		end

		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		engine.Events.MedicEvent:FireClient(player, "Accepted")

		playerClient.Kit.Epinephrine.Value -= 1
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		targetClient.AppliedMedication.AmountOfEpinephrine.Value += 100
		heal(target:FindFirstChildWhichIsA("Humanoid"),15)
		
	elseif preparate == preparateEnum.Amputation and limb then
		if not promptPreparateApplication() then
			engine.Events.MedicEvent:FireClient(player, "Declined")
			return
		end
		
		engine.Events.MedicEvent:FireClient(player, "Accepted")
		
		wait(preparateEnum.waitingTimes[preparate+1])
		if not player or not player.Character or not playerClient or not target or not targetClient 
			or (player.Character.Head.Position - target.Head.Position).Magnitude > 10 then
			return
		end
		
		local motor: Motor6D? = nil
		local joint: BallSocketConstraint? = nil
		local CFmodifier: CFrame = nil
		
		if limb.Name == "Left Arm" then
			motor = target.Torso:FindFirstChild("Left Shoulder")
			joint = target.Torso:FindFirstChild("Left Shoulder Ball")
			CFmodifier = CFrame.fromOrientation(math.rad(90),0,0)
		elseif limb.Name == "Right Arm" then
			motor = target.Torso:FindFirstChild("Right Shoulder")
			joint = target.Torso:FindFirstChild("Right Shoulder Ball")
			CFmodifier = CFrame.fromOrientation(math.rad(90),0,0)
		elseif limb.Name == "Left Leg" then
			motor = target.Torso:FindFirstChild("Left Hip")
			joint = target.Torso:FindFirstChild("Left Hip Ball")
			CFmodifier = CFrame.fromOrientation(math.rad(180),0,0)
		elseif limb.Name == "Right Leg" then
			motor = target.Torso:FindFirstChild("Right Hip")
			joint = target.Torso:FindFirstChild("Right Hip Ball")
			CFmodifier = CFrame.fromOrientation(math.rad(180),0,0)
		end
		
		
		if motor and motor.Enabled then
			
			local axewound = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Wound:Clone()
			
			axewound.Parent = target.Torso
			axewound.BleedingRate.Value = 80
			axewound.Particles.Rate = 15
			axewound.CFrame = target.Torso.CFrame * motor.C0 * CFmodifier
			local weld = Instance.new("WeldConstraint")
			weld.Parent = axewound
			weld.Part0 = axewound
			weld.Part1 = target.Torso
			
			
			motor.Enabled = false
			motor:Destroy()
		end
		
		if joint and joint.Enabled then
			joint.Enabled = false
			joint:Destroy()
		end
		
		local cover = Instance.new("Part")
		cover.Size = limb.Size
		cover.CFrame = limb.CFrame
		cover.Parent = limb
		cover.Transparency = 1
		local weld = Instance.new("WeldConstraint")
		weld.Parent = cover
		weld.Part0 = cover
		weld.Part1 = limb
		cover.CanCollide = true
		limb:SetAttribute("KeepVisible", true)
		--limb.Parent = workspace.BGS.CharacterPieces
		
		targetClient.Vitals.Pain.Value += (150 / (1 + (targetClient.AppliedMedication.AmountOfMorphine.Value / 100)))
		
		
	
		
		
	else
		warn("Unknown action!")
	end
	
end)


game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:FindFirstChildWhichIsA("Humanoid").BreakJointsOnDeath = false
	end)
end)