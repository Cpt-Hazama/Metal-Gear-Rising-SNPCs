AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/humans/group01/male_01.mdl","models/humans/group01/male_03.mdl","models/humans/group02/male_01.mdl","models/humans/group02/male_03.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN

ENT.BloodColor = "Red"

ENT.VJ_NPC_Class = {"CLASS_BRONX"}

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"throw1"}
ENT.TimeUntilMeleeAttackDamage = 0.3
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 80
ENT.MeleeAttackDamage = 5

ENT.HasExtraMeleeAttackSounds = true

ENT.GeneralSoundPitch1 = 80
ENT.GeneralSoundPitch2 = 90

ENT.SoundTbl_Idle = {
	"cpthazama/bronx/did_you_say.wav",
	"cpthazama/bronx/do_something.wav",
	"cpthazama/bronx/eat_a_dick.wav",
	"cpthazama/bronx/punkass.wav"
}
ENT.SoundTbl_Alert = ENT.SoundTbl_Idle
ENT.SoundTbl_MeleeAttackExtra = {"weapons/knife/knife_hit1.wav","weapons/knife/knife_hit2.wav","weapons/knife/knife_hit3.wav","weapons/knife/knife_hit4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"weapons/iceaxe/iceaxe_swing1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local weps = {
		"models/weapons/w_crowbar.mdl",
		"models/props_canal/mattpipe.mdl",
		"models/weapons/w_knife_ct.mdl"
	}
	local n = ents.Create("prop_vj_animatable")
	n:SetModel(VJ_PICK(weps))
	n:SetPos(self:GetPos())
	n:SetAngles(self:GetAngles())
	n:Spawn()
	n:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	n:SetOwner(self)
	n:SetParent(self)
	n:AddEffects(EF_BONEMERGE)
	self:DeleteOnRemove(n)

	local n = ents.Create("prop_vj_animatable")
	n:SetModel(self:GetModel())
	n:SetPos(self:GetPos())
	n:SetAngles(self:GetAngles())
	n:Spawn()
	n:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	n:SetOwner(self)
	n:SetParent(self)
	n:AddEffects(EF_BONEMERGE)
	n:SetMaterial("models/player/shared/gold_player")
	self:DeleteOnRemove(n)
	self.Nano = n

	self:EffectNano(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.AnimationPlaybackRate = self:IsMoving() && 2 or 5
	if self:IsMoving() then
		self:SetVelocity(self:GetMoveVelocity() *5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EffectNano(boneID,reset)
	local n = self.Nano
	if !IsValid(n) then return end

	if boneID == false then
		for i = 1,n:GetBoneCount() -1 do -- Initialize
			n:ManipulateBoneScale(i,Vector(0,0,0))
		end
	elseif reset == true then
		n:ManipulateBoneScale(boneID,Vector(0,0,0))
	else
		n:ManipulateBoneScale(boneID,Vector(1.1,1.1,1.1))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
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
		local dmg = dmginfo:GetDamage()
		dmginfo:SetDamage(math.Clamp(dmg *0.05,1,dmg))
	end
end