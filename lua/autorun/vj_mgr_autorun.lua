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

	if CLIENT then
		surface.CreateFont("MGR_Font", {
			font = "Techno Hideo",
			size = 18,
		})
		surface.CreateFont("MGR_Font2", {
			font = "Techno Hideo",
			size = 50,
		})

		local mat = Material("hud/cpthazama/mgr/bar.png","smooth unlitgeneric")
		local mat_hp = Material("hud/cpthazama/mgr/bar_lines.png","smooth unlitgeneric")
		local mat_up = Material("hud/cpthazama/mgr/corner_top.png","smooth unlitgeneric")
		local mat_down = Material("hud/cpthazama/mgr/corner_bottom.png","smooth unlitgeneric")
		function VJ_MGR_HPBar(self)
			if !IsValid(self) then return end
			local hookName = "VJ_MGR_HPBar_" .. self:EntIndex()
			local name = list.Get("NPC")[self:GetClass()].Name
			hook.Add("HUDPaint",hookName,function()
				local ply = LocalPlayer()
				if !IsValid(self) then
					hook.Remove("HUDPaint",hookName)
					return
				end

				local hp = self:GetNW2Int("HP")
				local hpmax = self:GetMaxHealth()
				local scrX = (ScrW() *0.78)
				local scrY = (ScrH() *0.65)
				local posX = (mat:Width() *0.67)
				local posY = (mat:Height() *22)
				local sizeX = mat:Width() *2
				local sizeY = mat:Height() *1.55
				local per = (hp /hpmax) *100
				local capSize = 20

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
				surface.SetMaterial(mat_hp)
				surface.DrawTexturedRect(
					scrX -posX,
					scrY +posY,
					sizeX,
					sizeY
				)

				surface.SetDrawColor(240,240,105)
				surface.SetMaterial(mat_hp)
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

        -- local mat = Material("hud/cpthazama/mgr/bar.png","smooth unlitgeneric")
        -- local mat_hp = Material("hud/cpthazama/mgr/bar_lines.png","smooth unlitgeneric")
        -- local mat_up = Material("hud/cpthazama/mgr/corner_top.png","smooth unlitgeneric")
        -- local mat_down = Material("hud/cpthazama/mgr/corner_bottom.png","smooth unlitgeneric")
        -- hook.Add("HUDPaint","TYEST",function()
			-- local ply = LocalPlayer()
			
			-- local hp = 2500
			-- local hpmax = 2500
			-- local scrX = (ScrW() *0.78)
			-- local scrY = (ScrH() *0.65)
			-- local posX = (mat:Width() *0.67)
			-- local posY = (mat:Height() *22)
			-- local sizeX = mat:Width() *2
			-- local sizeY = mat:Height() *1.55
			-- local per = (hp /hpmax) *100
			-- local capSize = 20

			-- surface.SetDrawColor(204,162,104)
			-- surface.SetMaterial(mat_up)
			-- surface.DrawTexturedRect(
			--     scrX -posX *-2,
			--     scrY +posY *0.7,
			--     capSize *2,
			--     capSize
			-- )


			-- surface.SetDrawColor(204,162,104)
			-- surface.SetMaterial(mat_down)
			-- surface.DrawTexturedRect(
			--     scrX -posX *-2,
			--     scrY +posY *1.15,
			--     capSize *2,
			--     capSize
			-- )

			-- surface.SetDrawColor(255,255,255)
			-- surface.SetMaterial(mat)
			-- surface.DrawTexturedRect(
			--     scrX -posX,
			--     scrY +posY *0.955,
			--     sizeX,
			--     sizeY *0.5
			-- )

			-- surface.SetDrawColor(220,105,15)
			-- surface.SetMaterial(mat_hp)
			-- surface.DrawTexturedRect(
			--     scrX -posX,
			--     scrY +posY,
			--     sizeX,
			--     sizeY
			-- )

			-- surface.SetDrawColor(240,240,105)
			-- surface.SetMaterial(mat_hp)
			-- surface.DrawTexturedRect(
			--     scrX -posX,
			--     scrY +(posY +2),
			--     sizeX *(hp /hpmax),
			--     sizeY *0.88
			-- )

			-- draw.DrawText(
			--     "Mistral",
			--     "MGR_Font",
			--     scrX -(mat:Width() *0.65),
			--     scrY +(mat:Height() *19.3),
			--     Color(183,195,189,255),
			--     TEXT_ALIGN_LEFT
			-- )

			-- draw.DrawText(
			--     per .. "%",
			--     "MGR_Font2",
			--     scrX -(mat:Width() *-(0.94 -(string.len(per .. "%") *0.05))),
			--     scrY +(mat:Height() *18),
			--     Color(204,162,104,255),
			--     TEXT_ALIGN_LEFT
			-- )
		-- end)
	end

	local vCat = Name
	VJ.AddCategoryInfo(vCat,{Icon = "vj_icons/mgr.png"})

	VJ.AddNPC("Bladewolf","npc_vj_mgr_bladewolf",vCat)
	VJ.AddNPC("Mistral","npc_vj_mgr_mistral",vCat)
	VJ.AddNPC("Mistral (Coat)","npc_vj_mgr_mistral_2",vCat)
	VJ.AddNPC("Monsoon","npc_vj_mgr_monsoon",vCat)
	VJ.AddNPC("Sundowner","npc_vj_mgr_sundowner",vCat)
	VJ.AddNPC("Sundowner (Coat)","npc_vj_mgr_sundowner_2",vCat)
	VJ.AddNPC("Jetstream Sam","npc_vj_mgr_sam",vCat)
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