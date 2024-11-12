
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'cl_wm.lua' )

AddCSLuaFile( 'sh_init.lua' )

include( 'sh_init.lua' )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Setup the weapon
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	ShouldDropOnDie
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:ShouldDropOnDie()

	return false

end
