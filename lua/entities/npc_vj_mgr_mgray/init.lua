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
ENT.TurningSpeed = 5
ENT.VJ_IsHugeMonster = true

ENT.MaxJumpLegalDistance = VJ_Set(6500, 7500)

ENT.VJ_NPC_Class = {"CLASS_MG_DESPERADO"}

ENT.Bleeds = false

-- ENT.CanFlinch = 1
-- ENT.AnimTbl_Flinch = {"flinch1","flinch2","flinch3","flinch4","flinch5"}

ENT.HasMeleeAttack = false
ENT.MeleeAttackDistance = 100
ENT.AnimTbl_MeleeAttack = nil
ENT.TimeUntilMeleeAttackDamage = false
ENT.DisableDefaultMeleeAttackCode = true

ENT.AttackProps = false

ENT.AnimTbl_Movements = {
	[1] = {Start = "0010",Loop = {ACT_WALK}, End = "0012", ReqIdle = {ACT_IDLE}, GoalMax = 1.2, GoalMin = 0.2},
}
ENT.AnimTbl_Dodge = {
	[1] = {"0080","0082"},
}

ENT.DisableFootStepSoundTimer = true
ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.SoundTbl_FootStep = {
	"cpthazama/mgr/mgray/em0200_se_foot_walk_low_1 15543702.ogg",
	"cpthazama/mgr/mgray/em0200_se_foot_walk_low_2 194576810.ogg",
	"cpthazama/mgr/mgray/em0200_se_foot_walk_low_3 234980873.ogg",
	"cpthazama/mgr/mgray/em0200_se_foot_walk_low_4 139846431.ogg"
}
ENT.SoundTbl_LaserImpact = {
	"cpthazama/mgr/mgray/em0200_se_atk_laser_hit_ground_01 165582690.ogg",
	"cpthazama/mgr/mgray/em0200_se_atk_laser_hit_ground_02 85803110.ogg",
	"cpthazama/mgr/mgray/em0200_se_atk_laser_hit_ground_03 53821731.ogg"
}

