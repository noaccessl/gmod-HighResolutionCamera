--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Copy GMod's post-processing
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local PostProcess_t = {

	[1] = Material( 'pp/bloom' );
	[2] = Material( 'pp/colour' );
	[3] = Material( 'pp/downsample' );
	[4] = Material( 'pp/texturize' );
	[5] = Material( 'pp/toytown-top' )

}

local __pTextureScreenshot
local pFuncGetScreenshotTexture = function()

	return __pTextureScreenshot

end

local pFuncDummy = function() end

local Internal_SetRenderTarget
local pFuncSetRenderTarget = function( pTexture )

	if ( not pTexture ) then
		render.SetViewPort( 0, 0, __pTextureScreenshot:Width(), __pTextureScreenshot:Height())
		Internal_SetRenderTarget( __pTextureScreenshot )
	end

	Internal_SetRenderTarget( pTexture )

end

function hrc.RenderScreenspaceEffects( pTextureScreenshot )

	local Internal_GetScreenEffectTexture = render.GetScreenEffectTexture
	local Internal_CopyRenderTargetToTexture = render.CopyRenderTargetToTexture
	Internal_SetRenderTarget = render.SetRenderTarget

	--
	-- Override
	--
	__pTextureScreenshot = pTextureScreenshot

	render.GetScreenEffectTexture = pFuncGetScreenshotTexture
	render.CopyRenderTargetToTexture = pFuncDummy

	for _, pMat in ipairs( PostProcess_t ) do
		pMat:SetTexture( '$fbtexture', pTextureScreenshot )
	end

	render.SetRenderTarget = pFuncSetRenderTarget

	--
	-- Render
	--
	hook.Run( 'RenderScreenspaceEffects' )

	--
	-- Restore
	--
	local pTextureScreenEffect = Internal_GetScreenEffectTexture()

	for _, pMat in ipairs( PostProcess_t ) do
		pMat:SetTexture( '$fbtexture', pTextureScreenEffect )
	end

	render.GetScreenEffectTexture = Internal_GetScreenEffectTexture
	render.CopyRenderTargetToTexture = Internal_CopyRenderTargetToTexture

	render.SetRenderTarget = Internal_SetRenderTarget

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Perform post-processing
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local MAT_VIGNETTE	= Material( 'overlays/hrc_vignette' )
local MAT_FILMGRAIN = Material( 'overlays/hrc_grain' )
local MAT_LETTERBOX = Material( 'overlays/hrc_letterbox' )

function hrc.DoPostProcess( pTexture )

	if ( hrc.ShouldApplyCC() ) then

		local settings_t = hrc.GetColorCorrection()

		if ( settings_t ) then

			hrc.SetupColorMod( pTexture, settings_t )
			hrc.ApplyColorMod()

		end

	end

	if ( hrc.ShouldApplyVignette() ) then

		render.SetMaterial( MAT_VIGNETTE )
		render.DrawScreenQuad()

	end

	if ( hrc.ShouldApplyFilmGrain() ) then

		render.SetMaterial( MAT_FILMGRAIN )
		render.DrawScreenQuad()

	end

	if ( hrc.ShouldApplyLetterbox() ) then

		render.SetMaterial( MAT_LETTERBOX )
		render.DrawScreenQuad()

	end

end
