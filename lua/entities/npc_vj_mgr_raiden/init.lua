AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/raiden.mdl"}
ENT.StartHealth = 1000
ENT.HullType = HULL_HUMAN

ENT.VJC_Data = {
	CameraMode = 1,
	ThirdP_Offset = Vector(40, 12, -40),
	FirstP_Bone = "bone005",
	FirstP_Offset = Vector(7, 0, 2),
	FirstP_ShrinkBone = true,
	FirstP_CameraBoneAng = 0,
	FirstP_CameraBoneAng_Offset = 0,
}

ENT.VJ_NPC_Class = {"CLASS_MG_MAVERICK","CLASS_PLAYER_ALLY"}
ENT.PlayerFriendly = true
ENT.FriendsWithAllPlayerAllies = true

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

ENT.SoundTbl_FootStep = {}

ENT.AnimationSet = 0 -- 0 = Relaxed, 1 = Combat
ENT.MovementSet = 0 -- 0 = Default, 1 = Slow, 2 = Fast, 3 = NPC
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetPhase(2)

	self.AnimTbl_Walk = {ACT_RUN}
	self.AnimTbl_Run = {ACT_RUN}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomThink(ent,dist,cont,key_atk,key_for,key_bac,key_lef,key_rig,key_jum,isMoving)
	local key_walk = IsValid(cont) && cont:KeyDown(IN_WALK)
	local key_sprint = IsValid(cont) && cont:KeyDown(IN_SPEED)

	if IsValid(cont) then
		if key_sprint then
			if self.MovementSet != 2 then
				self.AnimTbl_Walk = {ACT_SPRINT}
				self.AnimTbl_Run = {ACT_SPRINT}
				self.MovementSet = 2
			end
		elseif key_walk then
			if self.MovementSet != 1 then
				self.AnimTbl_Walk = {ACT_WALK}
				self.AnimTbl_Run = {ACT_WALK}
				self.MovementSet = 1
			end
		else
			if self.MovementSet != 0 then
				self.AnimTbl_Walk = {ACT_RUN}
				self.AnimTbl_Run = {ACT_RUN}
				self.MovementSet = 0
			end
		end
	else
		if self.MovementSet != 3 then
			self.AnimTbl_Walk = {ACT_RUN}
			self.AnimTbl_Run = {ACT_SPRINT}
			self.MovementSet = 3
		end
	end

	if !self:IsBusy() && self.LastActivity == ACT_WALK && (!IsValid(cont) && self.GoalTime <= 1.2 && self.GoalTime > 0.2 or IsValid(cont) && !isMoving) && self.LastSequence != "pl0010_0012" then
		self:VJ_ACT_PLAYACTIVITY("pl0010_0012",true,false,false)
	elseif self.LastActivity == ACT_IDLE && self:GetActivity() == ACT_WALK then
		self:VJ_ACT_PLAYACTIVITY("vjges_pl0010_0010",true,false,false)
		self:ResetIdealActivity(VJ_SequenceToActivity(self,"pl0010_0010"))
	elseif !self:IsBusy() && self.LastActivity == ACT_RUN && (!IsValid(cont) && self.GoalTime <= 0.21 && self.GoalTime > 0 or IsValid(cont) && !isMoving) && self.LastSequence != "pl0010_0022" then
		self:VJ_ACT_PLAYACTIVITY("pl0010_0022",true,false,false)
	elseif self.LastActivity == ACT_IDLE && self:GetActivity() == ACT_RUN then
		self:VJ_ACT_PLAYACTIVITY("vjges_pl0010_0020",true,false,false)
		self:ResetIdealActivity(VJ_SequenceToActivity(self,"pl0010_0020"))
	elseif !self:IsBusy() && self.LastActivity == ACT_SPRINT && (!IsValid(cont) && self.GoalTime <= 0.21 && self.GoalTime > 0 or IsValid(cont) && !isMoving) && self.LastSequence != "pl0010_0022" then
		self:VJ_ACT_PLAYACTIVITY("pl0010_0022",true,false,false)
	elseif self.LastActivity == ACT_IDLE && self:GetActivity() == ACT_SPRINT then
		self:VJ_ACT_PLAYACTIVITY("vjges_pl0010_0020",true,false,false)
		self:ResetIdealActivity(VJ_SequenceToActivity(self,"pl0010_0020"))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	-- if self:Health() <= self:GetMaxHealth() *0.35 && self:SetBodygroup(0) == 0 then
	-- 	self:SetBodygroup(0,1)
	-- end
end