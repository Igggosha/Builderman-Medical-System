

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	workspace.CurrentCamera.FieldOfView = 70
	game:GetService("SoundService").UnconsciousMuffling.EqualizerSoundEffect.Enabled = false
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	game:GetService("UserInputService").MouseIconEnabled = true
	game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
end)