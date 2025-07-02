local player = game:GetService("Players").LocalPlayer
local showArms = false
local hideTool = false


player.Character.ChildAdded:Connect(function(child)
	if child:IsA("Tool") then
		if child:FindFirstChild("HideTool") and child.HideTool.Value then
			hideTool = true
			showArms = false
		elseif child:FindFirstChild("ShowArms") and child.ShowArms.Value then
			showArms = true
			hideTool = false
		end
	end
end)

player.Character.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") then
		showArms = false
		hideTool = false
	end
end)

game:GetService("RunService").PreRender:Connect(function(delta)
	
	
	if hideTool then
		for _,instance in player.Character:FindFirstChildWhichIsA("Tool"):GetDescendants() do
			if instance:IsA("BasePart") then
				instance.LocalTransparencyModifier = 1
			end
		end
		if workspace.CurrentCamera:FindFirstChildWhichIsA("Tool") then
			for _,instance in workspace.CurrentCamera:FindFirstChildWhichIsA("Tool"):GetDescendants() do
				if instance:IsA("BasePart") then
					instance.LocalTransparencyModifier = 0
				end
			end
		end
	elseif showArms then
		player.Character["Left Arm"].LocalTransparencyModifier = 0
		player.Character["Right Arm"].LocalTransparencyModifier = 0
	end
	
	for _, inst in player.Character:GetChildren() do
		if inst:GetAttribute("KeepVisible") then
			inst.LocalTransparencyModifier = 0
		end
	end
	
	
	for _, i in workspace.BGS.DroppedTools:GetChildren() do
		if i:IsA("Tool") then
			for _, v in i:GetDescendants() do
				if v:IsA("BasePart") then
					v.LocalTransparencyModifier = 0
				end
			end
		end
	end
end)