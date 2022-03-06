ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if CLIENT then
    local jiggleAnims = {
        "attack9",
        "attack10",
        "attack14",
        "attack_range2",
        "attack_range2_hit"
    }
    -- local jiggleBones = {3,4,5,6,7,8,9,10,11,12,13,14,15}
    local jiggleBones = {5,7,9,11,13}

    function ENT:CustomOnDraw()
        local wep = self:GetNW2Entity("Weapon")
        if !IsValid(wep) then return end
        local anim = self:GetSequenceName(self:GetSequence())
        if VJ_HasValue(jiggleAnims,anim) then
            for _,bone in pairs(jiggleBones) do
                wep:ManipulateBoneJiggle(bone,1)
            end
        else
            for _,bone in pairs(jiggleBones) do
                wep:ManipulateBoneJiggle(bone,0)
            end
        end
    end

    function ENT:CreateTracks(ply)        
        self:CreateAudioStream(ply,"cpthazama/mgr/music/mistral_phase1.mp3",1)
        self:CreateAudioStream(ply,"cpthazama/mgr/music/mistral_phase2.mp3",2)
        ply.VJ_MGR_StartedTracks = true
    end

	function ENT:OnCreatedAudioStream(channel,ply,trkID)
        if trkID == 1 then
            ply.VJ_MGR_CurrentTrackChannelP1 = channel
        elseif trkID == 2 then
            ply.VJ_MGR_CurrentTrackChannelP2 = channel
        end
    end

	function ENT:CreateAudioStream(ply,snd,trkID)
		sound.PlayFile("sound/" .. snd,"noplay noblock",function(station,errCode,errStr)
			if IsValid(station) then
				station:EnableLooping(true)
				station:SetVolume(trkID == 2 && 0.1 or 0.7)
				station:SetPlaybackRate(1)
				self:OnCreatedAudioStream(station,ply,trkID)
                print("Successfully created audio stream for " .. snd)
			else
				print("Error playing sound!",errCode,errStr)
			end
			return station
		end)
	end

    function ENT:Initialize()
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

        local hookName = "VJ_MGR_Mistral_" .. self:EntIndex()
        VJ_MGR_HPBar(self)

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
            local startPoint = 20.65
            local endPoint = 128.15
            ply.VJ_MGR_CurrentTrack = phase
            local track1 = ply.VJ_MGR_CurrentTrackChannelP1
            local track2 = ply.VJ_MGR_CurrentTrackChannelP2
            if !ply.VJ_MGR_StartedTracks then
                self:CreateTracks(ply)
                return
            end
            if track1 == nil or track2 == nil then return end
            local time1 = track1:GetTime()
            local time2 = track2:GetTime()
            if time1 >= endPoint then
                track1:SetTime(startPoint)
            end
            if time2 >= endPoint then
                track2:SetTime(startPoint)
            end
            if phase == 2 then
                local vol1 = track1:GetVolume()
                local vol2 = track2:GetVolume()
                ply.VJ_MGR_CurrentTrackChannelP1:SetVolume(Lerp(FrameTime() *2,vol1,0))
                ply.VJ_MGR_CurrentTrackChannelP2:SetVolume(Lerp(FrameTime() *2,vol2,0.7))
            end
            if ply.VJ_MGR_CurrentPlayingTrack != phase then
                ply.VJ_MGR_CurrentPlayingTrack = phase
                if phase == 1 then
                    ply.VJ_MGR_CurrentTrackChannelP1:Play()
                    -- ply.VJ_MGR_CurrentTrackChannelP2:Pause()
                elseif phase == 2 then
                    -- ply.VJ_MGR_CurrentTrackChannelP1:Pause()
                    ply.VJ_MGR_CurrentTrackChannelP2:Play()
                    ply.VJ_MGR_CurrentTrackChannelP2:SetTime(40)
                end
            end
        end)
    end
end