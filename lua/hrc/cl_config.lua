--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Macro for creating ConVars
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.ConVar( name, default, min, max, strAccessor, strType )

	--
	-- Argument overload
	--
	if ( isstring( min ) and isstring( max ) ) then

		strAccessor, strType = min, max
		min, max = nil, nil

	end

	-- ConVar
	local pConVar = CreateClientConVar( 'hrc_' .. name, default, true, false, '', min, max )

	--
	-- Accessor
	--
	if ( strAccessor ) then

		local pFuncMethod = pConVar[ 'Get' .. strType ]

		hrc[strAccessor] = function()

			return pFuncMethod( pConVar )

		end

	end

	return pConVar

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Config
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
hrc.Config = {

	--
	-- Post-processing settings
	--
	ApplyHDR	= hrc.ConVar( 'applyhdr',	'1', 'ShouldApplyHDR', 'Bool' );

	Letterbox	= hrc.ConVar( 'letterbox',	'0', 'ShouldApplyLetterbox', 'Bool' );
	FilmGrain	= hrc.ConVar( 'filmgrain',	'0', 'ShouldApplyFilmGrain', 'Bool' );
	Vignette	= hrc.ConVar( 'vignette',	'0', 'ShouldApplyVignette', 'Bool' );

	CC			= hrc.ConVar( 'cc',			'0', 'ShouldApplyCC', 'Bool' );
	CCStyle		= hrc.ConVar( 'cc_style',	'a', 'GetCCStyle', 'String' );

	--
	-- Camera settings
	--
	FOV			= hrc.ConVar( 'fov',			'90', 0.1, 140, 'GetFOV', 'Float' );
	ManualFOV	= hrc.ConVar( 'fov_manual',		'1', 'IsManualFOV', 'Bool' );

	Roll		= hrc.ConVar( 'roll',			'0', -180, 180, 'GetRoll', 'Float' );
	ManualRoll	= hrc.ConVar( 'roll_manual',	'1', 'IsManualRoll', 'Bool' );

	--
	-- Screenshot settings
	--
	Width	= hrc.ConVar( 'screenshot_width',   '-1', -1, render.MaxTextureWidth() );
	Height	= hrc.ConVar( 'screenshot_height',  '-1', -1, render.MaxTextureHeight() );
	Format	= hrc.ConVar( 'screenshot_format',  'png', 'GetFormat', 'String' );
	Quality = hrc.ConVar( 'screenshot_quality', '100', 0, 100, 'GetQuality', 'Int' );

	ImgFmt	= hrc.ConVar( 'rt_imgfmt',			'RGB888', 'GetRTImageFormat', 'String' );

	--
	-- Anti-aliasing settings
	--
	AA		= hrc.ConVar( 'screenshot_aa', 		'0', 'ShouldPerformAA', 'Bool' );
	AABlur	= hrc.ConVar( 'screenshot_aa_blur',	'0.125', 0.01, 0.5, 'GetAAStrength', 'Float' )

}

concommand.Add( 'hrc_fov_reset', function()

	hrc.Config.FOV:Revert()

end )

concommand.Add( 'hrc_roll_reset', function()

	hrc.Config.Roll:Revert()

end )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Accessors for camera settings
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
do

	function hrc.GetRollAdjust()

		return Angle( 0, 0, hrc.GetRoll() )

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Accessors for screenshot settings
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
do

	function hrc.GetWidth()

		local w = hrc.Config.Width:GetInt()

		if ( w == -1 ) then
			return ScrW()
		end

		return w

	end

	function hrc.GetHeight()

		local h = hrc.Config.Height:GetInt()

		if ( h == -1 ) then
			return ScrH()
		end

		return h

	end

end
