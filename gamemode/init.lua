AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_ambience.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_vgui.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "util.lua" )

include( "player.lua" )
include( "shared.lua" )
include( "data.lua")
include( "util.lua")
include( "sv_general.lua" )
include( "sv_techie.lua" )
include( "sv_squads.lua" )
include( "sv_round.lua" )

ta.AddFilesRecursive("../sound/ta","")
ta.AddFilesRecursive("../materials/ta","")
resource.AddFile("models/weapons/w_binoculars.mdl")
resource.AddFile("models/weapons/v_binoculars.mdl")
resource.AddFile("resource/fonts/Army.ttf")

SetGlobalString("ta_ambience","battle")
SetGlobalString("ta_mode","capture") -- other options: bomb

// Load a player's points
function GM:PlayerDisconnected(pl)
	if CurTime() - pl:GetNWInt("StartTime") > 300 then DB.AddPlay(pl) end
	DB.Save()
end

// Set start time for later reference by disconnect and play points
function GM:PlayerAuthed(pl)
	pl:SetNWInt("StartTime",CurTime())
end

hook.Add("PlayerDeath","SavePoints",function(vic,inf,killer)
	
	// Add the points
	if !killer:IsPlayer() then return end

	local pts = (DB.GetPoints(vic) + vic:Frags())/1000
	
	if pts >= 1 then killer:AddFrags(math.floor(pts)) end
	
	DB.SetPoints(killer,killer:Frags())
	
	// Calculate killstreaks
	vic:SetNWInt("Killstreak",0)
	local kills = killer:GetNWInt("Killstreak") + 1
	killer:SetNWInt("Killstreak",kills)
	umsg.Start("ta-killstreak")
		umsg.Entity(killer)
		umsg.Short(kills)
	umsg.End()
	
end)

hook.Add("ShouldCollide","NoCollideTeams",function(e1,e2)
	if e1:IsPlayer() and e2:IsPlayer() and e1:Team() == e2:Team() then return false end
end)

hook.Add("EntityTakeDamage","DyingSounds",function(pl,inf,attacker,amt,dmg)
	if !pl:IsPlayer() then return end
	
	timer.Simple(0.2,function()
		if pl:Health() < 20 and pl:Health() > 0 and pl:Alive() then
			pl:SetDSP(15,false)
			umsg.Start("ta-death",pl) umsg.Bool(false) umsg.End()
		end
	end)
end)

// GIve people play points and talk about maps
hook.Add("EndOfGame","AddPlays",function() 
	for _,v in ipairs(player.GetAll()) do 
		DB.AddPlay(v) 
	end 
	DB.Save() 
	
end)


/*function GM:PlayerJoinClass(pl,class)
	if class == "Runner" then
		pl:SetNWBool("Runner",true)
	else
		pl:SetNWBool("Runner",false)
	end
end*/

function SendObjectives(pl,cmd,args)
	if pl:GetSquad().leader != pl then return end
	local rp = RecipientFilter()
	for _,v in ipairs(pl:GetSquad()) do rp:AddPlayer(v) end
	umsg.Start("ta_objective",rp)
		umsg.String("Assault "..args[1].." Objective "..math.floor(args[2]))
	umsg.End()
end
concommand.Add("ta_target",SendObjectives)

concommand.Add("ta_aurora",function(pl)
	if pl:GetNWInt("Killstreak") >= 25 and !pl:GetNWBool("HasCannon") then
		pl:SetNWBool("HasCannon",true)
		pl:Give("weapon_auroracannon")
	end
end)

concommand.Add("ta_printsquads",function()
	for _,p in ipairs(player.GetAll()) do
		p:ChatPrint("And the teams are...")
		for k,sqd in pairs(GAMEMODE.Squads) do
			p:ChatPrint("----------Team "..k.."----------")
			for a,b in pairs(sqd) do
				p:ChatPrint("----Squad "..a.."----")
				for c,d in pairs(b) do
					if c != "name" then
					p:ChatPrint("Player "..c..": "..d:Name())
					end
				end
			end
		end
	end
end)

concommand.Add("ta_save",function(pl)
	if !pl:IsAdmin() then return end
	for _,v in ipairs(player.GetAll()) do
		if not string.find(string.lower(v:Name()),"bot") then
			DB.Save()
		end
	end
end)

concommand.Add("ta_points",function(pl)
	pl:ChatPrint(DB.GetPoints(pl))
end)

concommand.Add("ta_bots",function(pl)
	if !pl:IsAdmin() then return end
	for i=1,5 do pl:ConCommand("bot") end
end)

concommand.Add("ta_send",function(pl)
	local tbl = pl:GetSquad()
	umsg.Start("sendSquad",pl)
		umsg.Entity(tbl.leader)
		umsg.Short(GAMEMODE.SquadMax)
		for k,q in pairs(tbl) do if k !="name" and k != "leader" and q != tbl.leader then
			umsg.Entity(q)
		end end
	umsg.End()
end)

concommand.Add("ta_ambience",function(pl,cmd,args)
	if !pl:IsAdmin() then return end
	SetGlobalString("ta_ambience",args[1])
end)