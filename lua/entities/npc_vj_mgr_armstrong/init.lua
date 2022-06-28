AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/armstrong.mdl"}
ENT.StartHealth = 10000
ENT.HullType = HULL_LARGE

ENT.VJ_NPC_Class = {"CLASS_MG_DESPERADO","CLASS_MG_WORLDMARSHALL","CLASS_UNITED_STATES"}

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true

ENT.AttackProps = false

ENT.AnimTbl_Movements = {
	[1] = {Start = "0010",Loop = {ACT_WALK}, End = "0012", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
	[3] = {Start = "0030",Loop = {ACT_RUN}, End = "0031", ReqIdle = {ACT_IDLE,ACT_WALK}, GoalMax = 0.21, GoalMin = 0},
}

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetPhase(1)

	self.BoneData = {}
	self.NanoMachinesDead = false

	local n = ents.Create("prop_vj_animatable")
	n:SetModel("models/cpthazama/mgr/armstrong_particles.mdl")
	n:SetPos(self:GetPos())
	n:SetAngles(self:GetAngles())
	n:Spawn()
	n:SetSolid(SOLID_NONE)
	n:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	n:SetOwner(self)
	n:SetParent(self)
	n:AddEffects(EF_BONEMERGE)
	n:SetSkin(1)
	n:SetBodygroup(4,1)
	n:SetBodygroup(6,1)
	self:DeleteOnRemove(n)
	self.Nano = n
	self:EffectNano(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangePhase(phase)
	if phase == 1 then
		self:SetSkin(0)
	elseif phase == 2 then
		self:SetSkin(0)
		self:SetBodygroup(4,1)
		self:SetBodygroup(6,1)
		self:SetBodygroup(7,1)
	elseif phase == 3 then
		local n = ents.Create("prop_vj_animatable")
		n:SetModel("models/cpthazama/mgr/armstrong_particles.mdl")
		n:SetPos(self:GetPos())
		n:SetAngles(self:GetAngles())
		n:Spawn()
		n:SetSolid(SOLID_NONE)
		n:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		n:SetOwner(self)
		n:SetParent(self)
		n:SetNoDraw(true)
		n:AddEffects(EF_BONEMERGE)
		self:DeleteOnRemove(n)
		self.ParticleMesh = n

		self:SetSkin(2)

		ParticleEffectAttach("vj_mgr_armstrong_smoke",PATTACH_POINT_FOLLOW,n,0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec0 = Vector(0,0,0)
local vec1 = Vector(1.065,1.1,1.065)
--
function ENT:EffectNano(boneID,reset)
	local n = self.Nano
	if !IsValid(n) then return end

	if boneID == false then
		table.Empty(self.BoneData)
		for i = 1,n:GetBoneCount() -1 do -- Initialize
			n:ManipulateBoneScale(i,vec0)
		end
	elseif reset == true then
		-- table.remove(self.BoneData,boneID)
		-- n:ManipulateBoneScale(boneID,vec0)
		self.BoneData[boneID] = self.BoneData[boneID] or {}
		self.BoneData[boneID].CurrentValue = self.BoneData[boneID].CurrentValue or vec1
		self.BoneData[boneID].TargetValue = vec0
	else
		self.BoneData[boneID] = self.BoneData[boneID] or {}
		self.BoneData[boneID].CurrentValue = self.BoneData[boneID].CurrentValue or vec0
		self.BoneData[boneID].TargetValue = vec1
		self.BoneData[boneID].ResetTime = CurTime() +2.5
		-- n:ManipulateBoneScale(boneID,vec1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomThink(ent,dist,cont,key_atk,key_for,key_bac,key_lef,key_rig,key_jum,isMoving)
	local n = self.Nano
	if IsValid(n) && self.BoneData then
		local FT = FrameTime() *18
		for id,v in pairs(self.BoneData) do
			if v.ResetTime < CurTime() then
				self:EffectNano(id,true)
			end
			v.CurrentValue = LerpVector(FT,v.CurrentValue,v.TargetValue)
			n:ManipulateBoneScale(id,v.CurrentValue)
		end
	end
	self:VJ_MGR_UniqueMovement()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if self.NanoMachinesDead == false then
		local dmgpos = dmginfo:GetDamagePosition()
		local lastBone = false
		local lastDist = 999999999
		for i = 1,self:GetBoneCount() -1 do
			local bonepos,boneang = self:GetBonePosition(i)
			local dist = bonepos:Distance(dmgpos)
			if dist <= lastDist then
				lastDist = dist
				lastBone = i
			end
		end

		if lastBone != false then
			self:EffectNano(lastBone)
			for _,v in pairs(self:GetChildBones(lastBone)) do
				self:EffectNano(v)
			end
			for i = 1,math.random(2,4) do
				lastBone = self:GetBoneParent(lastBone)
				self:EffectNano(lastBone)
			end

			local dmg = dmginfo:GetDamage()
			dmginfo:SetDamage(math.Clamp(dmg *0.05,1,dmg))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnBleed(dmginfo, hitgroup)
	local phase = self:GetPhase()
	if self:Health() <= self:GetMaxHealth() *0.95 && phase == 1 then
		self:SetPhase(2)
	elseif self:Health() <= self:GetMaxHealth() *0.35 && phase == 2 then
		self:SetPhase(3)
	end

	if self.NanoMachinesDead then return end
	if self:Health() <= self:GetMaxHealth() *0.05 then
		self:EffectNano(false)
		self.Nano:Remove()
		self.NanoMachinesDead = true
	end
end