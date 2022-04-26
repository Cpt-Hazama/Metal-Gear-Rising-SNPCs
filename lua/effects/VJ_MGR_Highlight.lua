local glowMaterial = {
	[1] = "models/cpthazama/mgr/shade_attack",
	[2] = "models/cpthazama/mgr/shade_unblockable",
}
local glowColor = {
	[1] = Color(213,44,43,255),
	[2] = Color(248,236,168,255),
}

local baseMat = Material("sprites/glow04_noz")
local colWhite = Color(255,255,255)
local colWhite2 = Color(255,255,255,10)
function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	if !IsValid(self.Ent) then
		return
	end
	self.Pos = data:GetOrigin() or self.Ent:GetPos()
	self.Type = data:GetScale() or 1
	self.LifeTime = data:GetMagnitude() or 1
	self.Attachment = data:GetAttachment() or 99
	if !self.Ent:IsNPC() then
		self.Attachment = 99
	end
	self.DieTime = CurTime() +self.LifeTime

	if IsValid(self.Ent) then
		-- self.Model = ClientsideModel(self.Ent:GetModel(),RENDERMODE_TRANSALPHA)
		-- self.Model:SetMaterial(glowMaterial[self.Type] or "models/alyx/emptool_glow")
		-- self.Model:SetColor(glowColor[self.Type])
		-- self.Model:SetParent(self.Ent,0)
		-- self.Model:SetMoveType(MOVETYPE_NONE)
		-- self.Model:SetLocalPos(Vector(0,0,0))
		-- self.Model:SetLocalAngles(Angle(0,0,0))
		-- self.Model:AddEffects(EF_BONEMERGE)
	end
end

function EFFECT:Think()
	if not IsValid(self.Ent) then
		if IsValid(self.Model) then
			self.Model:Remove()
		end
	end
	if self.DieTime < CurTime() then
		if IsValid(self.Model) then
			self.Model:Remove()
		end
		return false
	end
	-- local oldCol = self.Model:GetColor()
	-- oldCol.a = math.Clamp((self.DieTime -CurTime()) /self.LifeTime,0,1) *255
	-- self.Model:SetColor(oldCol)
	if self.Attachment != 99 && IsValid(self.Ent) then
		local attach = self.Ent:GetAttachment(self.Attachment)
		if attach then
			self.Pos = attach.Pos +self.Ent:GetForward() *5
		end
	end
	return true
end

function EFFECT:Render()
	if self.Attachment != 99 then
		local scl = (self.DieTime -CurTime()) /self.LifeTime
		local scA = (600 *scl)
		local scB = (10 *scl)
		local col = glowColor[self.Type]
		col.a = 255 *scl

		render.SetMaterial(baseMat)
		render.DrawSprite(self.Pos,scA,scB,col)
		render.DrawSprite(self.Pos,scA,scB,col)

		render.DrawSprite(self.Pos,scB,scA,col)
		render.DrawSprite(self.Pos,scB,scA,col)
	end
end