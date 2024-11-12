--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Draw the world model
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local VECTOR_OFFSET = Vector( 3.954, -5.252, 0.213 )
local ANGLE_OFFSET = Angle( 0, -4.4, 187.3 )

function SWEP:DrawWorldModel()

	local pOwner = self:GetOwner()

	if ( not IsValid( pOwner ) ) then
		return
	end

	local pCSWM = self.m_hCSWM

	if ( not IsValid( pCSWM ) ) then

		pCSWM = ClientsideModel( self.WorldModel )
		pCSWM:SetNoDraw( true )
		pCSWM:SetModelScale( 0.85 )

		self.m_hCSWM = pCSWM

	end

	local pBoneMatrix = pOwner:GetBoneMatrix( pOwner:LookupBone( 'ValveBiped.Bip01_R_Hand' ) )

	if ( not pBoneMatrix ) then
		return
	end

	pBoneMatrix:Translate( VECTOR_OFFSET )
	pBoneMatrix:Rotate( ANGLE_OFFSET )

	pCSWM:SetPos( pBoneMatrix:GetTranslation() )
	pCSWM:SetAngles( pBoneMatrix:GetAngles() )

	pCSWM:SetupBones()
	pCSWM:DrawModel()

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Clear the clientside world model
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function SWEP:Holster()

	SafeRemoveEntity( self.m_hCSWM )
	return true

end
SWEP.OnRemove = SWEP.Holster
