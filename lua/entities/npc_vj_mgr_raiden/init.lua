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

ENT.AnimTbl_Movements = {
	[1] = {Start = "0010",Loop = {ACT_WALK}, End = "0012", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
	[3] = {Start = "0020",Loop = {ACT_RUN}, End = "0022", ReqIdle = {ACT_IDLE,ACT_WALK}, GoalMax = 0.21, GoalMin = 0},
	[3] = {Start = "6000",Loop = {ACT_SPRINT}, End = "6014", ReqIdle = {ACT_IDLE,ACT_WALK,ACT_RUN}, GoalMax = 0.15, GoalMin = 0},
}

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {}

ENT.AnimationSet = 0 -- 0 = Relaxed, 1 = Combat
ENT.MovementSet = 0 -- 0 = Default, 1 = Slow, 2 = Fast, 3 = NPC
ENT.AttackMode = 0 -- 0 = Default, 1 = Blade Mode, 2 = H2H
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetPhase(2)

	self.LastBladeModeAngle = 0

	self.AnimTbl_Walk = {ACT_RUN}
	self.AnimTbl_Run = {ACT_RUN}

	-- hook.Add("StartCommand",self,function(self, ply,cmd)
	-- 	if ply == self.VJ_TheController then
	-- 		local angle = math.atan2(cmd:GetMouseY(),cmd:GetMouseX())
	-- 		self.LastBladeModeAdjust = angle
	-- 	end
	-- end)
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
	local key_atk2 = IsValid(cont) && cont:KeyDown(IN_ATTACK2)

	if self.AttackMode == 1 then
		self:SetCycle(self.LastBladeModeAngle /360)
	end

	if IsValid(cont) then
		if key_atk2 then
			if self.AttackMode != 1 then
				self.AttackMode = 1
				self:StopMoving()
				self:ClearSchedule()
				self:SetMaxYawSpeed(8)
				self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
				self.NextIdleStandT = 0
				self.AnimTbl_IdleStand = {ACT_HL2MP_IDLE}
				self.AnimationPlaybackRate = 4
				if game.SinglePlayer() then
					game.SetTimeScale(0.1)
				end
			else
				if key_atk then
					// Attack
					self:SetMaxYawSpeed(20)
					for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.MeleeAttackDistance)) do
						if !self:DoRelationshipCheck(v) && v != self then
							v:TakeDamage(5,self,self)
						end
					end
				else
					self:SetMaxYawSpeed(8)
				end
				local targetValue = false
				if key_for then
					targetValue = self.LastBladeModeAngle > 180 && 360 or 0
				end
				if key_lef then
					targetValue = 270
				end
				if key_rig then
					targetValue = 90
				end
				if key_bac then
					targetValue = 180
				end
				-- targetValue = self.LastBladeModeAdjust *15 or false
				self.LastBladeModeAngle = Lerp(FrameTime() *(12 *self.AnimationPlaybackRate),self.LastBladeModeAngle,targetValue != false && targetValue or self.LastBladeModeAngle)
			end
		else
			if self.AttackMode == 1 then
				self.AttackMode = 0
				self:SetMaxYawSpeed(self.TurningSpeed)
				self:SetState()
				self.NextIdleStandT = 0
				self.AnimTbl_IdleStand = {ACT_IDLE}
				self.AnimationPlaybackRate = 1
				if game.SinglePlayer() then
					game.SetTimeScale(1)
				end
			end
		end
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

	self:VJ_MGR_UniqueMovement()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	-- if self:Health() <= self:GetMaxHealth() *0.35 && self:SetBodygroup(0) == 0 then
	-- 	self:SetBodygroup(0,1)
	-- end
end