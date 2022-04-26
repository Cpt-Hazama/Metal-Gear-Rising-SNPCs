AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/mg_ray.mdl"}
ENT.StartHealth = 8000
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true

ENT.VJ_NPC_Class = {"CLASS_MG_DESPERADO"}

ENT.Bleeds = false

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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(50,50,700),Vector(-50,-50,0))
	-- self:SetCollisionBounds(Vector(1,1,700),Vector(-1,-1,0))
	VJ_CreateBoneFollower(self)

	self:SetPhase(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetPhase(i)
	self.Phase = i
	self:SetNW2Int("Phase",i)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DealDamage(dmg,ent,tr)
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(dmg or 1)
	dmginfo:SetDamagePosition(tr)
	dmginfo:SetDamageType(DMG_SLASH)
	dmginfo:SetAttacker(self)
	dmginfo:SetInflictor(self)
	ent:TakeDamageInfo(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.LastSequence = self:GetSequenceName(self:GetSequence())
	self.GoalDist = self:GetPathDistanceToGoal()
	self.GoalTime = self:GetPathTimeToGoal()
	local ent = self:GetEnemy()
	local dist = self.NearestPointToEnemyDistance
	local cont = self.VJ_TheController
	local key_atk = IsValid(cont) && cont:KeyDown(IN_ATTACK)
	local key_for = IsValid(cont) && cont:KeyDown(IN_FORWARD)
	local key_bac = IsValid(cont) && cont:KeyDown(IN_BACK)
	local key_lef = IsValid(cont) && cont:KeyDown(IN_MOVELEFT)
	local key_rig = IsValid(cont) && cont:KeyDown(IN_MOVERIGHT)
	local key_jum = IsValid(cont) && cont:KeyDown(IN_JUMP)
	local isMoving = (key_for || key_bac || key_lef || key_rig)

	self:SetNW2Int("HP",self:Health())

	-- self.CanFlinch = self:GetState() != VJ_STATE_NONE && 0 or 1

	if key_jum then
		local dTbl = {}
		if key_bac then table.insert(dTbl,1) end
		if key_rig then table.insert(dTbl,2) end
		if key_lef then table.insert(dTbl,3) end
		if key_for then table.insert(dTbl,4) end
		if #dTbl <= 0 then
			dTbl = 1
		end
		self:Dodge(dTbl)
	end

	if !self:IsBusy() && self.LastActivity == ACT_WALK && (!IsValid(cont) && self.GoalTime <= 1.2 && self.GoalTime > 0.2 or IsValid(cont) && !isMoving) && self.LastSequence != "walk_to_idle" then
		self:VJ_ACT_PLAYACTIVITY("walk_to_idle",true,false,false)
	-- elseif self.LastActivity == ACT_IDLE && self:GetActivity() == ACT_WALK then
		-- self:VJ_ACT_PLAYACTIVITY("vjges_idle_to_walk",true,false,false)
		-- self:ResetIdealActivity(VJ_SequenceToActivity(self,"idle_to_walk"))
	end

	self.LastActivity = self:GetActivity()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dodge(forceSide)
	if self:IsBusy() then return end
	local myPos = self:GetPos()
	local myPosCentered = self:GetPos() +self:OBBCenter()
	local positions = {
		[1] = -self:GetForward(),
		[2] = self:GetRight(),
		[3] = -self:GetRight()
	}
	local isGood = {}
	for i = 1,3 do
		local tr = util.TraceLine({
			start = myPosCentered,
			endpos = myPosCentered +positions[i] *300,
			filter = self
		})
		if !tr.Hit then
			table.insert(isGood,i)
		end
	end
	if #isGood <= 0 then
		isGood = {4}
	end
	local side = forceSide or VJ_PICK(isGood)
	if istable(side) then side = VJ_PICK(side) end
	self:VJ_ACT_PLAYACTIVITY(side == 1 && "dodge_b" or side == 2 && "dodge_r" or side == 3 && "dodge_l" or side == 4 && {"dodge_f","dodge_f2"},true,false,true)

	local snd = VJ_PICK(self.SoundTbl_Dodge)
	local dur = SoundDuration(snd)

	self.Attacking = false
	self:StopAllCommonSpeechSounds()
	self.NextAlertSoundT = CurTime() +dur +math.Rand(1,2)
	self.NextInvestigateSoundT = CurTime() +dur +math.Rand(3,4)
	self.NextIdleSoundT_RegularChange = CurTime()  +dur +math.Rand(3,4)
	VJ_CreateSound(self,snd,78)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local bulletDMG = dmginfo:IsBulletDamage()
	local isBSDamage = (bulletDMG or dmgtype == DMG_DIRECT)

	if bulletDMG then
		dmginfo:SetDamage(math.Clamp(dmg *0.05,1,dmg))
	elseif !isBSDamage && math.random(1,3) == 1 then
		local randPick = math.random(1,10)
		if randPick >= 7 then
			self:Dodge()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self:Health() <= self:GetMaxHealth() *0.5 && self.Phase == 1 then
		self:SetPhase(2)
		self:SetHealth(self:GetMaxHealth() *0.5)
		return
	end
end