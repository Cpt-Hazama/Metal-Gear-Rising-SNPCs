/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local Name = "Metal Gear Rising"
local PublicAddonName = Name .. " SNPCs"
local AddonName = Name
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_mgr_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	if SERVER then
		local NPC = FindMetaTable("NPC")

		function NPC:VJ_MGR_PlayGesture(seq,rate)
			local rate = rate or 1
			local gesture = self:AddGestureSequence(self:LookupSequence(seq))
			self:SetLayerPriority(gesture, 1)
			self:SetLayerPlaybackRate(gesture, rate *0.5)
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
					self:VJ_MGR_PlayGesture(dat.Start)
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
					VJ_MGR_CreateTracks(ply,trkName)
					return
				end
				if track1 == nil or track2 == nil then return end
				local vol1 = track1:GetVolume()
				local vol2 = track2:GetVolume()
				local time1 = track1:GetTime()
				local time2 = track2:GetTime()
				if startPoint != false && endPoint != false then
					if time1 >= endPoint then
						track1:SetTime(startPoint)
					end
					if time2 >= endPoint then
						track2:SetTime(startPoint)
					end
				end
				if phase == 2 then
					targetVol1 = 0
					targetVol2 = 0.7
					ply.VJ_MGR_CurrentTrackChannelP1:SetVolume(Lerp(FrameTime() *2,vol1,targetVol1 *volMix))
					ply.VJ_MGR_CurrentTrackChannelP2:SetVolume(Lerp(FrameTime() *2,vol2,targetVol2 *volMix))
				else
					ply.VJ_MGR_CurrentTrackChannelP1:SetVolume(Lerp(FrameTime() *2,vol1,targetVol1 *volMix))
					ply.VJ_MGR_CurrentTrackChannelP2:SetVolume(Lerp(FrameTime() *2,vol2,targetVol2 *volMix))
				end
				if ply.VJ_MGR_CurrentPlayingTrack != phase then
					ply.VJ_MGR_CurrentPlayingTrack = phase
					if phase == 1 then
						ply.VJ_MGR_CurrentTrackChannelP1:Play()
					elseif phase == 2 then
						ply.VJ_MGR_CurrentTrackChannelP2:Play()
						-- ply.VJ_MGR_CurrentTrackChannelP2:SetTime(40)
					end
					if self.OnPhaseChanged then
						self:OnPhaseChanged(phase,track1,track2,ply)
					end
				end
			end)
		end

		function VJ_MGR_CreateTracks(ply,trkName)        
			VJ_MGR_CreateAudioStream(ply,"cpthazama/mgr/music/" .. trkName .. "_phase1.mp3",1)
			VJ_MGR_CreateAudioStream(ply,"cpthazama/mgr/music/" .. trkName .. "_phase2.mp3",2)
			ply.VJ_MGR_StartedTracks = true
		end

		function VJ_MGR_OnCreatedAudioStream(channel,ply,trkID)
			if trkID == 1 then
				ply.VJ_MGR_CurrentTrackChannelP1 = channel
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

	VJ.AddClientConVar("vj_mgr_mus_vol",70,"Music Volume")

	local vCat = Name
	VJ.AddCategoryInfo(vCat,{Icon = "vj_icons/mgr.png"})

	VJ.AddNPC("Raiden","npc_vj_mgr_raiden",vCat)

	VJ.AddNPC("Bladewolf","npc_vj_mgr_bladewolf",vCat)
	VJ.AddNPC("Mistral","npc_vj_mgr_mistral",vCat)
	VJ.AddNPC("Mistral (Coat)","npc_vj_mgr_mistral_2",vCat)
	VJ.AddNPC("Monsoon","npc_vj_mgr_monsoon",vCat)
	VJ.AddNPC("Sundowner","npc_vj_mgr_sundowner",vCat)
	VJ.AddNPC("Sundowner (Coat)","npc_vj_mgr_sundowner_2",vCat)
	VJ.AddNPC("Jetstream Sam","npc_vj_mgr_sam",vCat)
	VJ.AddNPC("Jetstream Sam (Mercenary)","npc_vj_mgr_sam_2",vCat)
	VJ.AddNPC("Wolf","npc_vj_mgr_bladewolf_2",vCat)
	VJ.AddNPC("Senator Armstrong","npc_vj_mgr_armstrong",vCat) -- 3 Phases (Shirt, Shirtless, Finale Shirtless)

	VJ.AddNPC("Metal Gear RAY","npc_vj_mgr_mgray",vCat)
	VJ.AddNPC("Metal Gear Gekko","npc_vj_mgr_mggekko",vCat)
	VJ.AddNPC("Dwarf Gekko","npc_vj_mgr_gekko",vCat)
	VJ.AddNPC("Metal Gear Raptor","npc_vj_mgr_raptor",vCat)
	VJ.AddNPC("Metal Gear Mastiff","npc_vj_mgr_mgmastiff",vCat)
	VJ.AddNPC("G.R.A.D.","npc_vj_mgr_grad",vCat)
	VJ.AddNPC("Raven","npc_vj_mgr_raven",vCat)
	VJ.AddNPC("APC Transport","npc_vj_mgr_apc",vCat)
	VJ.AddNPC("Hammerhead Helicopter","npc_vj_mgr_hammerhead",vCat)
	VJ.AddNPC("Metal Gear EXCELSUS","npc_vj_mgr_mgexcelsus",vCat)

	VJ.AddParticle("particles/vj_mgr_ray.pcf", {})

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((scrY()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end