RAY_SET_LASER = 2026
RAY_SET_LASER_DOUBLE = 2020
RAY_SET_LASER_END = 2030
RAY_SET_MELEE_DOUBLE_SWIPE = 2400
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(50,50,700),Vector(-50,-50,0))
	-- self:SetCollisionBounds(Vector(1,1,700),Vector(-1,-1,0))
	-- VJ_CreateBoneFollower(self)

	self.LaserLoop = CreateSound(self,"cpthazama/mgr/mgray/em0200_se_atk_laser_loop.wav")
	self.LaserLoop:SetSoundLevel(140)

	self.NextLaserAttackT = CurTime() +math.Rand(2,4)
	self.RandomStopLaserT = 0
	self.Cont_NextJumpT = 0
	
	for i = 1,20 do
		util.SpriteTrail(self,i +2,Color(255,0,0,255),true,5,1,0.1,1/(15+1)*0.5,"trails/laser.vmt")
		local glow1 = ents.Create("env_sprite")
		glow1:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
		glow1:SetKeyValue("scale","0.25")
		glow1:SetKeyValue("rendermode","9")
		glow1:SetKeyValue("rendercolor","255 0 0")
		glow1:SetKeyValue("spawnflags","1")
		glow1:SetParent(self)
		glow1:Fire("SetParentAttachment","glow" .. i,0)
		glow1:Spawn()
		glow1:Activate()
		self:DeleteOnRemove(glow1)
	end

	self:SetBlade(false)
	self:SetPhase(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetPhase(i)
	self.Phase = i
	self:SetNW2Int("Phase",i)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "step_left" then
		local pos,ang = self:GetBonePosition(self:LookupBone("bone032"))
		self:VJ_MGR_DealDamage(pos,{dmg=250,dmgtype=DMG_CRUSH,dmgpos=pos,vis=true},75)
		sound.Play(VJ_PICK(self.SoundTbl_FootStep),pos,100,100)
	elseif key == "step_right" then
		local pos,ang = self:GetBonePosition(self:LookupBone("bone043"))
		self:VJ_MGR_DealDamage(pos,{dmg=250,dmgtype=DMG_CRUSH,dmgpos=pos,vis=true},75)
		sound.Play(VJ_PICK(self.SoundTbl_FootStep),pos,100,100)
	elseif key == "roar_start" then
		-- VJ_CreateSound(self,"cpthazama/mgr/mgray/em0200_se_atk_laser_charge 876434145.ogg",100)
	elseif key == "roar_end" then
		self:StopParticles()
	elseif key == "charge_start" then
		VJ_CreateSound(self,"cpthazama/mgr/mgray/em0200_se_atk_laser_charge_l 121322773.ogg",100)
	elseif key == "charge_end" then
		self:StopParticles()
	elseif key == "laser_start" then
		self.LaserActive = true
		VJ_CreateSound(self,"cpthazama/mgr/mgray/em0200_se_atk_laser_fire_start 274990804.ogg",100)
		self.LaserLoop:Stop()
		self.LaserLoop:Play()
	elseif key == "laser_end" then
		self.LaserActive = false
		self.LaserLoop:Stop()
		self:StopParticles()
		VJ_CreateSound(self,"cpthazama/mgr/mgray/em0200_se_atk_laser_fire_end 583701465.ogg",100)
	elseif key == "melee blade" then
		local pos1,ang1 = self:GetBonePosition(self:LookupBone("bone530"))
		local pos2,ang2 = self:GetBonePosition(self:LookupBone("bone541"))
		local pos = (pos2 +pos1) /2
		local c = VJ_CreateTestObject(pos,nil,nil,nil,"models/hunter/misc/sphere025x025.mdl")
		c:SetModelScale(100)

		self:VJ_MGR_DealDamage(pos,{dmg=350,dmgtype=bit.bor(DMG_SLASH,DMG_BURN,DMG_CRUSH,DMG_DIRECT),dmgpos=pos,vis=true},400)
	elseif key == "blade_open" then
		VJ_CreateSound(self,"cpthazama/mgr/mgray/arm_open.ogg",100)
	elseif key == "blade_close" then
		VJ_CreateSound(self,"cpthazama/mgr/mgray/arm_close.ogg",100)
	elseif key == "blade_appear" then
		self:SetBlade(true)
	elseif key == "blade_disappear" then
		self:SetBlade(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSequence(set)
	local valCont = IsValid(self.VJ_TheController)

   switch(set,{
        [RAY_SET_LASER] = function()
			self.NextLaserAttackT = CurTime() +999
			self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
			self:VJ_ACT_PLAYACTIVITY("2026",true,false,false,0,{OnFinish=function(interrupted,anim)
				if interrupted then return end

				self:SetPhase(2)
				self:VJ_ACT_PLAYACTIVITY("2027",true,false,false,0,{OnFinish=function(interrupted,anim)
					if interrupted then return end
					self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
					self.RandomStopLaserT = CurTime() +math.Rand(3,6)
					self:VJ_ACT_PLAYACTIVITY("2028",true,false,false,0,{OnFinish=function(interrupted,anim)
						if interrupted then return end

						self:VJ_TASK_IDLE_STAND()
					end})
				end})
			end})
        end,
        [RAY_SET_LASER_DOUBLE] = function()
			self.RandomStopLaserT = CurTime() +999
			self.NextLaserAttackT = CurTime() +999
			self:VJ_ACT_PLAYACTIVITY("2020",true,false,false,0,{OnFinish=function(interrupted,anim)
				if interrupted then return end

				self:SetPhase(2)
				self:VJ_ACT_PLAYACTIVITY("2021",true,false,false,0,{OnFinish=function(interrupted,anim)
					if interrupted then return end
					self:VJ_ACT_PLAYACTIVITY("2022",true,false,false,0,{OnFinish=function(interrupted,anim)
						if interrupted then return end
						self:SetPhase(1)
						self.NextLaserAttackT = CurTime() +(valCont && 4 or math.Rand(40,60))
					end})
				end})
			end})
        end,
        [RAY_SET_LASER_END] = function()
			self.RandomStopLaserT = CurTime() +999
			self.NextLaserAttackT = CurTime() +(valCont && 4 or math.Rand(40,60))
			self:VJ_ACT_PLAYACTIVITY("202a",true,false,false,0,{OnFinish=function(interrupted,anim)
				if interrupted then return end

				self:SetState()
				self:SetPhase(1)
				self.AnimTbl_IdleStand = {ACT_IDLE}
			end})
        end,
        [RAY_SET_MELEE_DOUBLE_SWIPE] = function()
			self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
			self:VJ_ACT_PLAYACTIVITY("2400",true,false,false,0,{OnFinish=function(interrupted,anim)
				if interrupted then return end
				self:VJ_ACT_PLAYACTIVITY("2401",true,false,false,0,{OnFinish=function(interrupted,anim)
					if interrupted then return end
					self:VJ_ACT_PLAYACTIVITY("2402",true,false,false,0,{OnFinish=function(interrupted,anim)
						if interrupted then return end
						self:SetState()
					end})
				end})
			end})
        end,
        default = function()
            MsgC(Color(255, 0, 0), string.format("**Unknown Sequence Set ID: %d\n", set))
        end,
    })
end
---------------------------------------------------------------------------------------------------------------------------------------------
local math_rad = math.rad
local math_cos = math.cos
--
function ENT:CustomAttack(ene, eneVisible)
	local dist = self.NearestPointToEnemyDistance
	local inFront = (self.LastEnemySightDiff > math_cos(math_rad(40)))
	local notBusy = !self:IsBusy() && self:GetState() == VJ_STATE_NONE
	local cont = self.VJ_TheController
	local valCont = IsValid(cont)
	local key_atk = valCont && cont:KeyDown(IN_ATTACK)
	local key_atk2 = valCont && cont:KeyDown(IN_ATTACK2)
	local key_for = valCont && cont:KeyDown(IN_FORWARD)
	local key_bac = valCont && cont:KeyDown(IN_BACK)
	local key_lef = valCont && cont:KeyDown(IN_MOVELEFT)
	local key_rig = valCont && cont:KeyDown(IN_MOVERIGHT)
	local key_jum = valCont && cont:KeyDown(IN_JUMP)
	local key_shift = valCont && cont:KeyDown(IN_SPEED)
	local key_alt = valCont && cont:KeyDown(IN_WALK)
	local isMoving = (key_for || key_bac || key_lef || key_rig)

	if key_jum then
		local dTbl = {}
		if key_bac then table.insert(dTbl,1) end
		if key_rig then table.insert(dTbl,2) end
		if key_lef then table.insert(dTbl,3) end
		if key_for then table.insert(dTbl,4) end
		if #dTbl <= 0 then
			dTbl = 1
		end
		self:VJ_MGR_Dodge(dTbl)
	end

	if key_atk then
		if notBusy then
			self:DoSequence(RAY_SET_MELEE_DOUBLE_SWIPE)
		end
	end

	if key_atk2 then
		if self.NextLaserAttackT < CurTime() && notBusy then
			self:DoSequence(key_alt && RAY_SET_LASER_DOUBLE or RAY_SET_LASER)
		end
	end

	if key_shift then
		-- if self:GetNavType() != NAV_JUMP && CurTime() > self.Cont_NextJumpT && notBusy then
		-- 	self:ForceMoveJump((ene:GetPos() -self:GetPos()) +Vector(0,0,300))
		-- 	self.Cont_NextJumpT = CurTime() +5
		-- end
	end

	if valCont then return end

	if CurTime() > self.NextLaserAttackT && dist <= 4000 && dist > 600 && math.random(1,20) == 1 && notBusy && eneVisible && inFront then
		self:DoSequence(math.random(1,3) == 1 && RAY_SET_LASER or RAY_SET_LASER_DOUBLE)
	end

	if notBusy && dist <= 1000 && dist > 400 && eneVisible && inFront then
		self:DoSequence(RAY_SET_MELEE_DOUBLE_SWIPE)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.LastSequence = self:GetSequenceName(self:GetSequence())
	self.GoalDist = self:GetPathDistanceToGoal()
	self.GoalTime = self:GetPathTimeToGoal()
	local cont = self.VJ_TheController

	self:SetHP(self:Health())

	if self.LaserActive then
		local att = self:GetAttachment(2)
		local tr = util.TraceHull({
			start = att.Pos,
			endpos = att.Pos +att.Ang:Forward() *32000,
			filter = self,
			mins = Vector(-16,-16,-16),
			maxs = Vector(16,16,16),
		})
		local hitpos = tr.HitPos
		util.ParticleTracerEx("vj_mgr_ray_laser", att.Pos, hitpos, false, self:EntIndex(), 2)
		ParticleEffect("vj_mgr_ray_laser_impact", hitpos, Angle())
		sound.Play(VJ_PICK(self.SoundTbl_LaserImpact),hitpos,100,100)
		sound.EmitHint(SOUND_DANGER,hitpos,500,1,self)
		util.Decal("Scorch",hitpos +tr.HitNormal,hitpos -tr.HitNormal)
		util.VJ_SphereDamage(self,self,hitpos,350,45,bit.bor(DMG_BLAST,DMG_BURN,DMG_ENERGYBEAM),false,false,{DisableVisibilityCheck=false,Force=15})

		if IsValid(cont) && cont:KeyDown(IN_ATTACK2) && self:GetActivity() == ACT_IDLE_ANGRY then
			self.RandomStopLaserT = CurTime() +0.25 -- Allows continuous firing until they let go
		end

		if CurTime() > self.RandomStopLaserT then
			self:DoSequence(RAY_SET_LASER_END)
		end
	end

	-- self.CanFlinch = self:GetState() != VJ_STATE_NONE && 0 or 1

	self:VJ_MGR_UniqueMovement()

	self.LastActivity = self:GetActivity()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	-- if self:Health() <= self:GetMaxHealth() *0.5 && self.Phase == 1 then
	-- 	self:SetPhase(2)
	-- 	self:SetHealth(self:GetMaxHealth() *0.5)
	-- 	return
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.LaserLoop:Stop()
end