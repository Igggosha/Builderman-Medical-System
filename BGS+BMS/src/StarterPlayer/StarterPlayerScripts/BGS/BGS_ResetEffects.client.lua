game:GetService("Players").LocalPlayer.CharacterAppearanceLoaded:Connect(function()
	game:GetService("UserInputService").MouseIconEnabled = true
	workspace.CurrentCamera.FieldOfView = 70
	game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 20
end)