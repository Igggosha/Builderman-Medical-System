

-- ******************************* --
-- 			AX3NX / AXEN		   --
-- ******************************* --

---- Services ----
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local SS = game:GetService("ServerScriptService")

---- Imports ----

--local SecureCast = script.Parent.Parent
--local Utility = SecureCast.Utility

---local Simulation = require(SecureCast.Simulation)
--local DrawUtility = require(Utility.Draw)

local SoundUtil = require(ReplicatedStorage.BGS_Engine.Modules.ImpactSound)

---- Settings ----

local IS_CLIENT = RunService:IsClient()
local IS_SERVER = RunService:IsServer()

---- Functions ----



--local keepCreatingWound = true

local Module = {

}

function Module.inflictDamage(Humanoid: Humanoid, partName: string, headMinDamage, headMaxDamage, torsoMinDamage, torsoMaxDamage, limbMinDamage, limbMaxDamage, fractureChance)
	print(partName)
	if not Humanoid then return end
	local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
	client = Humanoid.Parent:FindFirstChild("BGS_Client")
	if not client then return end

	local callGore = true
	local keepCreatingWound = true

	if partName == "Head" then
		local damage = math.random(headMinDamage, headMaxDamage)
		if client.Armor.HelmetProtectionValue.Value > damage then
			damage /= 2
			callGore = false
			client.Armor.HelmetProtectionValue.Value -= (damage / 10)
			if client.Armor.HelmetProtectionValue.Value < 0 then
				client.Armor.HelmetProtectionValue.Value = 0
			end

			keepCreatingWound = false
		end
		Humanoid:TakeDamage(damage)
		client.Vitals.Pain.Value += (damage * 2 / (1 + (client.AppliedMedication.AmountOfMorphine.Value / 100)))
		local limb = Humanoid.Parent:FindFirstChild(partName)

		if callGore then
			SS.GoreHandler.Gorify:Fire(limb, damage)
		end

	elseif partName == "Torso" or partName == "Lungs" or partName == "HumanoidRootPart" then
		local damage = math.random(torsoMinDamage, torsoMaxDamage)
		if client.Armor.TorsoProtectionValue.Value > damage then
			damage /= 1.5
			callGore = false
			client.Armor.TorsoProtectionValue.Value -= (damage / 10)
			if client.Armor.TorsoProtectionValue.Value < 0 then
				client.Armor.TorsoProtectionValue.Value = 0
			end

			keepCreatingWound = false
		end
		Humanoid:TakeDamage(damage)
		client.Vitals.Pain.Value += (damage * 2 / (1 + (client.AppliedMedication.AmountOfMorphine.Value / 100)))
		local limb = Humanoid.Parent:FindFirstChild("Torso")
		if limb then
			if callGore then
				SS.GoreHandler.Gorify:Fire(limb, damage)
			end
		end
	else
		--limbs
		local damage = math.random(limbMinDamage, limbMaxDamage)
		Humanoid:TakeDamage(damage)
		client.Vitals.Pain.Value += (damage * 2 / (1 + (client.AppliedMedication.AmountOfMorphine.Value / 100)))
		local despacedPartName = string.gsub(partName, " ", "")

		if math.random(0,100) < fractureChance then
			client:SetAttribute(despacedPartName.."Broken", true)
		end

		local limb = Humanoid.Parent:FindFirstChild(partName)
		if limb then
			if callGore then
				SS.GoreHandler.Gorify:Fire(limb, damage)
			end
		end

	end
	
	return keepCreatingWound

end

function Module.createWound(instance, Position, Normal)
	local wound = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Wound:Clone()
	wound.Parent = instance
	--wound.Position = Position
	--print(Normal)
	wound.CFrame = CFrame.lookAt(Position, Position + Normal, Position + Vector3.new(0,1,0)) * CFrame.fromOrientation(math.rad(-90), 0, 0)

	local weld = Instance.new("WeldConstraint")
	weld.Parent = wound
	weld.Part0 = wound
	weld.Part1 = instance
end

function Module.OnImpact(Player: Player, Direction: Vector3, instance: Instance, Normal: Vector3, Position: Vector3, Material: Enum.Material, headMinDamage, headMaxDamage, torsoMinDamage, torsoMaxDamage, limbMinDamage, limbMaxDamage, fractureChance)
	--DrawUtility.point(Position, nil, nil, 0.2)
	--print("impact")
	--print(instance)
	if not instance or instance.Parent == Player.Character then 
		return 
	end
	if IS_SERVER then
		--print(instance)
		--print("serverside impact")

		local keepCreatingWound = true

		local event: BindableEvent = instance:FindFirstChild("DealDamage")
		if event then
			event:Fire(math.random(torsoMinDamage, torsoMaxDamage), Player)
		end

		local Humanoid: Humanoid? = instance.Parent:FindFirstChildWhichIsA("Humanoid")
		if (not Humanoid) and instance.Parent ~= workspace then
			Humanoid = instance.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid")
		end
		if not Humanoid then
			SoundUtil.PlaySound(Position, instance, false, Normal)
			return
		end

		print("humanoid found")

		if game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent) and game:GetService("Players"):GetPlayerFromCharacter(Humanoid.Parent).Team == Player.Team then return end


		SoundUtil.PlaySound(Position, instance, true, Normal)
		Humanoid:SetAttribute("LastDamagedBy", Player.Name)
		keepCreatingWound = Module.inflictDamage(Humanoid, instance.Name, headMinDamage, headMaxDamage, torsoMinDamage, torsoMaxDamage, limbMinDamage, limbMaxDamage, fractureChance)
		
		



		if not keepCreatingWound then return end

		Module.createWound(instance, Position, Normal)
	--[[ if client
		local Humanoid: Humanoid? = instance.Parent:FindFirstChildWhichIsA("Humanoid")
		if (not Humanoid) and instance.Parent ~= workspace then
			Humanoid = instance.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid")
		end
		if Humanoid then
			SoundUtil.PlaySound(Position, instance, true, Normal)
		else
			SoundUtil.PlaySound(Position, instance, false, Normal)
			return
		end
	--]]
	end
	--Humanoid:TakeDamage(10) 
end




return Module