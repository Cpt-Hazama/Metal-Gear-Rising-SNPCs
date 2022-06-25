AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/monsoon.mdl"}
ENT.StartHealth = 9000
ENT.HullType = HULL_HUMAN

ENT.VJ_NPC_Class = {"CLASS_MG_DESPERADO"}

ENT.BloodColor = "Red"

-- ENT.CanFlinch = 1
-- ENT.AnimTbl_Flinch = {"flinch1","flinch2","flinch3","flinch4","flinch5"}

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true

ENT.AttackProps = false

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.AnimTbl_Movements = {
	[1] = {Start = "0010",Loop = {ACT_WALK}, End = "0012", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
	[2] = {Start = "0020",Loop = {ACT_RUN}, End = "0022", ReqIdle = {ACT_IDLE,ACT_WALK}, GoalMax = 0.21, GoalMin = 0},
}

ENT.SoundTbl_FootStep = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetPhase(1)

	-- ParticleEffectAttach("vj_mgr_monsoon_smoke",PATTACH_POINT_FOLLOW,self,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomThink(ent,dist,cont,key_atk,key_for,key_bac,key_lef,key_rig,key_jum,isMoving)
	self:VJ_MGR_UniqueMovement()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self:Health() <= self:GetMaxHealth() *0.35 && self:SetBodygroup(0) == 0 then
		self:SetBodygroup(0,1)
	end

	-- local dmg = dmginfo:GetDamage()
	-- local dmgtype = dmginfo:GetDamageType()
	-- local isBSDamage = (dmgtype == DMG_BULLET or dmgtype == DMG_DIRECT)

	-- if dmg >= 95 && !isBSDamage && self:GetState() == VJ_STATE_NONE && math.random(1,4) == 1 then
	-- 	self:Stun()
	-- end
end