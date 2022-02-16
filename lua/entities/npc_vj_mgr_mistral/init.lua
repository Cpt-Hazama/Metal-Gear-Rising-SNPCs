AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/mistral.mdl"}
ENT.StartHealth = 5000

ENT.VJ_NPC_Class = {"CLASS_MG_DESPERADO"}

ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 30, -40), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "bone005", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(5,0,3), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 1, -- Should the camera's angle be affected by the bone's angle?
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? (Useful for weird bone angles, this is the roll angle)
}

ENT.BloodColor = "Red"

ENT.CanFlinch = 1
ENT.AnimTbl_Flinch = {"flinch1","flinch2","flinch3","flinch4","flinch5"}

ENT.HullType = HULL_HUMAN

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true

ENT.AttackProps = false
ENT.PushProps = false

ENT.ConstantlyFaceEnemy_Postures = "Moving"
ENT.ConstantlyFaceEnemyDistance = 2500

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {
	"player/footsteps/fs_tile_01.wav",
	"player/footsteps/fs_tile_02.wav",
	"player/footsteps/fs_tile_03.wav",
	"player/footsteps/fs_tile_04.wav",
	"player/footsteps/fs_tile_05.wav",
	"player/footsteps/fs_tile_06.wav",
	"player/footsteps/fs_tile_07.wav",
	"player/footsteps/fs_tile_08.wav",
	"player/footsteps/fs_tile_09.wav"
}
ENT.SoundTbl_Alert = {
	"cpthazama/mgr/mistral/1003591956.wav",
	"cpthazama/mgr/mistral/1060961659.wav",
	"cpthazama/mgr/mistral/494685919.wav",
}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/mgr/mistral/1520984.wav",
	"cpthazama/mgr/mistral/1832697.wav",
	"cpthazama/mgr/mistral/191594019.wav",
	"cpthazama/mgr/mistral/257995098.wav",
	"cpthazama/mgr/mistral/386741036.wav",
	"cpthazama/mgr/mistral/412054549.wav",
	"cpthazama/mgr/mistral/67317714.wav",
}
ENT.SoundTbl_Attack = {
	"cpthazama/mgr/mistral/111569964.wav",
	"cpthazama/mgr/mistral/173104508.wav",
	"cpthazama/mgr/mistral/238537145.wav",
	"cpthazama/mgr/mistral/24607761.wav",
	"cpthazama/mgr/mistral/298148305.wav",
	"cpthazama/mgr/mistral/316410279.wav",
	"cpthazama/mgr/mistral/414107338.wav",
	"cpthazama/mgr/mistral/6225526.wav",
	"cpthazama/mgr/mistral/769960552.wav",
}
ENT.SoundTbl_Range = {
	"cpthazama/mgr/mistral/846239878.wav",
	"cpthazama/mgr/mistral/912568754.wav",
}
ENT.SoundTbl_Grab = {
	"cpthazama/mgr/mistral/173833965.wav",
	"cpthazama/mgr/mistral/202842303.wav",
	"cpthazama/mgr/mistral/212335084.wav",
	"cpthazama/mgr/mistral/334777672.wav",
	"cpthazama/mgr/mistral/360047350.wav",
	"cpthazama/mgr/mistral/41005301.wav",
	"cpthazama/mgr/mistral/62654856.wav",
	"cpthazama/mgr/mistral/665305162.wav",
}
ENT.SoundTbl_PhaseShift = {
	"cpthazama/mgr/mistral/421918014.wav",
	"cpthazama/mgr/mistral/429195703.wav",
	"cpthazama/mgr/mistral/552243311.wav",
}
ENT.SoundTbl_Block = {
	"cpthazama/mgr/mistral/436984427.wav",
	"cpthazama/mgr/mistral/445335282.wav",
	"cpthazama/mgr/mistral/492042160.wav",
	"cpthazama/mgr/mistral/505315955.wav",
	"cpthazama/mgr/mistral/570540909.wav",
	"cpthazama/mgr/mistral/583596580.wav",
	"cpthazama/mgr/mistral/735003653.wav",
}
ENT.SoundTbl_KnockDown = {
	"cpthazama/mgr/mistral/880470428.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/mgr/mistral/696886766.wav",
	"cpthazama/mgr/mistral/734902553.wav",
	"cpthazama/mgr/mistral/871259016.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/mgr/mistral/118339309.wav",
	"cpthazama/mgr/mistral/150591575.wav",
	"cpthazama/mgr/mistral/169059051.wav",
	"cpthazama/mgr/mistral/216228177.wav",
	"cpthazama/mgr/mistral/251551634.wav",
	"cpthazama/mgr/mistral/278436069.wav",
	"cpthazama/mgr/mistral/337818892.wav",
	"cpthazama/mgr/mistral/3984823.wav",
	"cpthazama/mgr/mistral/409187618.wav",
	"cpthazama/mgr/mistral/491533799.wav",
	"cpthazama/mgr/mistral/518888898.wav",
	"cpthazama/mgr/mistral/58650896.wav",
	"cpthazama/mgr/mistral/661367719.wav",
	"cpthazama/mgr/mistral/692792614.wav",
	"cpthazama/mgr/mistral/947714813.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/mgr/mistral/152005700.wav",
	"cpthazama/mgr/mistral/182764983.wav",
	"cpthazama/mgr/mistral/245585169.wav",
	"cpthazama/mgr/mistral/282444020.wav",
	"cpthazama/mgr/mistral/314524779.wav",
	"cpthazama/mgr/mistral/510297394.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterStartTimer(seed)
	if math.random(1,5) == 1 then
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
function ENT:CustomOnInitialize()
	self.IsStunned = false

	self:SetWeapon(true)
	self:SetPhase(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetPhase(i)
	if i == 1 then
		self.AnimTbl_MeleeAttack = {
			"attack1",	
			"attack2",
			"attack3",
			"attack4",
			"attack5",
			"attack6",
			"attack7",
			"attack8",
			"attack12",
			"attack13",
			"attack15",
			"attack16",
		}
		
		self:SetBodygroup(1,0)
	elseif i == 2 then
		VJ_CreateSound(self,self.SoundTbl_PhaseShift,80)
		self.AnimTbl_MeleeAttack = {
			"attack1",
			"attack2",
			"attack3",
			"attack4",
			"attack5",
			"attack6",
			"attack7",
			"attack8",
			"attack9",
			"attack10",
			"attack11",
			"attack12",
			"attack13",
			"attack14",
			"attack15",
			"attack16",
		}
		
		self:SetBodygroup(1,1)
	end
	self.Phase = i
	self:SetNW2Int("Phase",i)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetWeapon(b)
	if b then
		local wep = ents.Create("prop_vj_animatable")
		wep:SetModel("models/cpthazama/mgr/weapons/gekko_whip.mdl")
		wep:SetPos(self:GetPos())
		wep:SetAngles(self:GetAngles())
		wep:Spawn()
		wep:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		wep:SetParent(self)
		wep:Fire("SetParentAttachment", "rhand_att3", 0)
		self:DeleteOnRemove(wep)
		self:SetNW2Entity("Weapon",wep)
		self.Weapon = wep

		self.AnimTbl_Run = {ACT_WALK}
	else
		SafeRemoveEntity(self.Weapon)

		self.AnimTbl_Run = {ACT_RUN}
	end
	self.HasMeleeAttack = b
	self.ConstantlyFaceEnemy = b
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
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetDamageType(DMG_SLASH)
	dmginfo:SetAttacker(self)
	dmginfo:SetInflictor(self)
	ent:TakeDamageInfo(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	elseif key == "pre_spin" then
		VJ_CreateSound(self,"cpthazama/mgr/mistral/493258989.wav",75)
	elseif key == "dodge_savepos" then
		local pos = self:GetBonePosition(1)
		pos.z = self:GetPos().z
		if !util.IsInWorld(pos) then
			pos = self:GetPos()
		end
		self.SavePos = pos
	elseif key == "dodge_sendpos" then
		self:SetPos(self.SavePos)
	elseif key == "dmg_start" then
		self:StartDamageCalc(math.random(50,60))
	elseif key == "dmg_whip_start" then
		self:StartDamageCalc(math.random(60,70))
	elseif key == "dmg_end" then
		self:EndDamageCalc()
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

	if IsValid(ent) && self:GetAttackNames(ent) && dist <= 350 && !self:IsBusy() && math.random(1,4) == 1 then
		self:Dodge()
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

	if math.random(1,6) == 1 && !self:IsBusy() && !isBSDamage then
		self:Dodge()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self:Health() <= self:GetMaxHealth() *0.5 && self.Phase == 1 then
		self:SetPhase(2)
		self:SetHealth(self:GetMaxHealth() *0.5)
	end

	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local isBSDamage = (dmgtype == DMG_BULLET or dmgtype == DMG_DIRECT)

	if dmg >= 95 && !isBSDamage && self:GetState() == VJ_STATE_NONE && math.random(1,4) == 1 then
		self:Stun()
	end
end