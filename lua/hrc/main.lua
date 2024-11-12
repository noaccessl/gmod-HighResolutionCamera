--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Include specific client file
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function IncludeClient( file )

	if ( SERVER ) then
		AddCSLuaFile( file )
	else
		include( file )
	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Load the addon
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
IncludeClient( 'cl_main.lua' )
IncludeClient( 'cl_config.lua' )

IncludeClient( 'cl_util.lua' )

IncludeClient( 'cl_colorcorrection.lua' )
IncludeClient( 'cl_postprocess.lua' )

IncludeClient( 'cl_super_dof.lua' )
IncludeClient( 'cl_antialias.lua' )

IncludeClient( 'cl_screenshot.lua' )

IncludeClient( 'cl_settingsmenu.lua' )

IncludeClient( 'cl_compatibility.lua' )

if ( SERVER ) then
	AddCSLuaFile( 'pp_override_super_dof.lua' )
else

	hook.Add( 'PostGamemodeLoaded', 'HRC_OverrideSuperDoF', function()

		hook.Remove( 'PostGamemodeLoaded', 'HRC_OverrideSuperDoF' )
		include( 'hrc/pp_override_super_dof.lua' )

	end )

end
