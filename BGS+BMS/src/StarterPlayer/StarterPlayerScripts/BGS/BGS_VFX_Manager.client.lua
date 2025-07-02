local player = game:GetService("Players").LocalPlayer
local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
client = nil
local heartrate = 70
local Camera = workspace.CurrentCamera
local pain = 0
local TS = game:GetService("TweenService")

local assets = game:GetService("ReplicatedStorage").BGS_Engine.Assets

local blur = assets.Blur:Clone()
blur.Parent = Camera
local colorCorrection = assets.ColorCorrection:Clone()
colorCorrection.Parent = Camera
local unconsciousCC = Instance.new("ColorCorrectionEffect")
unconsciousCC.Parent = Camera

local gui = player.PlayerGui:WaitForChild("CoreGUI")
gui:WaitForChild("HealthVignette")

player.CharacterAdded:Connect(function(character)
	client = character:WaitForChild("BGS_Client")
	gui = player:WaitForChild("PlayerGui"):WaitForChild("CoreGUI")
end)

game:GetService("RunService").RenderStepped:Connect(function(delta)
	if client then
		colorCorrection.Saturation = -1 + client.Vitals.Blood.Value / 5000
		colorCorrection.Contrast = math.clamp((client.AppliedMedication.AmountOfCaffeine.Value + client.AppliedMedication.AmountOfEpinephrine.Value) / 500 - client.AppliedMedication.AmountOfMorphine.Value / 500, -0.6, 1)
		
		if client:GetAttribute("ClinicalDeath") then
			unconsciousCC.Brightness = -0.6
			game:GetService("SoundService").UnconsciousMuffling.EqualizerSoundEffect.Enabled = true
		elseif client:GetAttribute("Unconscious") then
			unconsciousCC.Brightness = -0.4
			game:GetService("SoundService").UnconsciousMuffling.EqualizerSoundEffect.Enabled = true
		else
			unconsciousCC.Brightness = 0
			game:GetService("SoundService").UnconsciousMuffling.EqualizerSoundEffect.Enabled = false
		end
	end
end)

local stage = 1



while true do
	if not client then
		client = player.Character:FindFirstChild("BGS_Client")
	end
	
	gui = player:WaitForChild("PlayerGui"):WaitForChild("CoreGUI")
	
	if stage == 1 then 
		stage = 2
		TS:Create(Camera.Blur, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = client.Vitals.Pain.Value / 12}):Play()
		TS:Create(gui:WaitForChild("HealthVignette"), TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = player.Character:FindFirstChildWhichIsA("Humanoid").Health / 100}):Play()
	else
		stage = 1
		TS:Create(Camera.Blur, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = 0}):Play()
		TS:Create(gui:WaitForChild("HealthVignette"), TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
	end
	
	wait(1.5)
end