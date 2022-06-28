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
	VJ.AddNPC("MG-Gekko (PMC)","npc_vj_mgr_mggekko",vCat)
	VJ.AddNPC("MG-Gekko (DPD)","npc_vj_mgr_mggekko_2",vCat)
	VJ.AddNPC("MG-Gekko (Desperado)","npc_vj_mgr_mggekko_3",vCat)
	VJ.AddNPC("Dwarf Gekko","npc_vj_mgr_gekko",vCat)
	VJ.AddNPC("MG-Raptor","npc_vj_mgr_raptor",vCat)
	VJ.AddNPC("Mastiff","npc_vj_mgr_mgmastiff",vCat)
	VJ.AddNPC("Metal Gear G.R.A.D.","npc_vj_mgr_grad",vCat)
	VJ.AddNPC("MG-Raven","npc_vj_mgr_raven",vCat)
	VJ.AddNPC("APC Transport","npc_vj_mgr_apc",vCat)
	VJ.AddNPC("Hammerhead Helicopter","npc_vj_mgr_hammerhead",vCat)
	VJ.AddNPC("Metal Gear EXCELSUS","npc_vj_mgr_mgexcelsus",vCat)

	VJ.AddParticle("particles/vj_mgr_ray.pcf", {})
	VJ.AddParticle("particles/vj_mgr_monsoon.pcf", {})
	VJ.AddParticle("particles/vj_mgr_armstrong.pcf", {})

	VJ.AddClientConVar("vj_mgr_mus_vol",70,"Music Volume")

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