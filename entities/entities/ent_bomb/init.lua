AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end


function ENT:Initialize()	

	self:SetModel( "models/weapons/w_c4.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self:SetMoveType(MOVETYPE_NONE)
	
	self.Activated = false
	self.Timer = 0
	self.Defuse = {nil,0}
	self.Defused = false
	self.Beep = Sound("weapons/c4/c4_beep1.wav")
	self.Entity:SetNWInt("bomb_timer",0)
	
end

function ENT:TurnOn()
	self.Activated = true
	self.Timer = 30
	timer.Create("ta_bombtimer"..self.Entity:EntIndex(),1,30,function()
		if !self.Entity or !self.Entity:IsValid() then return end
		
		self.Timer = self.Timer - 1
		self.Entity:SetNWInt("bomb_timer",self.Timer)
		if self.Timer == 0 then 
			self.Entity:Remove() 
			self:Remove()
		end
		
		if self.Timer > 10 then self.Entity:EmitSound(self.Beep)
		elseif self.Timer > 5 then self.Entity:EmitSound(self.Beep)
			timer.Simple(0.5,function() self.Entity:EmitSound(self.Beep) end)
		elseif self.Timer > 0 then
			self.Entity:EmitSound(self.Beep)
			timer.Simple(0.33,function() self.Entity:EmitSound(self.Beep) end)
			timer.Simple(0.66,function() self.Entity:EmitSound(self.Beep) end)
		end
	end)
end


function ENT:Think()
	
	local someoneisdefusing = false
	for _,v in ipairs(player.GetAll()) do
		
		if v:GetPos():Distance(self.Entity:GetPos()) < 40 and v:KeyDown(IN_USE) and (not self.Defuse[1] or self.Defuse[1] == v) then
			
			if !self.Defuse[1] then self.Entity:EmitSound("weapons/c4/c4_disarm.wav") end
		
			self.Defuse = {v,self.Defuse[2] + 1}
			self.Entity:SetNWInt("ta_defuse",self.Defuse[2])
			self.Entity:SetNWEntity("ta_defuser",self.Defuse[1])
			someoneisdefusing = true
			
			if self.Defuse[2] == 50 then
				self.Defused = true
				self.Entity:Remove()
				self:Remove()
			end
			
		end
		
	end
	
	if !someoneisdefusing then self.Defuse = {nil,0} end
	
end


function ENT:OnRemove()
	if self.Defused then 
		if self.Defuse[1]:Team() == 1 then 
			for _,v in ipairs(team.GetPlayers(2)) do v:SendLua("surface.PlaySound(\"common/bugreporterfailed.wav\")") end
			hook.Call("ta_bombwon",nil,1,false)
		else 
			for _,v in ipairs(team.GetPlayers(1)) do v:SendLua("surface.PlaySound(\"common/bugreporterfailed.wav\")") end 
			hook.Call("ta_bombwon",nil,2,false)
		end
		
		return
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( self.Entity:GetPos() )
	effectdata:SetNormal( self.Entity:GetPos():GetNormalized() )
	effectdata:SetEntity( self.Entity )
	util.Effect( "super_explosion", effectdata )
	
	local explosion = ents.Create( "env_explosion" )
	explosion:SetPos(self.Entity:GetPos())
	explosion:SetKeyValue( "iMagnitude" , "500" )
	explosion:SetPhysicsAttacker(self.Owner)
	explosion:SetOwner(self.Owner)
	explosion:Spawn()
	explosion:Fire("explode","",0)
	explosion:Fire("kill","",0 )
	
	self.Entity:GetNWEntity("target"):Remove()
	
	hook.Call("ta_bombwon",nil,self.Entity:GetNWInt("Team"),true)
end







