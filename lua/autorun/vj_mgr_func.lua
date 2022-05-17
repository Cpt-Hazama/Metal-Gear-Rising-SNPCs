local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	function switch(val, tab)
		if tab[val] then
			return tab[val]()
		else
			return tab.default() or MsgN("[ERROR] Could not switch, invalid parameters!")
		end
	end

	if SERVER then
		local NPC = FindMetaTable("NPC")
		local debug = false
		local doEntPos = false

		function NPC:VJ_MGR_Dodge(forceSide)
			if self:IsBusy() then return end
			local myPos = self:GetPos()
			local myPosCentered = self:GetPos() +self:OBBCenter()
			local positions = {}
			local anims = self.AnimTbl_Dodge
			for i = 1,#anims do
				positions[i] = i == 1 && -self:GetForward() or i == 2 && self:GetRight() or i == 3 && -self:GetRight() or i == 4 && self:GetForward()
			end
			local isGood = {}
			for i = 1,#positions do
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
			self:VJ_ACT_PLAYACTIVITY(anims[side],true,false,true)

			local snd = VJ_PICK(self.SoundTbl_Dodge)
			local dur = snd != false && SoundDuration(snd) or 0

			self.Attacking = false
			self:StopAllCommonSpeechSounds()
			self.NextAlertSoundT = CurTime() +dur +math.Rand(1,2)
			self.NextInvestigateSoundT = CurTime() +dur +math.Rand(3,4)
			self.NextIdleSoundT_RegularChange = CurTime()  +dur +math.Rand(3,4)
			if snd then
				VJ_CreateSound(self,snd,78)
			end
		end

		function NPC:StartDamageCalc(dmg)
			local wep = self:GetNW2Entity("Weapon")
			if !IsValid(wep) then return end
			self.TraceCalcData = {}
			self.EntitiesToDamage = {}
			self.PreviousCurTime = 0
			
			local hookName = "VJ_MGR_TraceAttackData_" .. self:EntIndex()
			hook.Add("Tick",hookName,function()
				if !IsValid(self) or !IsValid(wep) then
					hook.Remove("Tick",hookName)
					return
				end
				for v = 1,wep:GetBoneCount() -1 do
					local targetPos = self.TraceCalcData[v] && self.TraceCalcData[v][self.PreviousCurTime] && self.TraceCalcData[v][self.PreviousCurTime].LastPos or wep:GetBonePosition(v)
					targetPos.z = doEntPos && self:WorldSpaceCenter().z or targetPos.z
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
						if self.DoCalcDamage then
							self:DoCalcDamage(ent,tr)
						end
					end
				end
			end)
		end

		function NPC:EndDamageCalc()
			self.TraceCalcData = nil
			self.LastCalcData = nil
			self.PreviousCurTime = nil
			hook.Remove("Tick","VJ_MGR_TraceAttackData_" .. self:EntIndex())
		end

		function VJ_MGR_GetAttackNames(ent)
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

		function NPC:VJ_MGR_PlayGesture(seq,rate,movement)
			local rate = rate or 1
			local gesture = self:AddGestureSequence(self:LookupSequence(seq))
			self:SetLayerPriority(gesture, 1)
			self:SetLayerPlaybackRate(gesture, rate *0.5)
			timer.Simple(VJ_GetSequenceDuration(self,seq) *rate,function()
				if IsValid(self) && self:GetActivity() == movement then
					self:SetCycle(0)
				end
			end)
		end

		function NPC:VJ_MGR_UniqueMovement()
			local moveData = self.AnimTbl_Movements
			if !moveData then return end

			self.LastSequence = self:GetSequenceName(self:GetSequence())
			self.GoalDist = self:GetPathDistanceToGoal()
			self.GoalTime = self:GetPathTimeToGoal()

			local cont = self.VJ_TheController
			local key_for = IsValid(cont) && cont:KeyDown(IN_FORWARD)
			local key_bac = IsValid(cont) && cont:KeyDown(IN_BACK)
			local key_lef = IsValid(cont) && cont:KeyDown(IN_MOVELEFT)
			local key_rig = IsValid(cont) && cont:KeyDown(IN_MOVERIGHT)
			local isMoving = (key_for || key_bac || key_lef || key_rig)

			for _,dat in pairs(moveData) do
				if !self:IsBusy() && VJ_HasValue(dat.Loop,self.LastActivity) && (!IsValid(cont) && self.GoalTime <= dat.GoalMax && self.GoalTime > dat.GoalMin or IsValid(cont) && !isMoving) && self.LastSequence != dat.End then
					self:VJ_ACT_PLAYACTIVITY(dat.End,true,false,false)
				elseif VJ_HasValue(dat.ReqIdle,self.LastActivity) && VJ_HasValue(dat.Loop,self:GetActivity()) then
					self:VJ_MGR_PlayGesture(dat.Start,nil,dat.Loop[1])
					-- self:VJ_ACT_PLAYACTIVITY("vjges_" .. dat.Start,true,false,false,0,{OnFinish=function(interrupted,anim)
					-- 	if interrupted then
					-- 		return
					-- 	end
						-- if self:GetActivity() == dat.Loop then -- Fix stuttering
						-- 	self:SetCycle(self:GetCycle() *0.275)
						-- end
					-- end})
					self:ResetIdealActivity(VJ_SequenceToActivity(self,dat.Start))
				end
			end

			self.LastIdealActivity = self:GetIdealActivity()
			self.LastActivity = self:GetActivity()
		end

		function NPC:VJ_MGR_DealDamage(ent,dmgtbl,radius)
			local tbEnts = {}
			if radius then
				for _,v in ipairs(ents.FindInSphere(ent,radius)) do
					if v != self && self:DoRelationshipCheck(v) then
						if dmgtbl.vis && !v:Visible(self) then continue end
						table.insert(tbEnts,v)
						local dmginfo = DamageInfo()
						dmginfo:SetDamage(dmgtbl.dmg or 1)
						dmginfo:SetDamageType(dmgtbl.dmgtype or DMG_SLASH)
						dmginfo:SetDamagePosition(dmgtbl.dmgpos or v:GetPos() +v:OBBCenter())
						dmginfo:SetAttacker(dmgtbl.attacker or self)
						dmginfo:SetInflictor(dmgtbl.inflictor or self)
						v:TakeDamageInfo(dmginfo,dmgtbl.attacker or self,dmgtbl.inflictor or self)
					end
				end
				return tbEnts
			end

			local dmginfo = DamageInfo()
			dmginfo:SetDamage(dmgtbl.dmg or 1)
			dmginfo:SetDamageType(dmgtbl.dmgtype or DMG_SLASH)
			dmginfo:SetDamagePosition(dmgtbl.dmgpos or ent:GetPos() +ent:OBBCenter())
			dmginfo:SetAttacker(dmgtbl.attacker or self)
			dmginfo:SetInflictor(dmgtbl.inflictor or self)
			ent:TakeDamageInfo(dmginfo,dmgtbl.attacker or self,dmgtbl.inflictor or self)
			return ent
		end
	end

	if CLIENT then
		surface.CreateFont("MGR_Font", {
			font = "Techno Hideo",
			size = 18,
		})
		surface.CreateFont("MGR_Font2", {
			font = "Techno Hideo",
			size = 50,
		})
		surface.CreateFont("MGR_Font3", {
			font = "Techno Hideo",
			size = 25,
		})
		surface.CreateFont("MGR_Font4", {
			font = "Techno Hideo",
			size = 35,
		})

		function VJ_MGR_AddBossTrack(self,trkName,startPoint,endPoint)
			local ply = LocalPlayer()
			ply.VJ_MGR_CurrentPlayingTrack = 0
			if ply.VJ_MGR_CurrentTrackChannelP1 then
				ply.VJ_MGR_CurrentTrackChannelP1:Stop()
				ply.VJ_MGR_CurrentTrackChannelP1 = nil
			end
			if ply.VJ_MGR_CurrentTrackChannelP2 then
				ply.VJ_MGR_CurrentTrackChannelP2:Stop()
				ply.VJ_MGR_CurrentTrackChannelP2 = nil
			end

        	local hookName = "VJ_MGR_SoundTrack_" .. self:EntIndex()
			hook.Add("Think",hookName,function()
				local ply = LocalPlayer()
				if !IsValid(self) then
					ply.VJ_MGR_StartedTracks = false
					if ply.VJ_MGR_CurrentTrackChannelP1 then
						ply.VJ_MGR_CurrentTrackChannelP1:Stop()
						ply.VJ_MGR_CurrentTrackChannelP1 = nil
					end
					if ply.VJ_MGR_CurrentTrackChannelP2 then
						ply.VJ_MGR_CurrentTrackChannelP2:Stop()
						ply.VJ_MGR_CurrentTrackChannelP2 = nil
					end
					hook.Remove("Think",hookName)
					return
				end

				local phase = self:GetNW2Int("Phase")
				local volMix = GetConVar("vj_mgr_mus_vol"):GetInt() *0.01
				local targetVol1 = 0.7
				local targetVol2 = 0.1
				ply.VJ_MGR_CurrentTrack = phase
				local track1 = ply.VJ_MGR_CurrentTrackChannelP1
				local track2 = ply.VJ_MGR_CurrentTrackChannelP2
				if !ply.VJ_MGR_StartedTracks then
					VJ_MGR_CreateTracks(ply,trkName,self,startPoint,endPoint)
					return
				end
				if track1 == nil or track2 == nil then return end
				local vol1 = track1:GetVolume()
				local vol2 = track2:GetVolume()
				local time1 = track1:GetTime()
				local time2 = track2:GetTime()
				local stPoint = self:GetStartPoint() != 0 && self:GetStartPoint() or self.MGR_Music_StartPoint
				local enPoint = self:GetEndPoint() != 0 && self:GetEndPoint() or self.MGR_Music_EndPoint

				if self.OverrideMusicTracks then
					self:OverrideMusicTracks(track1,track2,vol1,vol2,time1,time2,volMix,targetVol1,targetVol2)
					return
				end

				if time1 >= enPoint then
					track1:SetTime(stPoint)
				end
				if time2 >= enPoint then
					track2:SetTime(stPoint)
				end
				if phase == 2 then
					targetVol1 = 0
					targetVol2 = 0.7
					ply.VJ_MGR_CurrentTrackChannelP1:SetVolume(Lerp(FrameTime() *3,vol1,targetVol1 *volMix))
					ply.VJ_MGR_CurrentTrackChannelP2:SetVolume(Lerp(FrameTime() *8,vol2,targetVol2 *volMix))
				else
					ply.VJ_MGR_CurrentTrackChannelP1:SetVolume(Lerp(FrameTime() *8,vol1,targetVol1 *volMix))
					ply.VJ_MGR_CurrentTrackChannelP2:SetVolume(Lerp(FrameTime() *3,vol2,targetVol2 *volMix))
				end
				if ply.VJ_MGR_CurrentPlayingTrack != phase then
					ply.VJ_MGR_CurrentPlayingTrack = phase
					if phase == 1 then
						ply.VJ_MGR_CurrentTrackChannelP1:Play()
						ply.VJ_MGR_CurrentTrackChannelP1:SetTime(time2)
					elseif phase == 2 then
						ply.VJ_MGR_CurrentTrackChannelP2:Play()
						ply.VJ_MGR_CurrentTrackChannelP2:SetTime(time1)
					end
					if self.OnPhaseChanged then
						self:OnPhaseChanged(phase,track1,track2,ply)
					end
				end
			end)
		end

		function VJ_MGR_CreateTracks(ply,trkName,self,startPoint,endPoint)        
			VJ_MGR_CreateAudioStream(ply,"cpthazama/mgr/music/" .. trkName .. "_phase1.mp3",1)
			VJ_MGR_CreateAudioStream(ply,"cpthazama/mgr/music/" .. trkName .. "_phase2.mp3",2)
			ply.VJ_MGR_StartedTracks = true

			if startPoint == false then
				startPoint = 0
			end
			if endPoint == false then
				endPoint = ply.VJ_MGR_LastTrackLength
			end
			if isnumber(startPoint) then
				self.MGR_Music_StartPoint = startPoint
				self:SetStartPoint(startPoint)
			end
			if isnumber(endPoint) then
				self.MGR_Music_EndPoint = endPoint
				self:SetEndPoint(endPoint)
			end
		end

		function VJ_MGR_OnCreatedAudioStream(channel,ply,trkID)
			if trkID == 1 then
				ply.VJ_MGR_CurrentTrackChannelP1 = channel
				ply.VJ_MGR_LastTrackLength = channel:GetLength()
			elseif trkID == 2 then
				ply.VJ_MGR_CurrentTrackChannelP2 = channel
			end
		end

		function VJ_MGR_CreateAudioStream(ply,snd,trkID)
			local volMix = GetConVar("vj_mgr_mus_vol"):GetInt() *0.01
			sound.PlayFile("sound/" .. snd,"noplay noblock",function(station,errCode,errStr)
				if IsValid(station) then
					station:EnableLooping(true)
					station:SetVolume(trkID == 2 && 0.1 *volMix or 0.7 *volMix)
					station:SetPlaybackRate(1)
					VJ_MGR_OnCreatedAudioStream(station,ply,trkID)
					-- print("Successfully created audio stream for " .. snd)
				else
					print("Error playing sound!",errCode,errStr)
				end
				return station
			end)
		end

		local mat = Material("hud/cpthazama/mgr/bar.png","smooth unlitgeneric")
		local mat_hp = Material("hud/cpthazama/mgr/bar_lines.png","smooth unlitgeneric")
		local mat_up = Material("hud/cpthazama/mgr/corner_top.png","smooth unlitgeneric")
		local mat_down = Material("hud/cpthazama/mgr/corner_bottom.png","smooth unlitgeneric")
		function VJ_MGR_HPBar(self)
			if !IsValid(self) then return end
			local isPlyCharacter = self.MGR_IsPlayerCharacter
			local isBossCharacter = self.MGR_DrawBossHUD
			local name = list.Get("NPC")[self:GetClass()].Name
			hook.Add("HUDPaint",self,function()
				local ply = LocalPlayer()
				local hp = self.GetHP && self:GetHP() or self:Health()
				local hpmax = self:GetMaxHealth()
				local scrX = (ScrW() *0.78)
				local scrY = (ScrH() *0.65)
				local posX = (mat:Width() *0.67)
				local posY = (mat:Height() *22)
				local sizeX = mat:Width() *2
				local sizeY = mat:Height() *1.55
				local per = math.Round((hp /hpmax) *100,2)
				local capSize = 20
				local disableBossHUD = false

				if ply.IsControlingNPC && ply.VJCE_NPC == self then
					scrX = (ScrW() *0.1)
					scrY = (ScrH() *0.065)
					posX = (mat:Width() *0.67)
					posY = (mat:Height())

					draw.RoundedBox(0,(ScrW() *0.01),(ScrH() *0.025),(ScrW() *0.265),(ScrH() *(self.GetElectrolytes && 0.085 or 0.065)),Color(5,5,5,175))

					surface.SetDrawColor(255,126,27)
					surface.SetMaterial(mat_hp)
					surface.DrawTexturedRect(
						scrX -posX,
						scrY,
						sizeX,
						sizeY
					)

					surface.SetDrawColor(240,240,105,80)
					surface.SetMaterial(mat_hp)
					surface.DrawTexturedRect(
						scrX -posX,
						scrY +2,
						sizeX *(hp /hpmax),
						sizeY *0.88
					)

					draw.DrawText(
						name,
						"MGR_Font3",
						scrX -(mat:Width() *0.65),
						scrY +(mat:Height() *-1.65),
						Color(183,195,189,255),
						TEXT_ALIGN_LEFT
					)

					draw.DrawText(
						per .. "%",
						"MGR_Font2",
						scrX -(mat:Width() *-(0.95 -(string.len(per .. "%") *0.05))),
						scrY +(mat:Height() *-2.85),
						Color(200,135,45,255),
						TEXT_ALIGN_LEFT
					)

					if self.GetElectrolytes then
						local electro = self:GetElectrolytes()
						local electroMax = self:GetMaxElectrolytes()
						scrX = (ScrW() *0.1)
						scrY = (ScrH() *0.085)
						posX = (mat:Width() *0.67)
						posY = (mat:Height())

						surface.SetDrawColor(101,154,155)
						surface.SetMaterial(mat_hp)
						surface.DrawTexturedRect(
							scrX -posX,
							scrY,
							sizeX,
							sizeY
						)

						surface.SetDrawColor(0,255,234)
						surface.SetMaterial(mat_hp)
						surface.DrawTexturedRect(
							scrX -posX,
							scrY +2,
							sizeX *(electro /electroMax),
							sizeY *0.88
						)
					end

					disableBossHUD = true
				end

				if !isBossCharacter or disableBossHUD then return end

				draw.RoundedBox(0,(ScrW() *0.69),(ScrH() *0.823),(ScrW() *0.267),(ScrH() *0.12),Color(5,5,5,175))

				surface.SetDrawColor(204,162,104)
				surface.SetMaterial(mat_up)
				surface.DrawTexturedRect(
					scrX -posX *-2,
					scrY +posY *0.7,
					capSize *2,
					capSize
				)


				surface.SetDrawColor(204,162,104)
				surface.SetMaterial(mat_down)
				surface.DrawTexturedRect(
					scrX -posX *-2,
					scrY +posY *1.15,
					capSize *2,
					capSize
				)

				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(
					scrX -posX,
					scrY +posY *0.955,
					sizeX,
					sizeY *0.5
				)

				surface.SetDrawColor(220,105,15)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(
					scrX -(posX +3),
					scrY +(posY -3),
					sizeX *1.01,
					sizeY *1.25
				)

				surface.SetDrawColor(240,240,105)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(
					scrX -posX,
					scrY +(posY +2),
					sizeX *(hp /hpmax),
					sizeY *0.88
				)

				draw.DrawText(
					name,
					"MGR_Font",
					scrX -(mat:Width() *0.65),
					scrY +(mat:Height() *19.65),
					Color(183,195,189,255),
					TEXT_ALIGN_LEFT
				)

				draw.DrawText(
					per .. "%",
					"MGR_Font2",
					scrX -(mat:Width() *-(0.94 -(string.len(per .. "%") *0.05))),
					scrY +(mat:Height() *18),
					Color(204,162,104,255),
					TEXT_ALIGN_LEFT
				)
			end)
		end
	end
end