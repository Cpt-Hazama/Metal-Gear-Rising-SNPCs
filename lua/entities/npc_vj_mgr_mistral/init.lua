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

ENT.MeleeAttackDistance = 100

ENT.ConstantlyFaceEnemy_Postures = "Moving"
ENT.ConstantlyFaceEnemyDistance = 2500

ENT.AnimTbl_Movements = {
	[1] = {Start = "idle_to_walk",Loop = {ACT_WALK}, End = "walk_to_idle", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
	[2] = {Start = "idle_to_walk",Loop = {ACT_RUN}, End = "walk_to_idle", ReqIdle = {ACT_IDLE,ACT_WALK}, GoalMax = 0.24, GoalMin = 0},
}

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
function ENT:OnInit()
	if self.IsLimited then
		self:SetBodygroup(1,1)
		self:SetBodygroup(4,1)
	end

	self:SetWeapon(true)
	self:SetPhase(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetPhase(i)
	if i == 1 then
		self.ComboStrings = {
			{
				"attack1",
				"attack2",
				"attack3",
			},
			{
				"attack5",
				"attack2",
			},
			{
				"attack1",
				"attack2",
				"attack6",
			},
			{
				"attack6",
				"attack7",
			},
			{
				"attack6",
				"attack8",
			},
			{
				"attack16",
				"attack15",
				"attack12",
			},
			{
				function(self)
					self:AttackUnique(13)
				end
			},
		}
		
		self:SetBodygroup(2,0)
	elseif i == 2 then
		VJ_CreateSound(self,self.SoundTbl_PhaseShift,80)
		self.ComboStrings = {
			{
				"attack1",
				"attack2",
				"attack3",
			},
			{
				"attack5",
				"attack2",
			},
			{
				"attack1",
				"attack2",
				"attack6",
			},
			{
				"attack6",
				"attack7",
			},
			{
				"attack6",
				"attack8",
			},
			{
				"attack16",
				"attack15",
				"attack12",
			},
			{
				"attack9",
			},
			{
				"attack10",
			},
			{
				"attack11",
			},
			{
				function(self)
					self:AttackUnique(13)
				end
			},
		}
		
		self:SetBodygroup(2,1)
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

		self.AnimTbl_Run = {ACT_RUN_STIMULATED}
	else
		SafeRemoveEntity(self.Weapon)

		self.AnimTbl_Run = {ACT_RUN}
	end
	self.CanMeleeAttack = b
	self.ConstantlyFaceEnemy = b
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEvents(key)
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
		self.SaveAng = self:GetAttachment(self:LookupAttachment("eyes")).Ang
		self.SavePos = pos
	elseif key == "dodge_sendpos" then
		self:SetPos(self.SavePos)
		local ply = self.VJ_TheController
		if IsValid(ply) then
			local ang = ply:EyeAngles()
			local ang2 = self:GetAngles()
			ang[2] = self.SaveAng[2]
			ang2[2] = self.SaveAng[2]
			self:SetAngles(ang2)
			ply:SetEyeAngles(ang)
		end
	elseif key == "melee" then
		local myPos = self:GetPos()
		local hitRegistered = false
		for _,v in pairs(ents.FindInSphere(self:SetMeleeAttackDamagePosition(), 165)) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end -- If controlled and v is the bullseye OR it's a player controlling then don't damage!
			if v != self && v:GetClass() != self:GetClass() && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVar("ai_ignoreplayers"):GetInt() == 0)) && self:Disposition(v) != D_LI) or v:GetClass() == "func_breakable_surf" or self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) && self:GetSightDirection():Dot((Vector(v:GetPos().x, v:GetPos().y, 0) - Vector(myPos.x, myPos.y, 0)):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius)) then
				if self:VJ_GetNearestPointToEntityDistance(v) > self.MeleeAttackDistance then continue end //if (self:GetPos():Distance(v:GetPos()) <= self:VJ_GetNearestPointToEntityDistance(v) && self:VJ_GetNearestPointToEntityDistance(v) <= self.MeleeAttackDistance) == false then
				self:DealDamage(10,v,v:GetPos() +v:OBBCenter())
			end
		end
	elseif key == "dmg_start" then
		if IsValid(self:GetEnemy()) then
			self:FaceCertainEntity(self:GetEnemy(), true)
		end
		self:StartDamageCalc(math.random(50,60))
	elseif key == "dmg_whip_start" then
		self:StartDamageCalc(math.random(60,70))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink(ent,dist,cont,key_atk,key_for,key_bac,key_lef,key_rig,key_jum,isMoving)
	self:VJ_MGR_UniqueMovement()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AttackUnique(atk)
	self.Attacking = true
	if atk == 13 then
		self:VJ_ACT_PLAYACTIVITY("attack13_pre",true,false,true,0,{OnFinish=function(interrupted,anim)
			if interrupted then
				return
			end
			local animDur = VJ_GetSequenceDuration(self,"attack13")
			local maxSpins = 6
			for i = 0,maxSpins do
				timer.Simple(i *animDur,function()
					if IsValid(self) && IsValid(self:GetEnemy()) then
						if self:GetState() != VJ_STATE_NONE or self.IsStunned then return end
						self:SetAngles(Angle(0,(self:GetEnemy():GetPos() -self:GetPos()):Angle().y,0))
						self:VJ_ACT_PLAYACTIVITY("attack13",true,false,false,0,{OnFinish=function(interrupted,anim)
							if i == maxSpins then
								self.Attacking = false
							end
						end})
						self:SetVelocity(self:GetMoveVelocity() *2.25)
					end
				end)
			end
		end})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if self:Health() <= self:GetMaxHealth() *0.5 && self.Phase == 1 then
		self:SetPhase(2)
		self:SetState(VJ_STATE_NONE)
		self:Stun()
		self:SetHealth(self:GetMaxHealth() *0.5)
		return
	end

	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local isBSDamage = (dmgtype == DMG_BULLET or dmgtype == DMG_DIRECT)

	if dmg >= 95 && !isBSDamage && self:GetState() == VJ_STATE_NONE && math.random(1,4) == 1 then
		self:Stun()
	end
end