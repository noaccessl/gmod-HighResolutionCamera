--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Resolve compatibility issues 
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
do -- with Advanced Light Entities

	hook.Add( 'PreRegisterSENT', 'HRC_Compatibility_AdvancedLightEntities', function( ENT, strClass )

		if ( strClass == 'base_light' and isfunction( ENT.Camera ) ) then

			ENT.Camera = function( this )

				local w = LocalPlayer():GetActiveWeapon()
				return IsValid( w ) and ( w:GetClass() == 'gmod_camera' or w:GetClass() == 'camera_highres' )

			end

		end

	end )

end
