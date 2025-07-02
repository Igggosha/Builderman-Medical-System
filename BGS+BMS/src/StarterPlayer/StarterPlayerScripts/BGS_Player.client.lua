--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local SecureCast = require(ReplicatedStorage.BGS_Engine.Modules.SecureCast)

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Events = ReplicatedStorage.BGS_Engine.Events
local SimulateEvent = Events.Simulate

--> Only call once per context
SecureCast.Initialize()

--UserInputService.InputBegan:Connect(function(Input, GPE)
script.Fire.Event:Connect(function(name, position: Vector3, amount, spread)
	--if GPE or Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
	--	return
	--end
	--print(position)
	local Origin
	local Character = Player.Character
	
	if not position then
		local Handle = Character and Character:FindFirstChildWhichIsA("Tool") and Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Handle")
		if not Handle then return end
		
		Origin = Handle.Position
	else
		Origin = position
	end
	
	local Direction = (Mouse.Hit.Position - Origin).Unit

	if not amount then amount = 1 end
	if not spread then spread = 0 end
	
	for i = 1, amount do
		local spreadVector = Vector3.new(math.random(-spread * 100, spread * 100) / 100, math.random(-spread * 100, spread * 100) / 100, 0)
		
		--> Replicate to the server
		--print("firing server event")
		SimulateEvent:FireServer(Origin, (Direction + spreadVector).Unit, workspace:GetServerTimeNow(), name)

		--> Cast the projectile within our own simulation
		SecureCast.Cast(Player, name, Origin, (Direction + spreadVector).Unit, os.clock())
	end
end)

SimulateEvent.OnClientEvent:Connect(function(Caster: Player, Type: string, Origin: Vector3, Direction: Vector3, PVInstance: PVInstance?, Modifer)
	if Caster ~= Player then
		SecureCast.Cast(Caster, Type, Origin, Direction, os.clock(), PVInstance, Modifer)
	end
end)

game:GetService("ReplicatedStorage").BGS_Engine.Events.SimulateWithNoPlayerCheck.OnClientEvent:Connect(function(Caster: Player, Type: string, Origin: Vector3, Direction: Vector3, PVInstance: PVInstance?, Modifer)
	SecureCast.Cast(Caster, Type, Origin, Direction, os.clock(), PVInstance, Modifer)
	
end)

script.FireInDirection.Event:Connect(function(name, Origin: Vector3, direction: Vector3, startingVelocity: Vector3?, ignoreInstances: {Instance})
	direction = direction.Unit
	
	--print("firing server event")
	
	local velocityMultiplier = 3400
	local finalVMagnitude = nil
	local finalVelocity = nil
	local finalDirection = direction
	
	if (name == "Bullet30" or name == "BulletMG") and startingVelocity then
		finalVelocity = direction * velocityMultiplier + startingVelocity
		finalVMagnitude = finalVelocity.Magnitude --- velocityMultiplier
		finalDirection = finalVelocity.Unit
	end
	
	local raycastFilter = RaycastParams.new()
	raycastFilter.FilterType = Enum.RaycastFilterType.Exclude
	raycastFilter.FilterDescendantsInstances = ignoreInstances or {}
	--print(ignoreInstances)
	
	SimulateEvent:FireServer(Origin, finalDirection, workspace:GetServerTimeNow(), name, false, {Velocity = finalVMagnitude, RaycastFilter = raycastFilter}, ignoreInstances)

	--> Cast the projectile within our own simulation
	SecureCast.Cast(Player, name, Origin, finalDirection, os.clock(), nil, {Velocity = finalVMagnitude, RaycastFilter = raycastFilter})
end)