id = {155288625} 
link = "rbxassetid://" 
hurt = Instance.new("Sound", script.Parent.Head) 
hurt.SoundId = (link..id[math.random(#id)]) 
local lowestFallHeight = math.random(18,25) 
local maxFallHeight = math.random(70,100) 


local character = script.Parent
local humanoid = character:FindFirstChildWhichIsA("Humanoid")
local torso: Part = character.Torso 
local replaceSound = coroutine.create(function()
	hurt.Ended:Wait()
	hurt.SoundId = (link..id[math.random(#id)]) 
end)

local currentlyFalling = false

local startHeight = nil

local map = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Map)

humanoid.FreeFalling:Connect(function(falling)
	if falling then
		if character:FindFirstChild("Parachute") then
			currentlyFalling = false
		else
			currentlyFalling = true
		end
		
		startHeight = torso.Position.Y
	else
		if currentlyFalling then
			currentlyFalling = false
			
			local differenceHeight = startHeight - torso.Position.Y
			if differenceHeight > lowestFallHeight then
				humanoid:TakeDamage(map.map(differenceHeight, 18, 70, 10, 130))
				hurt:Play()
				coroutine.resume(replaceSound)
			end
		end
	end
end)

character.ChildAdded:Connect(function(child)
	if child.Name == "Parachute" then
		currentlyFalling = false
		startHeight = torso.Position.Y
	end
end)

character.ChildRemoved:Connect(function(child)
	if child.Name == "Parachute" then
		currentlyFalling = true
		startHeight = torso.Position.Y
	end
end)