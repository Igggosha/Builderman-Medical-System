game:GetService("ReplicatedStorage").BGS_Engine.Events.PlaySound.OnClientEvent:Connect(function(sound:Sound, copy: boolean)
	if not copy then
		sound:Play()
	else
		local soundClone = sound:Clone()
		task.spawn(function()
			soundClone.Parent = sound.Parent
			if not soundClone.IsLoaded then soundClone.Loaded:Wait() end
			soundClone:Play()
			soundClone.Ended:Wait()
			soundClone:Destroy()
		end)
	end

end)