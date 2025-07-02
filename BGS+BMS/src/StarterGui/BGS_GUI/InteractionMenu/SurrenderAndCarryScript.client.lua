local player = game:GetService("Players").LocalPlayer

local targetCharacter: Model = nil

local surrenderButton = script.Parent.Surrender
local liberateButton = script.Parent.Free
local shmonButton = script.Parent.Search
local shmonMenu = script.Parent.Parent.ShmonMenu
local event = game:GetService("ReplicatedStorage").BGS_Engine.Events.Surrender

local anim

local thisCharacter = player.Character or player.CharacterAdded:Wait()
local thisClient = game.StarterPlayer.StarterCharacterScripts.BGS_Client
thisClient = thisCharacter:FindFirstChild("BGS_Client") or thisCharacter:WaitForChild("BGS_Client")


function targetFound()
	script.Parent.Free.Visible = true
	script.Parent.Search.Visible = true
	if not thisClient.CarryValues.Carrying.Value then
		script.Parent.Carry.Visible = true
	end
end

local itemDropConnections: {RBXScriptConnection} = {}


function noTargetFound()
	--targetCharacter = nil
	script.Parent.Free.Visible = false
	script.Parent.Search.Visible = false
	script.Parent.Parent.ShmonMenu.Visible = false
	--script.Parent.Carry.Visible = false
	
	for i,v in itemDropConnections do
		v:Disconnect()
		table.remove(itemDropConnections, i)
	end
	
	for i,v in shmonMenu.Items:GetChildren() do
		if v.Name ~= "UIListLayout" and v.Name ~= "ItemTemplate" then
			v:Destroy()
		end
	end
end

local surrenderAnimId = "rbxassetid://129753505392140"
local animobj = Instance.new("Animation")
animobj.AnimationId = surrenderAnimId
game:GetService("ContentProvider"):PreloadAsync({surrenderAnimId})


game:GetService("RunService").Heartbeat:Connect(function(delta)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {player.Character, workspace.CurrentCamera}
	local raycastResult = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.LookVector * 10, params)
	
	if raycastResult then
		local humanoid = raycastResult.Instance.Parent:FindFirstChildWhichIsA("Humanoid") 
		if not humanoid and raycastResult.Instance.Parent ~= workspace then
			humanoid = raycastResult.Instance.Parent.Parent.Parent:FindFirstChildWhichIsA("Humanoid")
		end
		
		if humanoid then
			targetCharacter = humanoid.Parent
			local client = game.StarterPlayer.StarterCharacterScripts.BGS_Client
			client = targetCharacter:FindFirstChild("BGS_Client")
			if client then
				
				if client:GetAttribute("Unconscious") or client:GetAttribute("Surrendered") and not thisClient.CarryValues.Carrying.Value then
					script.Parent.Carry.Visible = true
					--print("alo")
				else
					script.Parent.Carry.Visible = false
				end
				
				if client:GetAttribute("Surrendered") then
					targetFound()
					targetCharacter = humanoid.Parent
				else
					noTargetFound()
				end
			else
				script.Parent.Carry.Visible = false
				noTargetFound()
			end
		else
			script.Parent.Carry.Visible = false
			noTargetFound()
		end
	else
		script.Parent.Carry.Visible = false
		noTargetFound()
	end
	
	
	if thisClient.CarryValues.Carrying.Value then
		script.Parent.Throw.Visible = true
		script.Parent.Drop.Visible = true
	else
		script.Parent.Throw.Visible = false
		script.Parent.Drop.Visible = false
	end
	
end)


surrenderButton.MouseButton1Click:Connect(function()
	event:FireServer("Surrender")
	
	
	anim = player.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator"):LoadAnimation(animobj)
	anim.Priority = Enum.AnimationPriority.Action
	anim:Play()
end)

liberateButton.MouseButton1Click:Connect(function()
	event:FireServer("Liberate", targetCharacter)
end)

shmonButton.MouseButton1Click:Connect(function()
	
	
	shmonMenu = script.Parent.Parent.ShmonMenu
	shmonMenu.Visible = true
	script.Parent.Visible = false
	
	--shmonMenu.Items.ItemTemplate.Visible = true
	

	
	if targetCharacter:FindFirstChildWhichIsA("Tool") and targetCharacter:FindFirstChildWhichIsA("Tool"):FindFirstChild("DropCollider") then
		targetCharacter:FindFirstChildWhichIsA("Tool"):FindFirstChild("DropCollider").Drop:FireServer()
	end
	print(targetCharacter)
	local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(targetCharacter)

	if not targetPlayer then return end
	
	shmonMenu.PlayerName.Text = ""
	shmonMenu.PlayerName.Text = "SEARCHING "..targetPlayer.Name
	--print(shmonMenu.PlayerName.Text)
	
	local targetBackpack = targetPlayer.Backpack
	
	for i, v in targetBackpack:GetChildren() do
		if v:IsA("Tool") and v:FindFirstChild("DropCollider") then
			print("tool")
			wait(2.5)
			local panel = shmonMenu.Items.ItemTemplate:Clone()
			panel.Parent = shmonMenu.Items
			panel.Visible = true
			panel.ItemName.Text = ""
			panel.ItemName.Text = v.Name
			panel.Name = v.Name
			
			print(panel)
			
			local connection = panel.Drop.MouseButton1Click:Connect(function()
				v.DropCollider.Drop:FireServer()
				panel:Destroy()
			end)
			
			table.insert(itemDropConnections, connection)
		end
	end
	
	shmonMenu.Items.ItemTemplate.Visible = false
end)

event.OnClientEvent:Connect(function(action)
	if action == "Liberated" then
		if anim then anim:Stop() end
	end
end)

----------------------------

script.Parent.Carry.MouseButton1Down:Connect(function()
	thisClient.CarryHandler.CarryEvent:FireServer("CarryOther", targetCharacter)
end)

script.Parent.Drop.MouseButton1Down:Connect(function()
	thisClient.CarryHandler.CarryEvent:FireServer("DropOther")
end)

script.Parent.Throw.MouseButton1Down:Connect(function()
	thisClient.CarryHandler.CarryEvent:FireServer("ThrowOther")
end)