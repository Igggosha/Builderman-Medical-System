-- Gradually regenerates the Humanoid's Health over time.

local REGEN_RATE = 1
local REGEN_STEP = 5 -- Wait this long between each regeneration step.

--------------------------------------------------------------------------------

local Character = script.Parent
local Humanoid = Character:WaitForChild'Humanoid'

--------------------------------------------------------------------------------

while true do
	while Humanoid.Health < Humanoid.MaxHealth do
		local dt = wait(REGEN_STEP)
		if Humanoid.Health <= 0 then break end
		Humanoid.Health = math.min(Humanoid.Health + REGEN_RATE, Humanoid.MaxHealth)
	end
	if Humanoid.Health <= 0 then break end
	Humanoid.HealthChanged:Wait()
end