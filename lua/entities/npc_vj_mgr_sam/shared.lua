ENT.Base 			= "npc_vj_mgr_boss_base"
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
        VJ_MGR_AddBossTrack(self,"sam",false,false)
    end
end