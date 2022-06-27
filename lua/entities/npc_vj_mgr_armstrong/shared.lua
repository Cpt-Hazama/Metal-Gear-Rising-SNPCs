ENT.Base 			= "npc_vj_mgr_boss_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

ENT.MGR_DrawBossHUD = true

if CLIENT then
    function ENT:Initialize()
        VJ_MGR_HPBar(self)
        VJ_MGR_AddBossTrack(self,"armstrong",24.5,160)

        -- self:ManipulateBoneJiggle(self:LookupBone("bone2560"),1)
        self:ManipulateBoneAngles(self:LookupBone("bone2560"),Angle(0,0,52))
        self:ManipulateBoneAngles(self:LookupBone("bone2562"),Angle(0,0,20))
        -- self:ManipulateBoneJiggle(self:LookupBone("bone2561"),1)
        -- self:ManipulateBoneJiggle(self:LookupBone("bone2562"),1)
        -- self:ManipulateBoneJiggle(self:LookupBone("bone2563"),1)
        -- self:ManipulateBoneJiggle(self:LookupBone("bone2564"),1)
    end
end