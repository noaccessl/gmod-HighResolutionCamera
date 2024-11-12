--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Directory for the screenshots
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
file.CreateDir( 'hrc' )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	hrc
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
hrc = {

	util = {};

	DoF = {

		Apply = false;

		Distance = 256;
		BlurSize = 0.5;
		Passes = 12;
		Steps = 24;
		Shape = 0.5

	}

}

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Store the local player in a global
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
_G.MySelf = _G.MySelf or NULL

hook.Add( 'InitPostEntity', 'HRC_InitLocalPlayer', function()

	hook.Remove( 'InitPostEntity', 'HRC_InitLocalPlayer' )

	local MySelf = LocalPlayer()
	_G.MySelf = MySelf

end )
