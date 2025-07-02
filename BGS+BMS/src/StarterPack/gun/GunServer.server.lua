local firingSound = script.Parent.Fire
local clickSound = script.Parent.Click

local reloadingSound = script.Parent.Handle.Reload
local boltSound = script.Parent.Handle.Bolt

local magSize = 30


script.Parent.Communications.OnServerEvent:Connect(function(player, action, currentMag)
	if action == "fire" then
		firingSound:Play()
	elseif action == "click" then
		print("clic")
		clickSound:Play()
	elseif action == "bolt" then
		boltSound:Play()
	elseif action == "reload" then
		reloadingSound:Play()
		
		if currentMag > magSize or currentMag < 0 then player:Kick("Biden blast") end
		
		script.Parent.AmmoStored.Value += currentMag
		script.Parent.AmmoStored.Value -= magSize
		if script.Parent.AmmoStored.Value < 0 then script.Parent.AmmoStored.Value = 0 end
		
	elseif action == "Equip" then
		local motor: Motor6D = script.Parent.Handle:FindFirstChild("BodyAttach")
		if motor then
			motor.Part0 = player.Character["Right Arm"]
			motor.Parent = player.Character["Right Arm"]
		end
		player.Character["Right Arm"].RightGrip.Enabled = false
		
	elseif action == "Unequip" then
		local motor: Motor6D = player.Character["Right Arm"]:FindFirstChild("BodyAttach")
		if motor then
			motor.Parent = script.Parent.Handle
		end
		
	else
		warn("Unknown action!")
	end
end)

script.Parent.Equipped:Connect(function()
	firingSound.Parent = script.Parent.Parent["Head"]
	clickSound.Parent = script.Parent.Parent["Head"]
end)
script.Parent.Unequipped:Connect(function()
	if firingSound.Playing then
		firingSound.Ended:Wait()
	end
	if clickSound.Playing then
		clickSound.Ended:Wait()
	end
	firingSound.Parent = script.Parent
	clickSound.Parent = script.Parent
end)