local connection: RBXScriptConnection = nil

function reconnect()
	if connection then
		connection:Disconnect()
	end
	connection = script.Parent.ArmorBallisticDummy.Humanoid.Died:Connect(function()
		game:GetService("Debris"):AddItem(script.Parent.ArmorBallisticDummy, 300)
		script.Parent.ArmorBallisticDummy.Name = "Corpse"
		wait(5)
		local replacement = game:GetService("ReplicatedStorage").BGS_Engine.Assets.ArmorBallisticDummy:Clone()
		replacement.Parent = script.Parent
		replacement:PivotTo(script.Parent.spawnpos.CFrame)
		local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client:Clone()
		client.Parent = replacement
		reconnect()
	end)
end

local replacement = game:GetService("ReplicatedStorage").BGS_Engine.Assets.ArmorBallisticDummy:Clone()
replacement.Parent = script.Parent
replacement:PivotTo(script.Parent.spawnpos.CFrame)
local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client:Clone()
client.Parent = replacement
reconnect()