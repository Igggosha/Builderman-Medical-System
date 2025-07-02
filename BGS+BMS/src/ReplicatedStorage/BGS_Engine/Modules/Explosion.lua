local module = {}

local SS = game:GetService("ServerScriptService")

local map = require(script.Parent.Map)

function module.Explode (position: Vector3, power: number?, radius: number?, causer: Player?)
	
	if not power then power = 1500 end
	if not radius then radius = power / 75 end
	
	local explosion = Instance.new("Explosion")
	explosion.ExplosionType = Enum.ExplosionType.NoCraters
	explosion.Parent = workspace.BGS.Explosions
	explosion.Position = position
	explosion.BlastPressure = math.min(power * 50, 100000)
	explosion.DestroyJointRadiusPercent = 0
	explosion.BlastRadius = radius

	local connection = explosion.Hit:Connect(function(part, distance)

		

		if part.Name == "Limb" then
			part = part.Parent.Parent.Parent
			if not part:IsA("BasePart") then return end
		end

		local event: BindableEvent = part:FindFirstChild("DealDamage")
		if event then
			event:Fire(power / (math.round(distance)+ 1))
		end

		local humanoid: Humanoid = part.Parent:FindFirstChildWhichIsA("Humanoid") or (part.Parent ~= workspace and part.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid"))

		if not humanoid then
			if part.Name ~= "NONBREAK" and (not part:GetAttribute("NONBREAK")) and (not part:FindFirstAncestor("Roads")) and distance < radius / 2 and power > 1400 and (not part:FindFirstAncestor("Hills")) then
				part.Anchored = false
				for i,v in part:GetChildren() do
					if (v:IsA("Attachment") or v:IsA("WeldConstraint") or v:IsA("JointInstance")) and v.Name ~= "NONBREAK" then v:Destroy() end
				end
				coroutine.resume(coroutine.create(function()
					task.wait(10)
					if part:GetAttribute("Destroyable") and math.random(1,2) == math.random(1,2) then
						part:Destroy()
						return
					end
					task.wait(20)
					if not part or not part.Parent then return end
					while (not workspace:ArePartsTouchingOthers({part})) do
						task.wait(10)
						if not part or not part.Parent then return end
						
					end
					part.Anchored = true
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Include
					params.FilterDescendantsInstances = {workspace.Terrain}
					
					
					
					local raycastResult = workspace:Raycast(part.Position + Vector3.new(0,5,0), Vector3.new(0,-7,0), params)

					if raycastResult  then
						--print(raycastResult.Material)
						if raycastResult.Material == Enum.Material.Water then
							part:Destroy()
						end
					end
					
					
				end))
			end
			return 
		end -- i might regret this!

		local roll = math.random(0, distance * 100) / 100
		
		
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
		client = humanoid.Parent:FindFirstChild("BGS_Client")
		if not client then return end
		
		local damage = math.random(100,200)/100 * 40 / math.ceil(distance) * radius
		
		if causer then
			humanoid:SetAttribute("LastDamagedBy", causer.Name)
		end
		
		humanoid:TakeDamage(math.random(100,200)/100 * 40 / math.ceil(distance) * radius)
		client.Vitals.Pain.Value += damage * 2 * math.random(50,200) / 100
		


		if roll < 15 then
			
			local reducingFactor = (math.random(50, 200) / 100)
			humanoid:TakeDamage(200 / reducingFactor / distance)
			client.Vitals.Pain.Value += (250 / reducingFactor / distance)

			if roll < 1 then

				client.Vitals.Pain.Value += 300
				if part.Name == "Head" then
					humanoid:TakeDamage(200)
					if humanoid.Parent.Torso:FindFirstChild("Neck") then humanoid.Parent.Torso.Neck:Destroy() end
					SS.GoreHandler.Gorify:Fire(part, 200)
				elseif part.Name == "Torso" or part.Name == "HumanoidRootPart" or part.Name == "Lungs" then
					humanoid:TakeDamage(200)
					SS.GoreHandler.Gorify:Fire(part, 200)
				elseif part.Name == "Right Arm" and humanoid.Parent.Torso:FindFirstChild("Right Shoulder") then
					humanoid:TakeDamage(30)
					SS.GoreHandler.Gorify:Fire(part, 200)
					humanoid.Parent.Torso["Right Shoulder"]:Destroy()
				elseif part.Name == "Right Leg" and humanoid.Parent.Torso:FindFirstChild("Right Hip") then
					humanoid:TakeDamage(30)
					SS.GoreHandler.Gorify:Fire(part, 200)
					humanoid.Parent.Torso["Right Hip"]:Destroy()
				elseif part.Name == "Left Arm" and humanoid.Parent.Torso:FindFirstChild("Left Shoulder") then
					humanoid:TakeDamage(30)
					SS.GoreHandler.Gorify:Fire(part, 200)
					humanoid.Parent.Torso["Left Shoulder"]:Destroy()
				elseif part.Name == "Left Leg" and humanoid.Parent.Torso:FindFirstChild("Left Hip") then
					humanoid:TakeDamage(30)
					SS.GoreHandler.Gorify:Fire(part, 200)
					humanoid.Parent.Torso["Left Hip"]:Destroy()
				end 
			end
		end

	end)

	local soundHolder = Instance.new("Part")
	soundHolder.CanCollide = false
	soundHolder.CanTouch = false
	soundHolder.CanQuery = false
	soundHolder.Anchored = true
	soundHolder.Transparency = 1
	soundHolder.Parent = workspace.BGS.Explosions
	soundHolder.Position = position

	local sound = game:GetService("ReplicatedStorage").BGS_Engine.FX.ExplodeSound:Clone()
	sound.Parent = soundHolder
	sound.Volume = map.map(radius, 10, 50, 3, 7)
	sound.RollOffMaxDistance = math.min( map.map(radius, 5, 20, 5000, 15000), 15000)
	sound:Play()

	local co = coroutine.create(function()
		sound.Ended:Wait()

		soundHolder:Destroy()
		connection:Disconnect()
	end)
	coroutine.resume(co)
end


return module
