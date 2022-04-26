AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HullType = HULL_HUMAN

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true

ENT.AttackProps = false
ENT.PushProps = false

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.ComboStrings = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.IsStunned = false
	self.CurrentStringTable = {}
	self.StringCount = 0
	self.CurrentStringNum = 0
	self.CurrentStringAnim = nil
	self.Attacking = false

	if self.OnInit then
		self:OnInit()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetPhase(i)
	self.Phase = i
	self:SetNW2Int("Phase",i)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local debug = false
local doEntPos = true
--
function ENT:StartDamageCalc(dmg)
	local wep = self:GetNW2Entity("Weapon")
	if !IsValid(wep) then return end
	self.TraceCalcData = {}
	self.EntitiesToDamage = {}
	self.PreviousCurTime = 0
	
	local hookName = "VJ_MGR_TraceAttackData_" .. self:EntIndex()
	hook.Add("Think",hookName,function()
		if !IsValid(self) or !IsValid(wep) then
			hook.Remove("Think",hookName)
			return
		end
		for v = 1,wep:GetBoneCount() -1 do
			local targetPos = self.TraceCalcData[v] && self.TraceCalcData[v][self.PreviousCurTime] && self.TraceCalcData[v][self.PreviousCurTime].LastPos or wep:GetBonePosition(v)
			targetPos.z = doEntPos && IsValid(self:GetEnemy()) && self:GetEnemy():WorldSpaceCenter().z or targetPos.z
			local tr = util.TraceHull({
				start = wep:GetBonePosition(v),
				endpos = targetPos,
				filter = {self,wep},
				mins = Vector(-5,-5,-5),
				maxs = Vector(5,5,5)
			})
			local tr2 = util.TraceHull({
				start = tr.HitPos,
				endpos = self:WorldSpaceCenter(),
				filter = {self,wep},
				mins = Vector(-5,-5,-5),
				maxs = Vector(5,5,5)
			})
			local ent = tr.Entity
			local originalData = tr
			if !IsValid(ent) then
				ent = tr2.Entity
				tr = tr2
			end
			self.PreviousCurTime = CurTime()
			self.TraceCalcData[v] = {}
			self.TraceCalcData[v][self.PreviousCurTime] = {
				LastPos = wep:GetBonePosition(v),
				Pos = tr.HitPos,
				Ent = ent,
				Mat = tr.MatType,
				Normal = tr.HitNormal,
				HitGroup = tr.HitGroup
			}
			if debug then
				local ang = (tr.HitPos -tr.StartPos):Angle()
				VJ_CreateTestObject(originalData.HitPos, ang, Color(255,0,0), 3)
				VJ_CreateTestObject(tr.HitPos, ang, Color(255,0,242), 3)
			end
			if tr.Hit && IsValid(ent) && self:DoRelationshipCheck(ent) == true && !VJ_HasValue(self.EntitiesToDamage,ent) then
				table.insert(self.EntitiesToDamage,ent)
				self:DealDamage(dmg,ent,tr)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EndDamageCalc()
	self.TraceCalcData = nil
	self.LastCalcData = nil
	self.PreviousCurTime = nil
	hook.Remove("Think","VJ_MGR_TraceAttackData_" .. self:EntIndex())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DealDamage(dmg,ent,tr)
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(dmg or 1)
	dmginfo:SetDamagePosition(istable(tr) && tr.HitPos or tr)
	dmginfo:SetDamageType(DMG_SLASH)
	dmginfo:SetAttacker(self)
	dmginfo:SetInflictor(self)
	ent:TakeDamageInfo(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "dmg_end" then
		self:EndDamageCalc()
	elseif key == "combo_end" then
		self:CheckCanContinueString()
	end

	if self.DoEvents then
		self:DoEvents(key)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackNames(ent)
	if ent.MeleeAttacking or ent.IsAttacking or ent.Attacking or ent.RangeAttacking then return true end
	local tbl = {"melee","attack","range","atk"}
	local filter = {"idle","walk","run"}
	local seq = ent:GetSequenceName(ent:GetSequence())
	for _,v in pairs(tbl) do
		if string.find(seq,v) then
			for _,k in pairs(filter) do
				if string.find(seq,k) then
					return false
				end
			end
			return true
		end
	end
	return false
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

	self.CanFlinch = self:GetState() != VJ_STATE_NONE && 0 or 1

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

	if IsValid(ent) && !self:IsBusy() then
		if key_atk or !IsValid(cont) && dist <= self.MeleeAttackDistance && !self.Attacking && self:CheckCanSee(ent,55) then
			self:Attack()
		end
		if self:GetAttackNames(ent) && dist <= 350 && math.random(1,4) == 1 then
			self:Dodge()
		end
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
	local dur = snd && SoundDuration(snd) or 0

	self.Attacking = false
	self:StopAllCommonSpeechSounds()
	self.NextAlertSoundT = CurTime() +dur +math.Rand(1,2)
	self.NextInvestigateSoundT = CurTime() +dur +math.Rand(3,4)
	self.NextIdleSoundT_RegularChange = CurTime()  +dur +math.Rand(3,4)
	if snd then
		VJ_CreateSound(self,snd,78)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Block(dmginfo)
	if self.Attacking or self:GetState() != VJ_STATE_NONE then return end
	-- if self:IsBusy() then return end

	self:VJ_ACT_PLAYACTIVITY("block_hit",true,false,true)

	local dmg = dmginfo:GetDamage()
	dmginfo:SetDamage(math.Clamp(dmg *0.05,1,dmg))

	local snd = VJ_PICK(self.SoundTbl_Block)
	local dur = SoundDuration(snd)

	self.Attacking = false
	self:StopAllCommonSpeechSounds()
	self.NextAlertSoundT = CurTime() +dur +math.Rand(1,2)
	self.NextInvestigateSoundT = CurTime() +dur +math.Rand(3,4)
	self.NextIdleSoundT_RegularChange = CurTime()  +dur +math.Rand(3,4)
	VJ_CreateSound(self,snd,78)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Stun()
	if self:GetState() != VJ_STATE_NONE then return end
	if self.IsStunned then return end

	self:StopAllCommonSounds()
	self:SetVelocity(Vector(0,0,0))
	self.NextIdleSoundT = CurTime() +math.Rand(self.NextSoundTime_Idle.a, self.NextSoundTime_Idle.b) *1.5
	self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
	self.Attacking = false
	self.IsStunned = true
	if self.OnStunned then
		self:OnStunned()
	end
	self:SetEnemy(NULL)
	self:VJ_ACT_PLAYACTIVITY("vjseq_stun_start",true,false,false,0,{OnFinish=function(interrupted,anim)
		self:VJ_ACT_PLAYACTIVITY("vjseq_stun_end",true,false,false,0,{OnFinish=function(interrupted,anim)
			self:SetEnemy(NULL)
			self:SetState()
			self.IsStunned = false
			if self.OnStunEnded then
				self:OnStunEnded()
			end
		end})
	end})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local isBSDamage = (dmgtype == DMG_BULLET or dmgtype == DMG_DIRECT)

	if !isBSDamage && math.random(1,3) == 1 then
		local randPick = math.random(1,10)
		if randPick >= 7 then
			self:Dodge()
		else
			self:Block(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local isBSDamage = (dmgtype == DMG_BULLET or dmgtype == DMG_DIRECT)

	if dmg >= 95 && !isBSDamage && self:GetState() == VJ_STATE_NONE && math.random(1,4) == 1 then
		self:Stun()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
	self.Attacking = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Attack()
	if !self.CanMeleeAttack then return end
	if self.Attacking then return end
	if self:IsBusy() then return end
	for k,v in RandomPairs(self.ComboStrings) do
		self:PlayString(true,v)
		break
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayString(init,tbl)
	if !isstring(tbl[1]) then
		tbl[1](self)
		return
	end
	self.Attacking = true
	if init then
		self.CurrentStringTable = tbl
		self.StringCount = #tbl
		self.CurrentStringNum = 1
	else
		self.CurrentStringNum = self.CurrentStringNum +1
	end
	self.CurrentStringAnim = tbl[self.CurrentStringNum]
	self:VJ_ACT_PLAYACTIVITY(self.CurrentStringAnim,true,false,false)
	if self.CurrentStringNum == self.StringCount then
		self.Attacking = false
	end
	local wep = self.Weapon
	local effectdata = EffectData()
	effectdata:SetEntity(self)
	effectdata:SetOrigin(self:GetAttachment(1).Pos)
	effectdata:SetScale(1)
	effectdata:SetAttachment(1)
	effectdata:SetMagnitude(1)
	util.Effect("VJ_MGR_Highlight",effectdata)
	if IsValid(wep) then
		local effectdata = EffectData()
		effectdata:SetEntity(wep)
		effectdata:SetOrigin(self:GetAttachment(1).Pos)
		effectdata:SetScale(1)
		effectdata:SetMagnitude(1)
		util.Effect("VJ_MGR_Highlight",effectdata)
	end
	if math.random(1,6) == 1 then
		local snd = VJ_PICK(self.SoundTbl_Attack)
		local dur = SoundDuration(snd)

		self:StopAllCommonSpeechSounds()
		self.NextAlertSoundT = CurTime() +dur +math.Rand(1,2)
		self.NextInvestigateSoundT = CurTime() +dur +math.Rand(3,4)
		self.NextIdleSoundT_RegularChange = CurTime()  +dur +math.Rand(3,4)
		VJ_CreateSound(self,snd,78)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckContinueString()
	if self.CurrentStringNum +1 <= self.StringCount then
		self.vACT_StopAttacks = false
		self:PlayString(false,self.CurrentStringTable)
	else
		self.Attacking = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckCanContinueString()
	if (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK)) or !self.VJ_IsBeingControlled && IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) <= 240 && self:CheckCanSee(self:GetEnemy(),55) then
		self:CheckContinueString()
	else
		self.Attacking = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckCanSee(ent,cone)
	return (self:GetSightDirection():Dot((ent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(cone)))
end