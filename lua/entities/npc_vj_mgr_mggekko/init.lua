AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/gekko.mdl"}
ENT.StartHealth = 1000
ENT.HullType = HULL_LARGE

ENT.VJ_NPC_Class = {"CLASS_MG_PMC"}

ENT.MaxJumpLegalDistance = VJ_Set(1500, 2500)

ENT.BloodColor = "White"

-- ENT.CanFlinch = 1
-- ENT.AnimTbl_Flinch = {"flinch1","flinch2","flinch3","flinch4","flinch5"}

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true

ENT.AttackProps = false

ENT.AnimTbl_Movements = {
	[1] = {Start = "0010",Loop = {ACT_WALK}, End = "0012", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
	[2] = {Start = "1100",Loop = {ACT_WALK_STIMULATED}, End = "1106", ReqIdle = {ACT_IDLE_ANGRY}, GoalMax = 1.2, GoalMin = 0.2},
	[3] = {Start = "1200",Loop = {ACT_RUN}, End = "1206", ReqIdle = {ACT_IDLE_ANGRY,ACT_WALK,ACT_WALK_STIMULATED}, GoalMax = 0.21, GoalMin = 0},
	[4] = {Start = "2200",Loop = {ACT_RUN_STIMULATED}, End = "2202", ReqIdle = {ACT_IDLE_ANGRY,ACT_WALK,ACT_WALK_STIMULATED}, GoalMax = 0.21, GoalMin = 0},
}

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateHeight(z)
	self.CollisionBounds.z = z or 190
	self:SetCollisionBounds(self.CollisionBounds,Vector(-self.CollisionBounds.x,-self.CollisionBounds.y,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.CollisionBounds = Vector(27,27,190)
	self:SetCollisionBounds(self.CollisionBounds,Vector(-self.CollisionBounds.x,-self.CollisionBounds.y,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecInc = Vector(0,0,8)
--
function ENT:CustomOnThink_AIEnabled()
	local ent = self:GetEnemy()
	local dist = self.NearestPointToEnemyDistance

	self:UpdateHeight(self:GetPos():Distance(self:GetBonePosition(self:LookupBone("bone008")) +vecInc))
	self:VJ_MGR_UniqueMovement()
end