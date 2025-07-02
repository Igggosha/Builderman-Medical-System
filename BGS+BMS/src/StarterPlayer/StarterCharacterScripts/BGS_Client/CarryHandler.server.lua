local ragdollModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Ragdoll)
local thisClient = script.Parent
local thisCharacter: Model = script.Parent.Parent


local carryValues = script.Parent.CarryValues

function dropCharacter()
	if not thisClient.CarryValues.Carrying.Value then return end
	
	
	--if thisCharacter.Torso:FindFirstChild("CarryingWeld") then
	--	thisCharacter.Torso:FindFirstChild("CarryingWeld"):Destroy()
	--end
	
	thisCharacter.BackpackEnabledManager.Carrying.Value = false
	
	local otherCharacter = carryValues.Carrying.Value
	if not otherCharacter then return end
	
	thisClient.CarryValues.Carrying.Value = nil
	otherCharacter:FindFirstChild("BGS_Client").CarryValues.CarriedBy.Value = nil
	
	--if not otherCharacter:FindFirstChild("BGS_Client"):GetAttribute("Unconscious") then
		
	--	ragdollModule.Unragdoll(otherCharacter)
	--end
	
	
	otherCharacter.Torso.Anchored = false
	otherCharacter.PrimaryPart = otherCharacter.Head
	
	for i,v in otherCharacter:GetDescendants() do
		if v:IsA("BasePart") and v.CanCollide then
			v.CollisionGroup = "Default"
		end
	end
end

local CarryingCharacterDiedConnection: RBXScriptConnection = nil

script.CarryEvent.OnServerEvent:Connect(function(player, action, targetCharacter: Model)
	
	local otherClient
	if action == "CarryOther" then
		otherClient = targetCharacter:FindFirstChild("BGS_Client")
	else
		targetCharacter = script.Parent.CarryValues.Carrying.Value
		otherClient = targetCharacter:FindFirstChild("BGS_Client")
	end
	
	
	if action == "CarryOther" and player.Character == thisCharacter 
		and (thisCharacter:GetPivot().Position - targetCharacter:GetPivot().Position).Magnitude < 20 
		and ( otherClient:GetAttribute("Unconscious") or otherClient:GetAttribute("Surrendered") or targetCharacter:FindFirstChildWhichIsA("Humanoid").Health <= 0)
		and not thisClient.CarryValues.Carrying.Value	
	then
		
		
		thisClient.CarryValues.Carrying.Value = targetCharacter
		thisCharacter.BackpackEnabledManager.Carrying.Value = true
		-- a big problem is that players are ONLY trusted with movement of their character
		-- so the two options are weld joints/weld constraints OR moving an anchored second
		-- character
		-- this will require testing with multiple people with mid to high pings
		
		--local wc = Instance.new("WeldConstraint")
		--wc.Name = "CarryingWeld"
		--wc.Parent = thisCharacter.HumanoidRootPart
		--wc.Part0 = thisCharacter.HumanoidRootPart
		--wc.Part1 = targetCharacter.HumanoidRootPart
		--local puller = Instance.new("AlignPosition")
		--puller.Mode = Enum.PositionAlignmentMode.TwoAttachment
		--puller.Parent = thisCharacter.Torso
		--puller.Name = "CarryingWeld"
		--puller.Responsiveness = 200
		--puller.MaxForce = 4000
		--puller.Attachment1 = thisCharacter.Torso.BodyBackAttachment
		--puller.Attachment0 = targetCharacter.Torso.NeckAttachment
		
		targetCharacter.Torso.Anchored = true
		targetCharacter.PrimaryPart = targetCharacter.HumanoidRootPart

		--CarryingCharacterDiedConnection = targetCharacter:FindFirstChildWhichIsA("Humanoid").Died:Once(function()
		--	dropCharacter()
		--	CarryingCharacterDiedConnection = nil
		--end)

		for i,v in targetCharacter:GetDescendants() do
			if v:IsA("BasePart") and v.CanCollide then
				v.CollisionGroup = "Isolated"
			end
		end
			
		otherClient.CarryValues.CarriedBy.Value = thisCharacter
		
		--if not otherClient:GetAttribute("Unconscious") then -- no double ragdoll
		--	ragdollModule.Ragdoll(thisCharacter)
		--end
			
	
		
	elseif action == "ThrowOther" then
		dropCharacter()
		targetCharacter.HumanoidRootPart:ApplyImpulse(1000 * thisCharacter.Head.CFrame.LookVector)
		targetCharacter.Torso:ApplyImpulse(1000 * thisCharacter.Head.CFrame.LookVector)
		
	elseif action == "DropOther" then
		dropCharacter()
	end
end)


game:GetService("RunService").Heartbeat:Connect(function()
	thisClient = script.Parent
	thisCharacter = script.Parent.Parent
	
	if thisClient.CarryValues.Carrying.Value then
		local carriedCharacter: Model = thisClient.CarryValues.Carrying.Value

		carriedCharacter:PivotTo(thisCharacter.Torso.CFrame * CFrame.new( Vector3.new(2,1.5,0)) * CFrame.fromOrientation(math.rad(90),0,0)) --* CFrame.new(thisCharacter.Torso.CFrame:VectorToObjectSpace(Vector3.new(4,-4,0)))
		--print()
	
	end
	
	
	if thisClient.CarryValues.CarriedBy.Value then
		local otherClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		local otherCharacter = thisClient.CarryValues.CarriedBy.Value
		otherClient = otherCharacter:FindFirstChild("BGS_Client")
		
		if otherClient.CarryValues.Carrying.Value ~= thisCharacter then
			--if not thisClient:GetAttribute("Unconscious") then

			--	ragdollModule.Unragdoll(thisCharacter)
			--end
			thisCharacter.Torso.Anchored = false
			thisCharacter.PrimaryPart = thisCharacter.Head

			for i,v in thisCharacter:GetDescendants() do
				if v:IsA("BasePart") and v.CanCollide then
					v.CollisionGroup = "Default"
				end
			end
			
			otherCharacter.BackpackEnabledManager.Carrying.Value = false
			otherCharacter.CarryValues.Carrying.Value = nil
		end
	end
end)

local thisHumanoid = thisCharacter:FindFirstChildWhichIsA("Humanoid")
if thisHumanoid then
	thisHumanoid.Died:Connect(function()
		dropCharacter()
	end)
end