local inputservice = game:GetService("UserInputService")

local equipped = false

script.Parent.Parent.Equipped:Connect(function()
	equipped = true
end)

script.Parent.Parent.Unequipped:Connect(function()
	equipped = false
end)

inputservice.InputBegan:Connect(function(input, gpe)
	if gpe or not equipped then return end
	
	if input.KeyCode == Enum.KeyCode.Backspace then
		script.Parent.Drop:FireServer()
		script.Parent.DropClientsideHook:Fire()
	end
end)