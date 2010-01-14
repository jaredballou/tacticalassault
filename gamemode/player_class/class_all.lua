// Runner Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Runner"
CLASS.Description = "Run twice as fast! \nPrimary: SMG \nSecondary: Pistol"
CLASS.WalkSpeed = 400
CLASS.RunSpeed = 600
CLASS.MaxHealth = 75
CLASS.StartHealth = 75

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_mp7")
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_flash")
	pl:Give("weapon_mad_smoke")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Runner", CLASS )



// Assault Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Assault"
CLASS.Description = "Outlast your enemies! \nPrimary: Heavy Machine Gun \nSecondary: Shotgun \nTertiary: Resupply"
CLASS.WalkSpeed = 200
CLASS.RunSpeed = 320
CLASS.MaxHealth = 150
CLASS.StartHealth = 150

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_mp7")
	pl:Give("weapon_para")
	pl:Give("weapon_resupply")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Assault", CLASS )



// Sniper Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Sniper"
CLASS.Description = "Get 'em long range! \nPrimary: Sniper \nSecondary: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_crossbow")
	pl:Give("weapon_mad_usp_match")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Sniper", CLASS )


// Artillery Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Artillery"
CLASS.Description = "Bring in the big guns. \nPrimary: Bazooka \nSecondary: Shotgun"
CLASS.WalkSpeed = 230
CLASS.RunSpeed = 350
CLASS.MaxHealth = 120
CLASS.StartHealth = 120

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_spas")
	pl:Give("weapon_mad_rpg")
	pl:Give("weapon_mad_magnade")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Artillery", CLASS )



// Medic Class
local CLASS= {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Medic"
CLASS.Description = "Backbone of the team. \nPrimary: Pistol \nSecondary: Medic Kit"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_mp7")
	pl:Give("weapon_medigun")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Medic", CLASS)



// Techie class
local CLASS= {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Techie"
CLASS.Description = "Build machines, create tech. \nPrimary: Shotgun \nSecondary: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_mad_usp_match")
	pl:Give("weapon_mad_spas")
	pl:Give("weapon_slam")
	pl:Give("weapon_physcannon")
	pl:Give("weapon_techie")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Techie", CLASS)

