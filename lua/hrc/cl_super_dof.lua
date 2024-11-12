--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Prepare
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
--
-- Metamethods: Vector, Angle, Material
--
local VectorDistance = FindMetaTable( 'Vector' ).Distance


local ANGLE = FindMetaTable( 'Angle' )

local AngleCopy				= ANGLE.Set
local RotateAngleAroundAxis	= ANGLE.RotateAroundAxis

local GetAngleForward	= ANGLE.Forward
local GetAngleRight		= ANGLE.Right
local GetAngleUp		= ANGLE.Up


local SetMatFloat = FindMetaTable( 'IMaterial' ).SetFloat

--
-- Globals
--
local MathClamp = math.Clamp

local GetRenderTarget	= render.GetRenderTarget
local SetRenderTarget	= render.SetRenderTarget
local Clear				= render.Clear
local SetMaterial		= render.SetMaterial
local DrawScreenQuad	= render.DrawScreenQuad
local DrawScreenQuadEx	= render.DrawScreenQuadEx
local RenderView		= render.RenderView
local Spin				= render.Spin

local MATH_TAU		= math.tau
local MATH_TAU_INV	= 1 / MATH_TAU

local sin = math.sin
local cos = math.cos

local UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local GetScreenEffectTexture	= render.GetScreenEffectTexture
local DoHRCPostProcess			= hrc.DoPostProcess

local CamStart2D	= cam.Start2D
local CamEnd2D		= cam.End2D
local Format		= string.format
local DrawText		= draw.DrawText


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Render DoF in the screenshot
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local VA = Angle()
local VRot = Angle()

function hrc.RenderDoF( pMatScreenshot, pTextureDoF, pMatDoF, vOrigin, vAngle, vFocus, flAngleSize, radial_steps, passes, view, Shape )

	local pTextureScreenshot = GetRenderTarget()
	local fDistance = VectorDistance( vOrigin, vFocus )

	flAngleSize = flAngleSize * MathClamp( 256 / fDistance, 0.1, 1 ) * 0.5

	SetRenderTarget( nil )
		local sw, sh = ScrW(), ScrH()

	SetRenderTarget( pTextureDoF )

		Clear( 0, 0, 0, 0, true, true )

		--
		-- Copy the screenshot here to as a canvas
		--
		SetMatFloat( pMatScreenshot, '$alpha', 1 )
		SetMaterial( pMatScreenshot )
		DrawScreenQuad()

		local Radials = MATH_TAU / radial_steps

		for mul = 1 / passes, 1, 1 / passes do

			for i = 0, MATH_TAU, Radials do

				AngleCopy( VA, vAngle )
				AngleCopy( VRot, vAngle )

				-- Rotate around the focus point
				RotateAngleAroundAxis( VA, GetAngleRight( VRot ), sin( i + mul ) * flAngleSize * mul * Shape * 2 )
				RotateAngleAroundAxis( VA, GetAngleUp( VRot ), cos( i + mul ) * flAngleSize * mul * ( 1 - Shape ) * 2 )

				view.origin = vFocus - GetAngleForward( VA ) * fDistance
				view.angles = VA

				-- Render the default scene with modified angles
				SetRenderTarget( pTextureScreenshot )

					Clear( 0, 0, 0, 0, true, true )
					RenderView( view ) -- Render the screenshot again

				-- Copy it to the floating point buffer at a reduced alpha
				SetRenderTarget( pTextureDoF )

					local alpha = ( Radials * MATH_TAU_INV ) -- Divide alpha by the number of radials
					alpha = alpha * ( 1 - mul ) -- Reduce alpha the further away from center we are
					SetMatFloat( pMatScreenshot, '$alpha', alpha )

					SetMaterial( pMatScreenshot )
					DrawScreenQuad()

				--
				-- We have to spin here to stop the Source engine running out of render queue space.
				--
				-- Restore RT to the screen
				SetRenderTarget( nil )
				Clear( 0, 0, 0, 0, true, true )

				-- Render the result buffer to the screen
				SetMaterial( pMatDoF )
				DrawScreenQuadEx( 0, 0, sw, sh )

				-- Post-processing preview
				UpdateScreenEffectTexture()
				DoHRCPostProcess( GetScreenEffectTexture() )

				--
				-- Show the progress
				--
				CamStart2D()

					local add = ( i * MATH_TAU_INV ) * ( 1 / passes )
					local percent = ( mul - ( 1 / passes ) + add ) * 100

					local text = Format( 'Rendering SuperDoF: %.1f%%', percent )

					DrawText( text, 'DermaLarge', sw - 100, sh - 100, color_black, TEXT_ALIGN_RIGHT )
					DrawText( text, 'DermaLarge', sw - 101, sh - 101, color_white, TEXT_ALIGN_RIGHT )

				CamEnd2D()

				-- Update the screen forcefully
				Spin()

			end

		end

	-- Go back to the screenshot
	SetRenderTarget( pTextureScreenshot )
	Clear( 0, 0, 0, 0, true, true )

	-- Render the result buffer to the screenshot
	SetMaterial( pMatDoF )
	DrawScreenQuad()

	SetRenderTarget( pTexDoF )
		Clear( 0, 0, 0, 0, true, true )
	SetRenderTarget( pTextureScreenshot )

end
