--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Prepare resolutions
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local Resolutions_t = {}

do

	local function FormatResolution( name, w, h, aspect )

		return Format( '%s %dx%d (%s)', name, w, h, aspect )

	end

	local RawData_t = {

		{ 'Full HD';	1920; 1080;  '16:9'  };
		{ '2K DCI';		2048; 1080;  '19:10' };
		{ '2K QHD';		2560; 1440;  '16:9'  };
		{ '4K UHD';		3840; 2160;  '16:9'  };
		{ '4K DCI';		4096; 2160;  '19:10' };
		{ '5K UHD +';	5120; 2880;  '16:9'  };
		{ '8K UHD';		7680; 4320;  '16:9'  };
		{ '10K';		10240; 5760; '16:9'  };
		{ '12K';		11520; 6480; '16:9'  };
		{ '16K';		15360; 8640; '16:9'  }

	}

	for num, data in ipairs( RawData_t ) do

		local name	 = data[1]
		local w		 = data[2]
		local h		 = data[3]
		local aspect = data[4]

		Resolutions_t[num] = {

			Name = FormatResolution( name, w, h, aspect );

			ConVars = {

				hrc_screenshot_width  = w;
				hrc_screenshot_height = h

			}

		}

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Macro for adding new header
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function AddHeader( ControlPanel, strHeader, marginTop )

	--
	-- Header
	--
	local Header = vgui.Create( 'DLabel' )
	Header:SetFont( 'DermaLarge' )
	Header:SetTextColor( Color( 35, 36, 40 ) )
	Header:SetText( strHeader )
	Header:SizeToContents()
	Header:Dock( TOP )
	Header:DockMargin( 0, marginTop, 0, 0 )

	--
	-- Spacer
	--
	local Spacer = vgui.Create( 'EditablePanel' )
	Spacer:Dock( TOP )
	Spacer:DockMargin( 0, -5, 0, 0 )
	Spacer:SetTall( 2 )

	function Spacer.Paint( this )

		surface.SetDrawColor( 68, 68, 68 )
		this:DrawFilledRect()

	end

	--
	-- Add to the control panel
	--
	ControlPanel:AddPanel( Header )
	ControlPanel:AddPanel( Spacer )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Macro for adding new label
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
surface.CreateFont( 'HRC_DermaMedium', {

	font = 'Roboto';
	size = 17;
	weight = 400;
	antialias = true;
	extended = true

} )

