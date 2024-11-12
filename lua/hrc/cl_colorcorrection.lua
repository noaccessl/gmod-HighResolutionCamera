--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Deal with color correction
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local Styles_t = {

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Cold Climatica
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	a = {

		addr = 0;
		addg = 0.117;
		addb = 0.196;
		brightness = -0.25;
		contrast = 1.40;
		colour = 0.85;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Contrasta
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	b = {

		addr = 0.235;
		addg = 0.117;
		addb = 0.156;
		brightness = -0.19;
		contrast = 1.15;
		colour = 0.95;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Greenity
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	c = {

		addr = 0;
		addg = 0.117;
		addb = 0;
		brightness = -0.12;
		contrast = 1.00;
		colour = 0.80;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Warm
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	d = {

		addr = 0.352;
		addg = 0.235;
		addb = 0.117;
		brightness = -0.15;
		contrast = 1.10;
		colour = 1.10;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Sadness
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	e = {

		addr = 0;
		addg = 0.039;
		addb = 0.196;
		brightness = -0.23;
		contrast = 1.50;
		colour = 0;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Darka
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	f = {

		addr = 0.275;
		addg = 0.352;
		addb = 0.313;
		brightness = -0.45;
		contrast = 1.35;
		colour = 0.50;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Blockbuster
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	g = {

		addr = 0.0392;
		addg = 0.0392;
		addb = 0.196;
		brightness = -0.15;
		contrast = 1.50;
		colour = 0.80;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Field Of Battle
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	h = {

		addr = 0;
		addg = 0.078;
		addb = 0.117;
		brightness = -0.12;
		contrast = 1.75;
		colour = 0.50;
		mulr = 0;
		mulg = 0.196;
		mulb = 0.784

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Summer
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	i = {

		addr = 0.125;
		addg = 0;
		addb = 0;
		brightness = -0.05;
		contrast = 1.10;
		colour = 1.25;
		mulr = 0.078;
		mulg = 0.039;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Calm
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	j = {

		addr = 0.136;
		addg = 0.039;
		addb = 0.039;
		brightness = -0.10;
		contrast = 1.35;
		colour = 0.85;
		mulr = 0;
		mulg = 0;
		mulb = 0

	};

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Rainmaker
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	k = {

		addr = 0.0313;
		addg = 0.0313;
		addb = 0.039;
		brightness = -0.05;
		contrast = 0.80;
		colour = 0.75;
		mulr = 0;
		mulg = 0;
		mulb = 0

	}

}

local function FormatParameter( parameter )

	return Format( '$pp_colour_%s', parameter )

end

hrc.CCStyles = {}

for id, settings_t in pairs( Styles_t ) do

	hrc.CCStyles[id] = {}

	for parameter, value in pairs( settings_t ) do

		parameter = FormatParameter( parameter )
		hrc.CCStyles[id][parameter] = value

	end

end

function hrc.GetColorCorrection()

	return hrc.CCStyles[ hrc.GetCCStyle() ]

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Setup separate material for color correction & Apply
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
hrc.ColorMod = CreateMaterial( 'hrc_colormod', 'g_colourmodify', {

	[ '$pp_colour_brightness' ] = 0;
	[ '$pp_colour_contrast' ] = 1;
	[ '$pp_colour_colour' ] = 1

} )

function hrc.SetupColorMod( pTexture, settings_t )

	hrc.ColorMod:SetTexture( '$fbtexture', pTexture )

	for parameter, value in pairs( settings_t ) do
		hrc.ColorMod:SetFloat( parameter, value )
	end

end

function hrc.ApplyColorMod()

	render.SetMaterial( hrc.ColorMod )
	render.DrawScreenQuad()

end
