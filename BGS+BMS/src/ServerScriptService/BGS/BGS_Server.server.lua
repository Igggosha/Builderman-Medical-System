--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SecureCast = require(ReplicatedStorage.BGS_Engine.Modules.SecureCast)
local simulationModule = require(ReplicatedStorage.BGS_Engine.Modules.SecureCast.Simulation)

local MAXIMUM_LATENCY = 0.8 -- 800 ms

local Events = ReplicatedStorage.BGS_Engine.Events
local SimulateEvent = Events.Simulate

--> Only call once per context
SecureCast.Initialize()

Players.PlayerAdded:Connect(function(Player: Player)
	--> We must parent all characters to the Characters folder within workspace
	Player.CharacterAdded:Connect(function(Character)
		RunService.PostSimulation:Wait()
		Character.Parent = workspace.Characters
	end)

	--> Disable raycast interactions with accessories
	Player.CharacterAppearanceLoaded:Connect(function(Character)
		for _, Child in Character:GetChildren() do
			if not Child:IsA("Accessory") then
				continue
			end

			local Handle: BasePart? = Child:FindFirstChild("Handle") :: BasePart
			if Handle then
				Handle.CanQuery = false
			end
		end
	end)
end)

function simulate(Player: Player, 
	Origin: Vector3, 
	Direction: Vector3, 
	Timestamp: number, 
	name: string, 
	accountForPlayerDistance: boolean, 
	simulateAlways: boolean, 
	modifier: simulationModule.Modifier?
)
	--> It is best to have calculate these values at the top
	--> We can have the most accurate latency values this way
	--> Calculating them further down may result in skewed results

	--> We must take into account character interpolation
	--> The best estimate for this value available is (PLAYER_PING + 48 ms)
	--> If we do not factor in interpolation we will end up with inaccurate lag compensation
	local Time = os.clock()
	local Latency = (workspace:GetServerTimeNow() - Timestamp)
	local Interpolation = (Player:GetNetworkPing() + SecureCast.Settings.Interpolation)

	--> Validate the latency and avoid players with very slow connections
	if (Latency < 0) or (Latency > MAXIMUM_LATENCY) then
		print("latency too big")
		return
	end

	--> Validate the projectile origin
	local Character = Player.Character
	
	if accountForPlayerDistance then
		local Handle = Character and Character:FindFirstChildWhichIsA("Tool") and Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Handle") :: BasePart
		if not Handle then
			print("no handle")
			return 
		end

	
		local Distance = (Origin - Handle.Position).Magnitude
		if Distance > 15 then
			warn(`{Player} is too far from the projectile origin.`)
			return
		end
	end
	--> Replicate the projectile to all other clients
	if simulateAlways then
		game:GetService("ReplicatedStorage").BGS_Engine.Events.SimulateWithNoPlayerCheck:FireAllClients(Player, name, Origin, Direction)
	else
		SimulateEvent:FireAllClients(Player, name, Origin, Direction)
	end
	
--	print("simulating")
	--> Cast the projectile within our own simulation

	SecureCast.Cast(Player, name, Origin, Direction, Time - Latency - Interpolation, nil, modifier)
end

ReplicatedStorage.BGS_Engine.Events.Simulate.OnServerEvent:Connect(function(Player: Player, Origin: Vector3, Direction: Vector3, Timestamp: number, name: string, checkDistance: boolean, modifier: simulationModule.Modifier, ignoreInstances: {Instance})
	
	if modifier then
		local raycastFilter = RaycastParams.new()
		raycastFilter.FilterType = Enum.RaycastFilterType.Exclude
		raycastFilter.FilterDescendantsInstances = ignoreInstances or {}
		modifier.RaycastFilter = raycastFilter
	end
	
	simulate(Player, Origin, Direction, Timestamp, name, checkDistance, false, modifier)
	--print(modifier.Velocity)
	--print(modifier.RaycastFilter)
end)

ReplicatedStorage.BGS_Engine.Events.SimulateServerside.Event:Connect(function(Player: Player, Origin: Vector3, Direction: Vector3, Timestamp: number, name: string)
	simulate(Player, Origin, Direction, Timestamp, name, false, true, nil)
end)