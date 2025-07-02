local ragdollModule = require(game:GetService("ReplicatedStorage").BGS_Engine.Modules.Ragdoll)
local character: Model = script.Parent.Parent
local humanoid: Humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid")


local ragdolled = false

function updateRagdoll()
	if ragdolled and (not script.Parent:GetAttribute("Unconscious")) and (not script.Tripped.Value) and (not script.Parent.CarryValues.CarriedBy.Value) and humanoid.Health > 0 then
		ragdollModule.Unragdoll(character)
		ragdolled = false
	elseif (not ragdolled) and ((script.Parent:GetAttribute("Unconscious")) or (script.Tripped.Value) or (script.Parent.CarryValues.CarriedBy.Value)) or humanoid.Health <= 0 then
		ragdollModule.Ragdoll(character)
		ragdolled = true
	end
end

humanoid.HealthChanged:Connect(updateRagdoll)

script.Parent.CarryValues.CarriedBy.Changed:Connect(updateRagdoll)
script.Parent.AttributeChanged:Connect(updateRagdoll)
script.Tripped.Changed:Connect(updateRagdoll)

script.GetUp.OnServerEvent:Connect(function(player)
	if script.TrippedTime.Value <= 0 then
		script.Tripped.Value = false
	end
end)



local reducing = false

function ReduceTrippedTime()
	if reducing then return end
	
	reducing = true
	
	while script.TrippedTime.Value > 0 do
		script.TrippedTime.Value -= 1
		task.wait(1)
	end
	script.TrippedTime.Value = 0
	reducing = false
end


script.TrippedTime.Changed:Connect(function()
	ReduceTrippedTime()
end)