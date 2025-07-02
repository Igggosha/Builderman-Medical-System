function updateBackpack()
	script.Unconscious.Value = script.Parent.BGS_Client:GetAttribute("Unconscious") or script.Parent.BGS_Client:GetAttribute("ClinicalDeath")
	
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, not ( script.Reloading.Value or script.Surrendered.Value or script.Unconscious.Value or script.Carrying.Value or script.VehicleSeat.Value or script.Parent.BGS_Client.RagdollHandler.Tripped.Value))	

end

script.Parent.BGS_Client.AttributeChanged:Connect(updateBackpack)

for i,v in script:GetChildren() do
	if v:IsA("BoolValue") then
		v.Changed:Connect(updateBackpack)
	end
end

script.Parent.BGS_Client.RagdollHandler.Tripped.Changed:Connect(updateBackpack)