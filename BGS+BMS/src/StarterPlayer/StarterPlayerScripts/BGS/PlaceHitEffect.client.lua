local impactModule = game:GetService("ReplicatedStorage").BGS_Engine.Modules.ImpactSound

local impactScript = require(impactModule)

impactModule.HitEffect.OnClientEvent:Connect(function(Position, part, isFlesh, normal)
	impactScript.PlaySound(Position, part, isFlesh, normal)
end)