-- reminder: use
--workspace:ArePartsTouchingOthers({goremodel, wound})
-- when goring limbs to remove wounds out of range
local goreFolder = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Gore

script.Gorify.Event:Connect(function(limb: BasePart, damageDealt: number)
	local character = limb.Parent
	local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
	client = character:FindFirstChild("BGS_Client")
	
	if not limb or not character or not client then return end
	
	if limb.Name == "Head" then
		client:SetAttribute("HeadDamage", client:GetAttribute("HeadDamage") + damageDealt)
		if client:GetAttribute("HeadDamage") > 110 then
			local cover = goreFolder.GoredHead:Clone()
			
			cover.Parent = limb
			cover.CFrame = limb.CFrame
			cover.WeldConstraint.Part1 = limb
			
			cover.Limb.Color = limb.Color
			
			limb.Transparency = 1
		end
	elseif limb.Name == "Torso" or limb.Name == "HumanoidRootPart" or limb.Name == "Lungs" then
		client:SetAttribute("TorsoDamage", client:GetAttribute("TorsoDamage") + damageDealt)
		--print(client:GetAttribute("TorsoDamage"))
		if client:GetAttribute("TorsoDamage") > 200 then
			if not character:FindFirstChild("TorsoLowerGored") then
				limb = character:FindFirstChild("Torso")
				
				local uppergored = goreFolder.TorsoUpperGored:Clone()
				local lowergored = goreFolder.TorsoLowerGored:Clone()
				
				uppergored.Parent = limb
				lowergored.Parent = character
				
				uppergored.CFrame = limb.CFrame
				lowergored.CFrame = limb.CFrame
				
				uppergored.WeldConstraint.Part1 = limb
				
				limb.Transparency = 1
				
				uppergored.Limb.Color = character:FindFirstChildWhichIsA("BodyColors").TorsoColor3
				lowergored.Limb.Color = character:FindFirstChildWhichIsA("BodyColors").TorsoColor3
				
				if character:FindFirstChildWhichIsA("Shirt") then
					uppergored.Limb.Clothe.Texture = character:FindFirstChildWhichIsA("Shirt").ShirtTemplate
					lowergored.Limb.Clothe.Texture = character:FindFirstChildWhichIsA("Shirt").ShirtTemplate
				else
					uppergored.Limb.Clothe.Texture = "0"
					lowergored.Limb.Clothe.Texture = "0"
				end
				
				if limb:FindFirstChild("Left Hip") then
					if limb:FindFirstChild("Left Hip Ball") then limb:FindFirstChild("Left Hip Ball"):Destroy() end
					local a1 = Instance.new("Attachment")
					a1.Parent = character["Left Leg"]
					a1.CFrame = limb["Left Hip"].C1
					
					limb["Left Hip"]:Destroy()
					
					lowergored.LeftLegSocket.Attachment1 = a1
				end
				if limb:FindFirstChild("Right Hip") then
					
					if limb:FindFirstChild("Right Hip Ball") then limb:FindFirstChild("Right Hip Ball"):Destroy() end	
					
					local a1 = Instance.new("Attachment")
					a1.Parent = character["Right Leg"]
					a1.CFrame = limb["Right Hip"].C1
					
					limb["Right Hip"]:Destroy()

					lowergored.RightLegSocket.Attachment1 = a1
				end
				
				local overlapParams = OverlapParams.new()
				overlapParams.FilterType = Enum.RaycastFilterType.Include
				overlapParams.FilterDescendantsInstances = {uppergored.Limb}
				for _,i in limb:GetDescendants() do
					if i.Name == "Wound" and i:IsA("BasePart") then
						i.CanTouch = true
						if #workspace:GetPartsInPart(i, overlapParams) > 0 then
							print("have touch")
						else
							i:Destroy()
							print("no touch")
						end
						i.CanTouch = false
					end
				end
			end
		end
	else
		if limb.Name == "Limb" then return end
		local despacedName = string.gsub(limb.Name, " ", "")
		if not client:GetAttribute(despacedName.."Damage") then return end
		client:SetAttribute(despacedName.."Damage", client:GetAttribute(despacedName.."Damage") + damageDealt)
		
		
		if client:GetAttribute(despacedName.."Damage") > 30 then
			if not limb:FindFirstChild("Gored") then
				client:SetAttribute(despacedName.."Damage", 0)
				local model = nil
				
				if despacedName == "LeftLeg" or despacedName == "LeftArm" then
					model = goreFolder.GoredLimbLeft:Clone()
				else
					model = goreFolder.GoredLimbRight:Clone()
				end
				
				model.Parent = limb
				--limb.Size = Vector3.new(1,1.2,1)
				--limb.CFrame *= CFrame.new(0,0.3,0)
				limb.CanQuery = false
				
				limb.Transparency = 1
				model.CFrame = limb.CFrame
				model.WeldConstraint.Part1 = limb
				model.Name = "Gored"
				
				model.Limb.Color = limb.Color
				if (character:FindFirstChildWhichIsA("Shirt") and string.find(limb.Name, "Arm")) then
					model.Limb.Clothe.Texture = character:FindFirstChildWhichIsA("Shirt").ShirtTemplate
				elseif(character:FindFirstChildWhichIsA("Pants") and string.find(limb.Name, "Leg")) then
					model.Limb.Clothe.Texture = character:FindFirstChildWhichIsA("Pants").PantsTemplate
				else
					model.Limb.Clothe.Texture = 0
				end
				
				local overlapParams = OverlapParams.new()
				overlapParams.FilterType = Enum.RaycastFilterType.Include
				overlapParams.FilterDescendantsInstances = {model.Blood}
				
				for _,i in limb:GetDescendants() do
					if i.Name == "Wound" and i.Parent ~= model and i:IsA("BasePart") then
						i.CanTouch = true
						if #workspace:GetPartsInPart(i, overlapParams) > 0 then
							print("have touch")
						else
							i:Destroy()
							print("no touch")
						end
						i.CanTouch = false
					end
				end
			end
		end
	end
end)

function die(player, character)
	print("in 15 sec respawning "..player.Name)
	character.Archivable = true
	wait(game.Players.RespawnTime)
	local corpse = character:Clone()
	corpse.Parent = workspace.BGS.Corpses
	corpse:FindFirstChildWhichIsA("Humanoid").AutoRotate = false
	corpse:FindFirstChildWhichIsA("Humanoid").PlatformStand = true
	--require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Ragdoll).Ragdoll(corpse)

	local corpseClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
	corpseClient = corpse:FindFirstChild("BGS_Client")

	local medsysToRemove: Script = corpseClient:FindFirstChild("MedsysDelocalized")
	if medsysToRemove then
		medsysToRemove.Enabled = false
		medsysToRemove:Destroy()
	end
	for i,v in corpseClient:GetChildren() do
		if v:IsA("LocalScript") then
			v:Destroy()
		end
	end

	if corpseClient.CarryValues.CarriedBy.Value then

	end

	if workspace.BGS.Drones:FindFirstChild(player.Name.."Drone") then
		workspace.BGS.Drones:FindFirstChild(player.Name.."Drone"):Destroy()
	end

	player:LoadCharacter()
end

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		print("new respawn cycle for " .. player.Name)
		local dead = false
		
		character:FindFirstChildWhichIsA("Humanoid").HealthChanged:Connect(function(health)
			if health <= 0 and not dead then
				dead = true
				die(player, character)
			end
		end)
		
		character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
			if not dead then
				dead = true
				die(player, character)
			end
		end)
		
	end)
	
	player:LoadCharacter()
end)