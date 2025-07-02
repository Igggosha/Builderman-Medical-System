local module = {}

local function playSelectedAtPos(name, position, normal: Vector3, part: BasePart)
--	print(name)
	local cover = Instance.new("Part")
	cover.Size = Vector3.new(0.4,0.4,0.1)
	cover.Massless = true
	cover.Transparency = 1
	cover.CanCollide = false
	cover.CanTouch = false
	cover.CanQuery = false
	--cover.Anchored = true
	cover.Parent = workspace.BGS.BulletHoles
	cover.Position = position
	cover.CFrame = CFrame.lookAt(cover.Position, cover.Position + normal)
	cover.Position = position
	
	local weld = Instance.new("WeldConstraint")
	weld.Parent = cover
	weld.Part0 = cover
	weld.Part1 = part
	
	
	local availableSunds: Folder = script[name]
	local sound: Sound =  availableSunds:GetChildren()[math.random(1, #availableSunds:GetChildren())]:Clone()
	
	sound.Parent = cover
	sound:Play()
	
	if part:GetAttribute("Shatter") then
		part:Destroy()
	end
	
	if name == "Flesh" or part:GetAttribute("Shatter") then
		sound.Ended:Wait()
		cover:Destroy()
		return
	end
	
	if name ~= "Flesh" and (not part:GetAttribute("Shatter")) then
		local bulletHole = game:GetService("ReplicatedStorage").BGS_Engine.Assets.BulletHole:Clone()
		bulletHole.Parent = cover
		bulletHole.Color3 = part.Color
		local emitter = game:GetService("ReplicatedStorage").BGS_Engine.Assets.BulletSmoke :Clone()
		emitter.Parent = cover
		wait()
		emitter.Enabled = false
		--emitter:Emit(10)
		--print("emit?")
		--wait()
		--emitter.Parent = game:GetService("ReplicatedStorage").BGS_Engine.Assets
	end
	
	
	--print(sound)
	--sound.Ended:Wait()
	wait(40)
	cover:Destroy()
end

function module.PlaySound(Position: Vector3, part: BasePart, isFlesh: boolean, normal: Vector3)
	if game:GetService("RunService"):IsServer() then
		script.HitEffect:FireAllClients(Position, part, isFlesh, normal)
	else
		local co = coroutine.create(function()
			local material = part.Material
		
			if isFlesh then
				playSelectedAtPos("Flesh", Position, normal, part)
			else
				if material == Enum.Material.Metal or material == Enum.Material.CorrodedMetal then
					playSelectedAtPos("Metal", Position, normal, part)
				elseif material == Enum.Material.Glass or part:GetAttribute("Shatter") then
					playSelectedAtPos("Glass", Position, normal, part)
				elseif material == Enum.Material.Wood or material == Enum.Material.WoodPlanks then
					playSelectedAtPos("Wood", Position, normal, part)
				elseif material == Enum.Material.Grass or material == Enum.Material.LeafyGrass then
					playSelectedAtPos("Grass", Position, normal, part)
				
				elseif material == Enum.Material.Plastic or material == Enum.Material.SmoothPlastic then
					--print("p")
					playSelectedAtPos("Polymer", Position, normal, part)
				
				else
					playSelectedAtPos("Generic", Position, normal, part)
				end
			end
		
		end)
		
		coroutine.resume(co)
	end
end

return module
