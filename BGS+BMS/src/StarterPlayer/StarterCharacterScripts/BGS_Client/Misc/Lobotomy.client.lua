local player = game:GetService("Players").LocalPlayer
local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
client = script.Parent.Parent
local Folder = game:GetService("ReplicatedStorage").BGS_Engine.Assets.Lobotomy

client:GetAttributeChangedSignal("Lobotomized"):Connect(function()
	if client:GetAttribute("Lobotomized") then
		for _, v in workspace:GetDescendants() do
			if v:IsA("MeshPart") then
				local texture = Folder.Mesh.LOBOTOMY:Clone()
				texture.Parent = v
			elseif v:IsA("Part") then
				for i, inst in Folder.Part:GetChildren() do
					local texture = inst:Clone()
					texture.Parent = v
				end
			elseif v:IsA("Sound") and v.Name ~= "Lobotomy" then
				--v.SoundId = "rbxassetid://537141778"
			elseif v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=8645380410"
			end
			
			local sky = game:GetService("Lighting").Sky
			sky.SkyboxBk = "http://www.roblox.com/asset/?id=11943037709"
			sky.SkyboxDn = "http://www.roblox.com/asset/?id=11943037709"
			sky.SkyboxFt = "http://www.roblox.com/asset/?id=11943037709"
			sky.SkyboxLf = "http://www.roblox.com/asset/?id=11943037709"
			sky.SkyboxRt = "http://www.roblox.com/asset/?id=11943037709"
			sky.SkyboxUp = "http://www.roblox.com/asset/?id=11943037709"
			sky.MoonTextureId = "http://www.roblox.com/asset/?id=11943037709"
			sky.SunTextureId = "http://www.roblox.com/asset/?id=11943037709"
		end
		
		local Sounds = {
			[1] = "13061810;0.3",
			[2] = "13061809;0.2",
			[3] = "13061810;0.1",
			[4] = "13061802;0.1",
			[5] = "13061809;0.1",
			[6] = "12229501;0.1",
		}


		while wait(10) do
			local Chosen = string.split(Sounds[math.random(1,#Sounds)],";")

			game:GetService("SoundService").Music.SoundId = "rbxassetid://".. Chosen[1]
			game:GetService("SoundService").Music.PlaybackSpeed = Chosen[2]

			game:GetService("SoundService").Music:Play()
		end

	end
end)

local images = {
	"http://www.roblox.com/asset/?id=8645380410",
	"http://www.roblox.com/asset/?id=12814652370",
	"http://www.roblox.com/asset/?id=12003847844",
	"http://www.roblox.com/asset/?id=14905565607",
	"http://www.roblox.com/asset/?id=13829444767",
	"http://www.roblox.com/asset/?id=9883033031",
	"http://www.roblox.com/asset/?id=9183551031" -- fixed now @sprite
	
}

local hallucinations: {Instance} = {}

game:GetService("RunService").RenderStepped:Connect(function(delta)
	if client:GetAttribute("Lobotomized") then
		local roll = math.random(0, 600)
		if roll == 48 and player.PlayerGui.Lobotomy.ImageLabel.ImageTransparency == 1 then
			--print('executing')
			game:GetService("SoundService").Lobotomy:Play()
			player.PlayerGui.Lobotomy.ImageLabel.ImageTransparency = 0
			player.PlayerGui.Lobotomy.ImageLabel.BackgroundTransparency = 0
			player.PlayerGui.Lobotomy.ImageLabel.Image = images[math.random(1, #images)]
			game:GetService("TweenService"):Create(player.PlayerGui.Lobotomy.ImageLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
			game:GetService("TweenService"):Create(player.PlayerGui.Lobotomy.ImageLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
		elseif roll == 99 then
			local hallucination = Folder.Fake:Clone()
			hallucination.Parent = workspace
			hallucination:MoveTo(player.Character.Head.Position + Vector3.new(math.random(-20,20), math.random(20,50), math.random(-20,20)))
			
			table.insert(hallucinations, hallucination)
			
			
			hallucination.HumanoidRootPart.Touched:Connect(function(hit)
				if hit.Parent == player.Character then
					table.remove(hallucinations, table.find(hallucinations, hallucinations))
					hallucination:Destroy()
					game:GetService("SoundService").Lobotomy:Play()
					player.PlayerGui.Lobotomy.ImageLabel.ImageTransparency = 0
					player.PlayerGui.Lobotomy.ImageLabel.BackgroundTransparency = 0
					player.PlayerGui.Lobotomy.ImageLabel.Image = images[math.random(1, 6)]
					game:GetService("TweenService"):Create(player.PlayerGui.Lobotomy.ImageLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
					game:GetService("TweenService"):Create(player.PlayerGui.Lobotomy.ImageLabel, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
				end
			end)
			
		end
		
		for i,v in hallucinations do
			if v:FindFirstChildWhichIsA("Humanoid") then
				v.Humanoid:MoveTo(player.Character.Head.Position, player.Character.Head)
			else
				table.remove(hallucinations, i)
			end
		end
	end
end)