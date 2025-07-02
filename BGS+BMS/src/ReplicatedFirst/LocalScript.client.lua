local loadingscreen = script.Parent.Loading

loadingscreen.Parent = game:GetService("Players").LocalPlayer.PlayerGui

local cp = game:GetService("ContentProvider")

cp:PreloadAsync({
	"rbxassetid://123181906777160",
	"rbxassetid://133172300131200",
	"rbxassetid://94959694275729"
})
print("done")

loadingscreen:Destroy()