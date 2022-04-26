ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if CLIENT then
    function ENT:Initialize()
        VJ_MGR_HPBar(self)
        VJ_MGR_AddBossTrack(self,"mg_ray",20.65,128.15)
    end

    function ENT:ControllerViewOverride(ply, origin, angles, fov)
        local pos, ang = origin, angles
		local camera = ply.VJCE_Camera -- Camera entity
        if ply.VJC_Camera_Mode == 2 then -- First person
            local setPos = self:EyePos() + self:GetForward()*20
            local offset = ply.VJC_FP_Offset
            //camera:SetLocalPos(camera:GetLocalPos() + ply.VJC_TP_Offset) -- Help keep the camera stable
            if ply.VJC_FP_Bone != -1 then -- If the bone does exist, then use the bone position
                local bonePos, boneAng = self:GetBonePosition(ply.VJC_FP_Bone)
                setPos = bonePos
                if ply.VJC_FP_CameraBoneAng > 0 then
                    ang[3] = boneAng[ply.VJC_FP_CameraBoneAng] + ply.VJC_FP_CameraBoneAng_Offset
                end
                if ply.VJC_FP_ShrinkBone then
                    self:ManipulateBoneScale(ply.VJC_FP_Bone, vec0) -- Bone manipulate to make it easier to see
                end
            end
            pos = setPos + (self:GetForward()*offset.x + self:GetRight()*offset.y + self:GetUp()*offset.z)
        else
            if ply.VJC_FP_Bone != -1 then -- Reset the self's bone manipulation!
                ply.VJCE_self:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
            end
            local offset = ply.VJC_TP_Offset + Vector(0, 0, self:OBBMaxs().z - self:OBBMins().z) // + vectp
            local startPos = self:GetPos() +self:GetUp() *(self:OBBMaxs().z *1.1)
            local tr = util.TraceHull({
                start = startPos,
                endpos = startPos + angles:Forward()*-camera.Zoom + (self:GetForward()*offset.x + self:GetRight()*offset.y + self:GetUp()*offset.z),
                filter = {ply, camera, self, ply.VJ_BoneFollowerEntity},
                mins = Vector(-5, -5, -5),
                maxs = Vector(5, 5, 5),
                mask = MASK_SHOT,
            })
            pos = tr.HitPos + tr.HitNormal*2
        end

        return pos, ang, fov
    end
end