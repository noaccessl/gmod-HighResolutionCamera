--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Request a screenshot
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local g_ScreenshotRequested = false

function hrc.TakeScreenshot()

	g_ScreenshotRequested = true

end
concommand.Add( 'screenshot_high_res', hrc.TakeScreenshot )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Take a screenshot
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local RenderCaptureData_t = {

	alpha = false;

	x = 0;
	y = 0

}

local function ScreenMessage( pMatScreenshot, text )

	local OldRT = render.GetRenderTarget()

	render.SetRenderTarget( nil )

		local sw, sh = ScrW(), ScrH()

		render.Clear( 0, 0, 0, 0, true, true )

		pMatScreenshot:SetFloat( '$alpha', 1 )
		render.SetMaterial( pMatScreenshot )
		render.DrawScreenQuadEx( 0, 0, sw, sh )

		cam.Start2D()

			draw.DrawText( text, 'DermaLarge', sw - 100, sh - 100, color_black, TEXT_ALIGN_RIGHT )
			draw.DrawText( text, 'DermaLarge', sw - 101, sh - 101, color_white, TEXT_ALIGN_RIGHT )

		cam.End2D()

		render.Spin()

	render.SetRenderTarget( OldRT )

end

hook.Add( 'RenderScene', 'HRC_TakeScreenshot', function( vecViewOrigin, angViewOrigin )

	if ( not g_ScreenshotRequested ) then
		return
	end

	g_ScreenshotRequested = false

	--
	-- Prepare
	--
	local w = hrc.GetWidth()
	local h = hrc.GetHeight()

	local format = hrc.GetFormat()
	local name = hrc.util.FormatScreenshotName( format )

	hrc.util.GenerateCaptureData( w, h, format, RenderCaptureData_t )

	local g_DoF = hrc.DoF

	-- Record the spent time
	local Start = SysTime()

	-- Prepare the RT
	local pTextureScreenshot, pMatScreenshot, pTextureDoF, pMatDoF = hrc.util.GenerateRT( w, h, g_DoF.Apply or hrc.ShouldPerformAA() )

	--
	-- Make the screenshot
	--
	render.PushRenderTarget( pTextureScreenshot )

		hrc.MakingScreenshot = true

		--
		-- Make models look nice
		--
		hrc.util.SetGlobalLOD( 0 )

		--
		-- Clear
		--
		render.Clear( 0, 0, 0, 0, true, true )

		--
		-- Render the scene
		--
		ScreenMessage( pMatScreenshot, 'Rendering the scene...' )

		if ( not hrc.util.IsHoldingCamera() ) then
			angViewOrigin = angViewOrigin + hrc.GetRollAdjust()
		end

		local ViewData_t = {

			origin = vecViewOrigin;
			angles = angViewOrigin;
			fov = hrc.util.ScaleFOVByWidthRatio( hrc.GetFOV(), ( w / h ) / ( 4 / 3 ) );

			x = 0;
			y = 0;

			w = w;
			h = h;

			dopostprocess = hrc.ShouldApplyHDR()

		}
		render.RenderView( ViewData_t )

		--
		-- Anti-aliasing
		--
		if ( not g_DoF.Apply and hrc.ShouldPerformAA() ) then
			hrc.PerformAA( pMatScreenshot, pTextureDoF, pMatDoF, ViewData_t )
		end

		--
		-- SuperDoF
		--
		if ( g_DoF.Apply ) then

			local FocusPoint = ViewData_t.origin + ViewData_t.angles:Forward() * g_DoF.Distance

			hrc.RenderDoF(

				pMatScreenshot, pTextureDoF, pMatDoF,

				ViewData_t.origin,
				ViewData_t.angles,
				FocusPoint,

				g_DoF.BlurSize,
				g_DoF.Steps,
				g_DoF.Passes,

				ViewData_t,
				g_DoF.Shape

			)

		end

		ScreenMessage( pMatScreenshot, 'Post-processing...' )

		--
		-- Copy GMod's post-processing
		--
		hrc.RenderScreenspaceEffects( pTextureScreenshot )

		--
		-- Perform post-process
		--
		hrc.DoPostProcess( pTextureScreenshot )

		--
		-- Capture
		--
		ScreenMessage( pMatScreenshot, 'Capturing the screenshot...' )
		local image = render.Capture( RenderCaptureData_t )

		--
		-- Free the VRAM
		--
		render.Clear( 0, 0, 0, 0, true, true )

		--
		-- Restore models LODs
		--
		hrc.util.SetGlobalLOD( -1 )

	render.PopRenderTarget()
	pTextureScreenshot = nil

	g_DoF.Apply = false
	hrc.MakingScreenshot = nil

	--
	-- Save
	--
	file.Write( name, image )

	--
	-- Notification
	--
	ScreenMessage( pMatScreenshot, 'Saved.' )

	local strMessage = Format( 'Saved screenshot as %s in %.2f seconds!', name, SysTime() - Start )

	print( strMessage )
	notification.AddLegacy( strMessage, NOTIFY_GENERIC, 6 )

	return true

end )
