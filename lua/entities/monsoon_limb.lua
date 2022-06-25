AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "Monsoon's Limb"
ENT.Author			= "Cpt. Hazama"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAutomaticFrameAdvance(val)
	self.AutomaticFrameAdvance = val
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Initialize()
	
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Draw()
		self:DrawModel()
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:DrawTranslucent()
		self:Draw()
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:BuildBonePositions(NumBones,NumPhysBones)

	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:SetRagdollBones(bIn)
		self.m_bRagdollSetup = bIn
	end
	return
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSpawnEffect(false)
    self:SetSolid(SOLID_NONE)
    self:AddFlags(FL_NOTARGET)
    self:AddEFlags(bit.bor(EFL_NO_DISSOLVE,EFL_DONTBLOCKLOS))
	self:SetRenderMode(RENDERMODE_NORMAL)
    self:SetCustomCollisionCheck(true)

	if self.OnInit then
		self:OnInit()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime() +(0.069696968793869 +FrameTime()))
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle,onFinish)
	self:ResetSequence(seq)
	self:SetPlaybackRate(rate or 1)
	self:SetCycle(cycle or 0)

	local animTime = self:GetSequenceDuration(self,seq)
	if onFinish then
		timer.Simple(animTime *(rate or 1), function()
			if IsValid(self) then
				onFinish(self:GetAnimation() != seq, seq)
			end
		end)
	end

	return animTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSequenceDuration(argent,actname)
	if isnumber(actname) then
		return argent:SequenceDuration(argent:SelectWeightedSequence(actname))
	elseif isstring(actname) then
		return argent:SequenceDuration(argent:LookupSequence(actname))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAnimation()
	return self:GetSequenceName(self:GetSequence())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	
end