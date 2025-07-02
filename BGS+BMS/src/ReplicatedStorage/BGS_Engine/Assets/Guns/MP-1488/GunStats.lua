local self = {}
self.ExplosiveBullet = false

self.MaxAmmo = 200
self.Ammo = 200

self.MagSize = 30
self.AmmoInMag = 30

self.Firemode = 1
self.Firemodes = {0, 1, 2} 

self.RPM = 600
-- 0 is safety, 1 is semi, 2 is auto, 3 is pump after firing

return self
