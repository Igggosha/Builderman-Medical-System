local equalizer = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Equalizer
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local map = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Map)

function muffle(v: Instance)
	if v:IsA("Sound") and v.Parent:IsA("BasePart") then
		if not v:FindFirstChild("Equalizer") then
			equalizer:Clone().Parent = v
		end

		local thisEqualizer: EqualizerSoundEffect = v:FindFirstChild("Equalizer")

		local distance = (character.Head.Position - v.Parent.Position).Magnitude

		local strength = math.clamp(map.map(distance, 0, 3000, 0, -80),-80,0)

		thisEqualizer.HighGain = strength
		thisEqualizer.MidGain = strength
		thisEqualizer.LowGain = -strength
	end
end

game:GetService("RunService").Heartbeat:Connect(function()
	if true then
		for i,v in workspace.Characters:GetDescendants() do
			muffle(v)
		end
		for i,v in workspace.BGS.Explosions:GetDescendants() do
			muffle(v)
		end
		for i,v in workspace.Map.Vehicles:GetDescendants() do
			muffle(v)
		end
	end
end)

