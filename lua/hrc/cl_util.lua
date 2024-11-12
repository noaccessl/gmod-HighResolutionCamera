--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	IsHoldingCamera
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.util.IsHoldingCamera()

	local pWeapon = MySelf:GetActiveWeapon()
	return IsValid( pWeapon ) and pWeapon:GetClass() == 'camera_highres'

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	ScaleFOVByWidthRatio
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
do

	local DEG2RAD_HALVED	= 0.5 * math.pi / 180.0
	local RAD2DEG			= 180 / math.pi

	local tan	= math.tan
	local atan	= math.atan

	function hrc.util.ScaleFOVByWidthRatio( flFOV, flAspectRatio )

		local flFOVRadians_Halved = DEG2RAD_HALVED * flFOV

		local t = tan( flFOVRadians_Halved )
		t = t * flAspectRatio

		flFOV = RAD2DEG * atan( t )

		return flFOV * 2

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Determine the LOD of all entities
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.util.SetGlobalLOD( iLOD )

	for _, pEntity in ents.Iterator() do
		pEntity:SetLOD( iLOD )
	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Generate a render capture data
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.util.GenerateCaptureData( w, h, format, out )

	out.w = w
	out.h = h

	out.format = format
	out.quality = hrc.GetQuality()

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	FormatScreenshotName
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.util.FormatScreenshotName( strFileFormat )

	return Format(

		'hrc/%s_%s.%s',

		game.GetMap(),
		os.date( '%Y-%m-%d_%H.%M.%S' ),
		strFileFormat

	)

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Generate an unique RT for a screenshot
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
do

	local ImageFormats = {

		RGB888 = 2; -- 8/8/8 bits/color component. Full color depth.
		BGR565 = 17; -- 5/6/5 bits/color component. Limited color depth.
		BGRA5551 = 21; -- 5/5/5 bits/color component. Limited color depth.
		BGRA4444 = 19 -- 4/4/4 bits/color component. Half color depth.

	}

	function hrc.util.GenerateRT( w, h, bPerformDoF )

		local numImageFormat = ImageFormats[ string.upper( hrc.GetRTImageFormat() ) ]
		local name = Format( '_rt_HRC_%dx%dx%d', w, h, numImageFormat )

		local pTextureScreenshot = GetRenderTargetEx(

			name,
			w,
			h,
			RT_SIZE_LITERAL,
			MATERIAL_RT_DEPTH_SEPARATE,
			16 + 256 + 512 + 4096,
			0,
			numImageFormat

		)

		local pMatScreenshot = CreateMaterial( name, 'UnlitGeneric', { [ '$basetexture' ] = name } )

		if ( bPerformDoF ) then

			local super = Format( '_rt_HRC_%dx%d_SuperTexture', w, h )

			local pTextureDoF = GetRenderTargetEx(

				super,
				w,
				h,
				RT_SIZE_LITERAL,
				MATERIAL_RT_DEPTH_NONE,
				16 + 256 + 512,
				0,
				IMAGE_FORMAT_RGBA16161616F

			)

			local pMatDoF = CreateMaterial( super, 'UnlitGeneric', { [ '$basetexture' ] = super } )

			return pTextureScreenshot, pMatScreenshot, pTextureDoF, pMatDoF

		end

		return pTextureScreenshot, pMatScreenshot

	end

end
