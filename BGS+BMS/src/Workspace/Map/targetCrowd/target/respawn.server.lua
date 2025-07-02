local connection: RBXScriptConnection = nil

function respawn()
	local replacement = game:GetService("ReplicatedStorage").BGS_Engine.Assets.BaseBallisticDummy:Clone()
	replacement.Parent = script.Parent
	replacement:PivotTo(script.Parent.spawnpos.CFrame)
	local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client:Clone()
	client.Parent = replacement
	reconnect()
end

function reconnect()
	if connection then
		connection:Disconnect()
	end
	connection = script.Parent.BaseBallisticDummy.Humanoid.Died:Connect(function()
		game:GetService("Debris"):AddItem(script.Parent.BaseBallisticDummy, 200)
		local corpse = script.Parent.BaseBallisticDummy
		corpse.Name = "Corpse"
		wait(5)
		corpse.BGS_Client.MedsysDelocalized.Enabled = false
		corpse.BGS_Client.MedsysDelocalized:Destroy()
		respawn()
	end)
end

respawn()