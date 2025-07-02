local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local gui = player:WaitForChild("PlayerGui"):WaitForChild("BGS_GUI"):WaitForChild("GiveUpFrame")


local timeLeft = 15

game:GetService("RunService").Heartbeat:Connect(function(delta)
	
	gui.Visible = script.Parent:GetAttribute("Unconscious") or script.Parent:GetAttribute("ClinicalDeath")
	
	if gui.Visible then
		
		timeLeft -= delta
		if timeLeft <= 0 then
			timeLeft = 0
		end
	else
		timeLeft = 15
	end
	gui.Cooldown.Text = math.ceil(timeLeft)
	
	
end)

character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
	timeLeft = 15
	gui.TextButton.Text = "You are dead. Wait to respawn."
end)

gui.TextButton.MouseButton1Down:Connect(function()
	if timeLeft <= 0 then
		gui.Visible = false
		game:GetService("ReplicatedStorage").BGS_Engine.Events.Die:FireServer()
	end
end)