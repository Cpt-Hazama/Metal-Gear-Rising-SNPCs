ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

ENT.MGR_DrawBossHUD = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"HP")
	self:NetworkVar("Int",1,"StartPoint")
	self:NetworkVar("Int",2,"EndPoint")
	self:NetworkVar("Bool",0,"Blade")
end

if CLIENT then
    local vec0 = Vector(0,0,0)
    local vec1 = Vector(1,1,1)
    local target = vec0
    function ENT:CustomOnDraw()
        local blade = self:GetBlade()
        target = LerpVector(FrameTime() *10,target,blade && vec1 or vec0)
        for i = 49,70 do
            self:ManipulateBoneScale(i,target)
        end
    end

    function ENT:Initialize()
        VJ_MGR_HPBar(self)
        VJ_MGR_AddBossTrack(self,"mg_ray",15,134.8)
    end

    local tabVal = table.HasValue
    function ENT:FilterCallback(ent,ply,camera)
        local ignoreEnts = {ply, camera, self, ply.VJ_BoneFollowerEntity}
        if ent:GetClass() == "phys_bone_follower" or tabVal(ignoreEnts,ent) then
            return false
        end
        return true
    end

    function ENT:Controller_CalcView(ply, pos, ang, fov, origin, angles, cameraMode)
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
                endpos = startPos + angles:Forward()*-(camera.Zoom *4) + (self:GetForward()*offset.x + self:GetRight()*offset.y + self:GetUp()*(offset.z *0.5)),
                filter = function(ent)
                    self:FilterCallback(ent,ply,camera)
                end,
                mins = Vector(-5, -5, -5),
                maxs = Vector(5, 5, 5),
                mask = MASK_SHOT,
            })
            pos = tr.HitPos + tr.HitNormal*2
        end

        return {origin = pos, angles = ang, fov = fov}
    end
end