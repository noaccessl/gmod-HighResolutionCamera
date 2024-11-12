--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Setup the weapon
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
SWEP.Spawnable = true

SWEP.ViewModel = Model( 'models/weapons/c_arms_animations.mdl' )
SWEP.WorldModel = Model( 'models/hrc/camera.mdl' )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ''

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ''

SWEP.Sound = Sound( 'NPC_CScanner.TakePhoto' )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Initialize
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:Initialize()

	self:SetHoldType( 'camera' )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Reset FOV/Roll adjustment
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:Reload()

	local pOwner = self:GetOwner()

	if ( not pOwner:KeyDown( IN_ATTACK2 ) ) then
		pOwner:ConCommand( 'hrc_fov_reset' )
	end

	pOwner:ConCommand( 'hrc_roll_reset' )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Request a screenshot
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:PrimaryAttack()

	self:MakeCameraFlash()
	self:GetOwner():ConCommand( 'screenshot_high_res' )

	self:SetNextPrimaryFire( CurTime() + 0.25 )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Flash effect
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:MakeCameraFlash()

	local pOwner = self:GetOwner()

	self:EmitSound( self.Sound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	pOwner:SetAnimation( PLAYER_ATTACK1 )

	if ( SERVER and not game.SinglePlayer() ) then

		local vPos = pOwner:GetShootPos()
		local vForward = pOwner:GetAimVector()

		local trace = {

			start = vPos;
			endpos = vPos + vForward * 256;
			filter = pOwner

		}
		trace.output = trace

		util.TraceLine( trace )

		local effect = EffectData()
		effect:SetOrigin( tr.HitPos )
		util.Effect( 'camera_flash', effect, true )

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	SecondaryAttack
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:SecondaryAttack()

	return

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Translate FOV
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:TranslateFOV()

	return self:GetOwner():GetInfoNum( 'hrc_fov', 90 )

end
