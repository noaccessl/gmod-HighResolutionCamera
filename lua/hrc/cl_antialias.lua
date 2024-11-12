--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Anti-aliasing based on SuperDoF
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function hrc.PerformAA( pMatScreenshot, pTextureDoF, pMatDoF, ViewData_t )

	hrc.RenderDoF(

		pMatScreenshot, pTextureDoF, pMatDoF,

		ViewData_t.origin,
		ViewData_t.angles,
		ViewData_t.origin,

		hrc.GetAAStrength(),
		24,
		12,

		ViewData_t,
		0.5

	)

end
