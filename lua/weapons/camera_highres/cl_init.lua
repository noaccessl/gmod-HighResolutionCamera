
include( 'sh_init.lua' )
include( 'cl_wm.lua' )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Setup the weapon
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
SWEP.PrintName = 'High Resolution Camera'

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawWeaponInfoBox = false
SWEP.WepSelectIcon = surface.GetTextureID( 'vgui/gmod_camera' )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Post-processing preview
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
hook.Add( 'RenderScreenspaceEffects', 'HRC_Preview', function()

	if ( not hrc.MakingScreenshot and hrc.util.IsHoldingCamera() ) then

		render.UpdateScreenEffectTexture()
		hrc.DoPostProcess( render.GetScreenEffectTexture() )

	end

end )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Hide something
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:HUDShouldDraw( element )

	if ( element ~= 'CHudWeaponSelection' and element ~= 'CHudChat' ) then
		return false
	end

	return true

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Adjust the view
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:CalcView( pl, origin, angles )

	return origin, angles + hrc.GetRollAdjust()

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Manipulate FOV & Roll
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
hook.Add( 'CreateMove', 'HRC_ManipulateView', function( cmd )

	local pWeapon = MySelf:GetActiveWeapon()

	if ( not MySelf:Alive() or not ( IsValid( pWeapon ) and pWeapon:GetClass() == 'camera_highres' ) ) then
		return
	end

	if ( not cmd:KeyDown( IN_ATTACK2 ) ) then
		return
	end

	local IsManualFOV = hrc.IsManualFOV()
	local IsManualRoll = hrc.IsManualRoll()

	local FOV = hrc.Config.FOV
	local Roll = hrc.Config.Roll

	local FT = FrameTime()

	if ( IsManualFOV ) then
		FOV:SetFloat( FOV:GetFloat() + cmd:GetMouseY() * FT * 6.6 )
	end

	if ( IsManualRoll ) then
		Roll:SetFloat( Roll:GetFloat() + cmd:GetMouseX() * FT * 1.65 )
	end

end )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Don't move when the owner adjusts fov/roll
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:FreezeMovement()

	local pOwner = self:GetOwner()

	if ( pOwner:KeyDown( IN_ATTACK2 ) or pOwner:KeyReleased( IN_ATTACK2 ) ) then
		return true
	end

	return false

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Adjust the mouse sensivitiy
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:AdjustMouseSensitivity()

	if ( self:GetOwner():KeyDown( IN_ATTACK2 ) ) then
		return 1
	end

	return hrc.GetFOV() / 80

end
