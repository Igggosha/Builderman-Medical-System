

-- ******************************* --
-- 			AX3NX / AXEN		   --
-- ******************************* --

---- Services ----
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local SS = game:GetService("ServerScriptService")

---- Imports ----

local SecureCast = script.Parent.Parent
local Utility = SecureCast.Utility

local Simulation = require(SecureCast.Simulation)
local DrawUtility = require(Utility.Draw)

local SoundUtil = require(ReplicatedStorage.BGS_Engine.Modules.ImpactSound)

local ExplosionModule = require(script.Parent.Parent.Parent.Explosion)
---- Settings ----

local IS_CLIENT = RunService:IsClient()
local IS_SERVER = RunService:IsServer()

---- Functions ----


local fractureChance = 10

local keepCreatingWound = true

local function inflictDamage(Humanoid: Humanoid, partName: string, distance: number)
	
	
end

local function createWound(instance, Position, Normal)
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

local function OnImpact(Player: Player, Direction: Vector3, instance: Instance, Normal: Vector3, Position: Vector3, Material: Enum.Material)
	--DrawUtility.point(Position, nil, nil, 0.2)
	--print("impact")
	print(instance)
	if not instance or instance.Parent == Player.Character then 
		return 
	end
	
	
	
	if IS_SERVER then
		print(instance)
		print("serverside impact")
		
		keepCreatingWound = false
		
		ExplosionModule.Explode(Position, 1500, 20, Player)
		
		--[[
		--local explosion = Instance.new("Explosion")
		--explosion.Parent = workspace
		--explosion.Position = Position
		----explosion.BlastPressure = 0
		--explosion.DestroyJointRadiusPercent = 0
		--explosion.BlastRadius = 20
		
		--local connection = explosion.Hit:Connect(function(part, distance)
		--	local event: BindableEvent = part:FindFirstChild("DealDamage")
		--	if event then
		--		event:Fire(1500 / (math.round(distance)+ 1))
		--	end
			
		--	if part.Name == "Limb" then
		--		part = part.Parent.Parent
		--	end
			
		--	local humanoid = part.Parent:FindFirstChildWhichIsA("Humanoid") or (part.Parent ~= workspace and part.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid"))
			
		--	if not humanoid then return end -- i might regret this!
			
		--	local rpms = RaycastParams.new()
		--	rpms.FilterType = Enum.RaycastFilterType.Exclude
		--	rpms.FilterDescendantsInstances = {part, instance, part.Parent:FindFirstChild("HumanoidRootPart"), part.Parent:FindFirstChild("Torso"), part.Parent:FindFirstChild("Lungs")}
			
		--	--local canHitRay = workspace:Raycast(Position, part.Position - Position, rpms)
			
		--	--if canHitRay and canHitRay.Instance then return end
			
		--	print("alo")
		--	local roll = math.random(0, distance * 100) / 100
			
		--	if roll < 15 then
		--		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		--		client = humanoid.Parent:FindFirstChild("BGS_Client")
		--		if not client then return end
		--		humanoid:SetAttribute("LastDamagedBy", Player.Name)
		--		local reducingFactor = (math.random(50, 200) / 100)
		--		humanoid:TakeDamage(200 / reducingFactor / distance)
		--		client.Vitals.Pain.Value += (250 / reducingFactor / distance)
				
		--		if roll < 1 then
					
		--			client.Vitals.Pain.Value += 300
		--			if part.Name == "Head" then
		--				humanoid:TakeDamage(200)
		--				humanoid.Parent.Torso.Neck:Destroy()
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--			elseif part.Name == "Torso" or part.Name == "HumanoidRootPart" or part.Name == "Lungs" then
		--				humanoid:TakeDamage(200)
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--			elseif part.Name == "Right Arm" then
		--				humanoid:TakeDamage(30)
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--				humanoid.Parent.Torso["Right Shoulder"]:Destroy()
		--			elseif part.Name == "Right Leg" then
		--				humanoid:TakeDamage(30)
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--				humanoid.Parent.Torso["Right Hip"]:Destroy()
		--			elseif part.Name == "Left Arm" then
		--				humanoid:TakeDamage(30)
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--				humanoid.Parent.Torso["Left Shoulder"]:Destroy()
		--			elseif part.Name == "Left Leg" then
		--				humanoid:TakeDamage(30)
		--				SS.GoreHandler.Gorify:Fire(part, 200)
		--				humanoid.Parent.Torso["Left Hip"]:Destroy()
		--			end 
		--		end
		--	end
			
		--end)
		
		--local soundHolder = Instance.new("Part")
		--soundHolder.CanCollide = false
		--soundHolder.CanTouch = false
		--soundHolder.CanQuery = false
		--soundHolder.Anchored = true
		--soundHolder.Transparency = 1
		--soundHolder.Parent = workspace
		--soundHolder.Position = Position
		
		--local sound = ReplicatedStorage.BGS_Engine.FX.ExplodeSound:Clone()
		--sound.Parent = soundHolder
		--sound:Play()
		
		--sound.Ended:Wait()
		
		--soundHolder:Destroy()
		--connection:Disconnect()
		--]]
	end
	--Humanoid:TakeDamage(10) 
end

local function OnDestroyed(Player: Player, Position: Vector3)
	
end

local function OnIntersection(Player: Player, Direction: Vector3, Part: string, Victim: Player, Position: Vector3)
	local Character = Victim.Character
	print("idiot")
	local Humanoid: Humanoid? = Character and Character:FindFirstChild("Humanoid") :: Humanoid
	if not Humanoid or Humanoid.Health <= 0 then
		return
	end
	
	--inflictDamage(Humanoid, Part)
	
	--local wound = game:GetService("ReplicatedStorage").Wound:Clone()
	--wound.Parent = Character[Part]
	--wound.Position = Position

	--local weld = Instance.new("WeldConstraint")
	--weld.Parent = wound
	--weld.Part0 = wound
	--weld.Part1 = Character[Part]
	
	----Humanoid:TakeDamage(10) 
	--print(IS_CLIENT)
	--print(`Intersected {Victim}'s {Part}`)
end

---- Projectile ----

local Projectile: Simulation.Definition = {
	Loss = 0,
	Power = 0.01,
	Angle = 20,
	Collaterals = false,
	
	Gravity = -3,
	Velocity = 150,
	
	Lifetime = 15,
	
	OnImpact = OnImpact,
	OnDestroyed = OnDestroyed,
	OnIntersection = OnIntersection
}

return Projectile