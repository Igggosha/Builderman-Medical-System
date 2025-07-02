local player = game:GetService("Players").LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
client = character:FindFirstChild("BGS_Client") or character:WaitForChild("BGS_Client")

game:GetService("RunService").Heartbeat:Connect(function()
	script.Parent.BrokenLimbs.Visible = client:GetAttribute("LeftArmBroken") or client:GetAttribute("RightArmBroken") or client:GetAttribute("RightLegBroken") or client:GetAttribute("LeftLegBroken")
	
	script.Parent.Pain.Visible = client.Vitals.Pain.Value > 100
	
	local hasWounds = false
	for i,v in character:GetDescendants() do
		if v:IsA("MeshPart") and v.Name == "Wound" then
			hasWounds = true
			break
		end
	end
	
	script.Parent.Bleeding.Visible = hasWounds
	script.Parent.BloodIcon.Visible = hasWounds
end)

while true do
	game:GetService("TweenService"):Create(script.Parent.BloodIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { ImageColor3 = Color3.new(1,1,1)}):Play()
	wait(1)
	game:GetService("TweenService"):Create(script.Parent.BloodIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { ImageColor3 = Color3.new(1,0,0)}):Play()
	wait(1)
end