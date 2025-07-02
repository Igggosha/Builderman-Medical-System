local player = game:GetService("Players").LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
client = character:FindFirstChild("BGS_Client")
client:WaitForChild("RagdollHandler")

client.RagdollHandler.Tripped.Changed:Connect(function(value)
	script.Parent.Visible = value	
end)

script.Parent.TextButton.MouseButton1Down:Connect(function()
	client.RagdollHandler.GetUp:FireServer()
end)