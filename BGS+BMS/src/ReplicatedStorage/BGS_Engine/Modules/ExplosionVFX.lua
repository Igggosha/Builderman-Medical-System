
--	Radius: number,
--	Position: Vector3,
--	Sphere: Part,
--	Emitters: {ParticleEmitter},
--	Force: number,
--	Hit: BindableEvent


--function LimitlessExplosion.new(radius: number, position: Vector3 , force: number): LimitlessExplosion
--	local self = setmetatable({} :: self, LimitlessExplosion)
	
--	self.Radius = radius
--	self.Position = position
--	self.Force = force
	
--	self.Hit = Instance.new("BindableEvent")
	
	
	
--	return self
--end


--function LimitlessExplosion.Explode(self: LimitlessExplosion)
--	self.Sphere = Instance.new("Part")
--	self.Sphere.Transparency = 0.5
--	self.Sphere.CastShadow = false
--	self.Sphere.Anchored = true
	
--	self.Sphere.CanCollide = false
	
--	self.Sphere.Position = self.Position
	
--	for i,v in self.Emitters do
--		v:Emit(1)
--	end
	
--	local overlapParams = OverlapParams.new()
--	--overlapParams.
	
--	local affectedParts = workspace:GetPartBoundsInRadius(self.Position, self.Radius, overlapParams)
	
--	for i,v: BasePart in affectedParts do
--		local distanceVector = v.Position - self.Position
--		local force = 1 / distanceVector * self.Radius * self.Force
--		v:ApplyImpulse(force)
		
		
--		self.Hit:Fire(v, distanceVector, force)
--	end
	
--	task.wait(1)
	
--	self.Sphere:Destroy()
--end



--return module