local function AddLabel( ControlPanel, text, marginTop )

	--
	-- Label
	--
	local Label = vgui.Create( 'DLabel' )
	Label:SetFont( 'HRC_DermaMedium' )
	Label:SetTextColor( Color( 85, 85, 85 ) )
	Label:SetText( text )
	Label:SizeToContents()
	Label:Dock( TOP )
	Label:DockMargin( 0, marginTop, 0, 0 )

	--
	-- Add to the control panel
	--
	ControlPanel:AddPanel( Label )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Macro for adding new combo box with custom sorting
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function AddSortedComboBox( ControlPanel, strLabel, Options )

	local ctrl = vgui.Create( 'CtrlListBox', ControlPanel )

	ctrl:SetSortItems( false )

	for _, data in ipairs( Options ) do
		ctrl:AddOption( data.Name, data.ConVars )
	end

	local left = vgui.Create( 'DLabel', ControlPanel )
	left:SetText( strLabel )
	left:SetDark( true )
	ctrl:SetHeight( 25 )
	ctrl:Dock( TOP )

	ControlPanel:AddItem( left, ctrl )

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Setup settings
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function SetupSettings( pnl )

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Post-processing
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	do

		AddHeader( pnl, 'Post-processing', 0 )

		pnl:AddControl( 'CheckBox', { Label = 'Apply HDR effects to the screenshot'; Command = 'hrc_applyhdr' } )
		pnl:ControlHelp( 'Requires HDR enabled in settings.' )

		pnl:AddControl( 'CheckBox', { Label = 'Letterbox'; Command = 'hrc_letterbox' } )
		pnl:AddControl( 'CheckBox', { Label = 'Film grain'; Command = 'hrc_filmgrain' } )
		pnl:AddControl( 'CheckBox', { Label = 'Vignette'; Command = 'hrc_vignette' } )

		pnl:AddControl( 'CheckBox', { Label = 'Color Filter'; Command = 'hrc_cc' } )

		AddSortedComboBox( pnl, 'Filter Style', {

			{ Name = 'Cold Climatica'; 	ConVars = { hrc_cc_style = 'a' } };
			{ Name = 'Contrasta';      	ConVars = { hrc_cc_style = 'b' } };
			{ Name = 'Greenity';       	ConVars = { hrc_cc_style = 'c' } };
			{ Name = 'Warm';           	ConVars = { hrc_cc_style = 'd' } };
			{ Name = 'Sadness';        	ConVars = { hrc_cc_style = 'e' } };
			{ Name = 'Darka';          	ConVars = { hrc_cc_style = 'f' } };
			{ Name = 'Blockbuster';    	ConVars = { hrc_cc_style = 'g' } };
			{ Name = 'Field Of Battle';	ConVars = { hrc_cc_style = 'h' } };
			{ Name = 'Summer';         	ConVars = { hrc_cc_style = 'i' } };
			{ Name = 'Calm';           	ConVars = { hrc_cc_style = 'j' } };
			{ Name = 'Rainmaker';      	ConVars = { hrc_cc_style = 'k' } }

		} )

	end

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		View
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	do

		AddHeader( pnl, 'View', 20 )

		pnl:AddControl( 'Slider', {

			Label = 'Camera FOV';
			Command = 'hrc_fov';
			Type = 'Float';
			Min = 0.1;
			Max = 110

		} )

		pnl:AddControl( 'CheckBox', { Label = 'Enable FOV Manual Control'; Command = 'hrc_fov_manual' } )
		pnl:ControlHelp( 'Just like vanilla camera does' )

		pnl:AddControl( 'Button', {

			Label = 'Reset Camera FOV';
			Command = 'hrc_fov_reset'

		} )

		pnl:AddControl( 'Slider', {

			Label = 'Camera Roll';
			Command = 'hrc_roll';
			Type = 'Float';
			Min = -180;
			Max = 180

		} )

		pnl:AddControl( 'CheckBox', { Label = 'Enable Roll Manual Control'; Command = 'hrc_roll_manual' } )
		pnl:ControlHelp( 'Just like vanilla camera does' )

		pnl:AddControl( 'Button', {

			Label = 'Reset Camera Roll';
			Command = 'hrc_roll_reset'

		} )

		pnl:AddControl( 'CheckBox', { Label = 'Draw spawned cameras (via Tool Gun)'; Command = 'cl_drawcameras' } )
		pnl:ControlHelp( 'Just switches cl_drawcameras' )

	end

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Screenshot
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	do

		AddHeader( pnl, 'Screenshot', 20 )

		AddSortedComboBox( pnl, 'Resolution', Resolutions_t )

		pnl:AddControl( 'Slider', {

			Label = 'Custom Screenshot Width';
			Command = 'hrc_screenshot_width';
			Min = -1;
			Max = render.MaxTextureWidth()

		} )

		pnl:ControlHelp( 'It is limited to the width your GPU can maximally handle.\n-1 means use the native screen\'s width.' )

		pnl:AddControl( 'Slider', {

			Label = 'Custom Screenshot Height';
			Command = 'hrc_screenshot_height';
			Min = -1;
			Max = render.MaxTextureHeight()

		} )

		pnl:ControlHelp( 'It is limited to the height your GPU can maximally handle.\n-1 means use the native screen\'s height.' )

		AddSortedComboBox( pnl, 'Image Data Format', {

			{ Name = '8/8/8 bits/color component. Full color depth.';		ConVars = { hrc_rt_imgfmt = 'RGB888' } };
			{ Name = '5/6/5 bits/color component. Limited color depth.';	ConVars = { hrc_rt_imgfmt = 'BGR565' } };
			{ Name = '5/5/5 bits/color component. Limited color depth.';	ConVars = { hrc_rt_imgfmt = 'BGRA5551' } };
			{ Name = '4/4/4 bits/color component. Half color depth.';		ConVars = { hrc_rt_imgfmt = 'BGRA4444' } };

		} )

		pnl:ControlHelp( 'Used for render targets that are allocated for screenshots.\nCan be used for reducing screenshot file size.' )

		pnl:AddControl( 'ComboBox', {

			Label = 'Format';
			Options = {

				png = { hrc_screenshot_format = 'png' };
				jpg = { hrc_screenshot_format = 'jpg' };
				jpeg = { hrc_screenshot_format = 'jpeg' };

			}

		} )

		pnl:AddControl( 'Slider', {

			Label = 'Quality';
			Command = 'hrc_screenshot_quality'

		} )
		pnl:ControlHelp( 'Affects jpeg only' )

	end

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Anti-aliasing
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	do

		AddHeader( pnl, 'Anti-aliasing', 20 )
		AddLabel( pnl, 'Internally performs SuperDoF.\n\nNote: SuperDoF won\'t be rendered twice in a screenshot.', 0 )

		pnl:AddControl( 'CheckBox', { Label = 'Enable'; Command = 'hrc_screenshot_aa' } )

		pnl:AddControl( 'Slider', {

			Label = 'Strength (Blur size)';
			Command = 'hrc_screenshot_aa_blur';
			Type = 'Float';
			Min = 0.01;
			Max = 0.5

		} ):SetDecimals( 3 )

	end

	--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Make screenshot
	–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
	do

		local Button = pnl:AddControl( 'Button', {

			Label = 'Make screenshot';
			Command = 'screenshot_high_res'

		} )

		Button:Dock( TOP )
		Button:DockMargin( 0, 20, 0, 0 )

	end

end

hook.Add( 'PopulateToolMenu', 'HRC_Settings', function()

	spawnmenu.AddToolMenuOption(

		'Options',
		'Player',
		'hrc',
		'High Resolution Camera',
		'',
		'',
		SetupSettings

	)

end )
