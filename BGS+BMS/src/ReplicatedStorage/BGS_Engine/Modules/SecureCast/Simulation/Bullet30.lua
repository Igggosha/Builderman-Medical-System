

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

local bulletModule = require(ReplicatedStorage.BGS_Engine.Modules.GenericBullet)

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
	bulletModule.OnImpact(Player, Direction, instance, Normal, Position, Material, 600, 840, 150, 350, 50, 100, 100)
end

local function OnDestroyed(Player: Player, Position: Vector3)
	if IS_SERVER then
		print("serverside impact")

		--ExplosionModule.Explode(Position, 150, 5)
	end
end

local function OnIntersection(Player: Player, Direction: Vector3, Part: string, Victim: Player, Position: Vector3)

end

---- Projectile ----

local Projectile: Simulation.Definition = {
	Loss = 0,
	Power = 30,
	Angle = 20,
	Collaterals = false,

	Gravity = -3,
	Velocity = 3400,

	Lifetime = 15,

	OnImpact = OnImpact,
	OnDestroyed = OnDestroyed,
	OnIntersection = OnIntersection
}

return Projectile