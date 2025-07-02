

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

---- Settings ----

local IS_CLIENT = RunService:IsClient()
local IS_SERVER = RunService:IsServer()

---- Functions ----


local fractureChance = 10

local keepCreatingWound = true
local bulletModule = require(ReplicatedStorage.BGS_Engine.Modules.GenericBullet)

local function OnImpact(Player: Player, Direction: Vector3, instance: Instance, Normal: Vector3, Position: Vector3, Material: Enum.Material)
	--DrawUtility.point(Position, nil, nil, 0.2)
	bulletModule.OnImpact(Player, Direction, instance, Normal, Position, Material, 60, 100, 15, 35, 5, 15, fractureChance)
end

local function OnDestroyed(Player: Player, Position: Vector3)
	
end

local function OnIntersection(Player: Player, Direction: Vector3, Part: string, Victim: Player, Position: Vector3)

end

---- Projectile ----

local Projectile: Simulation.Definition = {
	Loss = 0,
	Power = 7,
	Angle = 20,
	Collaterals = false,
	
	Gravity = -3,
	Velocity = 800,
	
	Lifetime = 5,
	
	OnImpact = OnImpact,
	OnDestroyed = OnDestroyed,
	OnIntersection = OnIntersection
}

return Projectile