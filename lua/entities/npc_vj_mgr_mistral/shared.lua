ENT.Base 			= "npc_vj_mgr_boss_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if CLIENT then
    local jiggleAnims = {
        "attack9",
        "attack10",
        "attack14",
        "attack_range2",
        "attack_range2_hit"
    }
    -- local jiggleBones = {3,4,5,6,7,8,9,10,11,12,13,14,15}
    local jiggleBones = {5,7,9,11,13}

    function ENT:CustomOnDraw()
        local wep = self:GetNW2Entity("Weapon")
        if !IsValid(wep) then return end
        local anim = self:GetSequenceName(self:GetSequence())
        if VJ_HasValue(jiggleAnims,anim) then
            for _,bone in pairs(jiggleBones) do
                wep:ManipulateBoneJiggle(bone,1)
            end
        else
            for _,bone in pairs(jiggleBones) do
                wep:ManipulateBoneJiggle(bone,0)
            end
        end
    end

    function ENT:Initialize()
        VJ_MGR_HPBar(self)
        VJ_MGR_AddBossTrack(self,"mistral",20.65,128.15)
    end

    function ENT:OnPhaseChanged(phase,track1,track2,ply)
        track2:SetTime(40)
    end
end