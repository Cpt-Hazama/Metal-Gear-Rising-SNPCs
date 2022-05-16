ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"HP")
	self:NetworkVar("Int",1,"Electrolytes")
	self:NetworkVar("Int",2,"MaxElectrolytes")
	self:NetworkVar("Int",3,"StartPoint")
	self:NetworkVar("Int",4,"EndPoint")
end