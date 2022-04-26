AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/mgr/jetstream_sam.mdl"}
ENT.StartHealth = 6000
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

ENT.SoundTbl_FootStep = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetPhase(2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,75,math.random(90,110))
	end
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