local Version = "1.1"
local AutoUpdate = true

if myHero.charName ~= "Cassiopeia" then
  return
end

class "HTTF_Cassiopeia"
require 'HPrediction'

function HTTF_Cassiopeia:ScriptMsg(msg)
  print("<font color=\"#daa520\"><b>HTTF Cassiopeia:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

---------------------------------------------------------------------------------

local Host = "raw.github.com"

local ScriptFilePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME

local ScriptPath = "/BolHTTF/BoL/master/HTTF/HTTF Cassiopeia.lua".."?rand="..math.random(1,10000)
local UpdateURL = "https://"..Host..ScriptPath

local VersionPath = "/BolHTTF/BoL/master/HTTF/Version/HTTF Cassiopeia.version".."?rand="..math.random(1,10000)
local VersionData = tonumber(GetWebResult(Host, VersionPath))

if AutoUpdate then

  if VersionData then
  
    ServerVersion = type(VersionData) == "number" and VersionData or nil
    
    if ServerVersion then
    
      if tonumber(Version) < ServerVersion then
        HTTF_Cassiopeia:ScriptMsg("New version available: v"..VersionData)
        HTTF_Cassiopeia:ScriptMsg("Updating, please don't press F9.")
        DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () HTTF_Cassiopeia:ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
      else
        HTTF_Cassiopeia:ScriptMsg("You've got the latest version: v"..Version)
      end
      
    end
    
  else
    HTTF_Cassiopeia:ScriptMsg("Error downloading version info.")
  end
  
else
  HTTF_Cassiopeia:ScriptMsg("AutoUpdate: false")
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function OnLoad()

  HTTF_Cassiopeia = HTTF_Cassiopeia()
  
end

function HTTF_Cassiopeia:__init()

  self:Variables()
  self:Menu()
  DelayAction(function() self:Orbwalk() end, 1)
  
  AddTickCallback(function() self:OnTick() end)
  AddDrawCallback(function() self:OnDraw() end)
  AddSendPacketCallback(function(p) self:OnSendPacket(p) end)
  
end

function HTTF_Cassiopeia:Variables()

  self.HPred = HPrediction()
  self.RebornLoaded, self.RevampedLoaded, self.MMALoaded, self.SxOrbLoaded, self.SOWLoaded = false, false, false, false, false
  
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    self.Ignite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    self.Ignite = SUMMONER_2
  end
  
  if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
    self.Smite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then
    self.Smite = SUMMONER_2
  end
  
  self.Q = {range = 850} --radius = 200
  self.W = {range = 850} --radius = 294/2
  self.E = {range = 700}
  self.R = {range = 825}
  self.I = {range = 600}
  self.S = {range = 760}
  
  local S5SR
  local TT
  
  if GetGame().map.index == 15 then
    S5SR = true
  elseif GetGame().map.index == 4 then
    TT = true
  end
  
  if S5SR then
    self.FocusJungleNames =
    {
    "SRU_Baron12.1.1",
    "SRU_Blue1.1.1",
    "SRU_Blue7.1.1",
    "Sru_Crab15.1.1",
    "Sru_Crab16.1.1",
    "SRU_Dragon6.1.1",
    "SRU_Gromp13.1.1",
    "SRU_Gromp14.1.1",
    "SRU_Krug5.1.2",
    "SRU_Krug11.1.2",
    "SRU_Murkwolf2.1.1",
    "SRU_Murkwolf8.1.1",
    "SRU_Razorbeak3.1.1",
    "SRU_Razorbeak9.1.1",
    "SRU_Red4.1.1",
    "SRU_Red10.1.1"
    }
    self.JungleMobNames =
    {
    "SRU_BlueMini1.1.2",
    "SRU_BlueMini7.1.2",
    "SRU_BlueMini21.1.3",
    "SRU_BlueMini27.1.3",
    "SRU_KrugMini5.1.1",
    "SRU_KrugMini11.1.1",
    "SRU_MurkwolfMini2.1.2",
    "SRU_MurkwolfMini2.1.3",
    "SRU_MurkwolfMini8.1.2",
    "SRU_MurkwolfMini8.1.3",
    "SRU_RazorbeakMini3.1.2",
    "SRU_RazorbeakMini3.1.3",
    "SRU_RazorbeakMini3.1.4",
    "SRU_RazorbeakMini9.1.2",
    "SRU_RazorbeakMini9.1.3",
    "SRU_RazorbeakMini9.1.4",
    "SRU_RedMini4.1.2",
    "SRU_RedMini4.1.3",
    "SRU_RedMini10.1.2",
    "SRU_RedMini10.1.3"
    }
  elseif TT then
    self.FocusJungleNames =
    {
    "TT_NWraith1.1.1",
    "TT_NGolem2.1.1",
    "TT_NWolf3.1.1",
    "TT_NWraith4.1.1",
    "TT_NGolem5.1.1",
    "TT_NWolf6.1.1",
    "TT_Spiderboss8.1.1"
    }   
    self.JungleMobNames =
    {
    "TT_NWraith21.1.2",
    "TT_NWraith21.1.3",
    "TT_NGolem22.1.2",
    "TT_NWolf23.1.2",
    "TT_NWolf23.1.3",
    "TT_NWraith24.1.2",
    "TT_NWraith24.1.3",
    "TT_NGolem25.1.1",
    "TT_NWolf26.1.2",
    "TT_NWolf26.1.3"
    }
  else
    self.FocusJungleNames =
    {
    }   
    self.JungleMobNames =
    {
    }
  end
  
  self.QTS = TargetSelector(TARGET_LESS_CAST, self.Q.range, DAMAGE_MAGIC, false)
  self.ETS = TargetSelector(TARGET_LESS_CAST, self.E.range, DAMAGE_MAGIC, false)
  
  self.EnemyHeroes = GetEnemyHeroes()
  self.EnemyMinions = minionManager(MINION_ENEMY, self.Q.range, myHero, MINION_SORT_MAXHEALTH_DEC)
  self.JungleMobs = minionManager(MINION_JUNGLE, self.Q.range, myHero, MINION_SORT_MAXHEALTH_DEC)
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Menu()

  self.Menu = scriptConfig("HTTF Cassiopeia", "HTTF Cassiopeia")
  
  self.Menu:addSubMenu("HitChance Settings", "HitChance")
  
    self.Menu.HitChance:addSubMenu("Combo", "Combo")
      self.Menu.HitChance.Combo:addParam("Q", "Q HitChacne (Default value = 1)", SCRIPT_PARAM_SLICE, 1, 1, 3, 2)
      self.Menu.HitChance.Combo:addParam("W", "W HitChacne (Default value = 1)", SCRIPT_PARAM_SLICE, 1, 1, 3, 2)
      
    self.Menu.HitChance:addSubMenu("Harass", "Harass")
      self.Menu.HitChance.Harass:addParam("Q", "Q HitChacne (Default value = 2)", SCRIPT_PARAM_SLICE, 2, 1, 3, 2)
      self.Menu.HitChance.Harass:addParam("W", "W HitChacne (Default value = 2)", SCRIPT_PARAM_SLICE, 2, 1, 3, 2)
      
  self.Menu:addSubMenu("Combo Settings", "Combo")
    self.Menu.Combo:addParam("On", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("Info", "Use W if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("WMana", "Default value = 25", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
    self.Menu.Combo:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu:addSubMenu("Harass Settings", "Harass")
    self.Menu.Harass:addParam("On", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))
    self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("Info", "Use W if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("WMana", "Default value = 80", SCRIPT_PARAM_SLICE, 80, 0, 100, 0)
    self.Menu.Harass:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu:addSubMenu("Clear Settings", "Clear")
  
    self.Menu.Clear:addSubMenu("Lane Clear Settings", "Farm")
      self.Menu.Clear.Farm:addParam("On", "Lane Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
      self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("Info", "Use Q if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("QMana", "Default value = 30", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
      self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("Info", "Use W if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("WMana", "Default value = 15", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
      self.Menu.Clear.Farm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("UseE", "Use E to Clear)", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.Farm:addParam("Info", "Use E if Mana Percent > x%", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.Farm:addParam("EMana", "Default value = 75", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
      
    self.Menu.Clear:addSubMenu("Jungle Clear Settings", "JFarm")
      self.Menu.Clear.JFarm:addParam("On", "Jungle Claer", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
      self.Menu.Clear.JFarm:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Clear.JFarm:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.JFarm:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
      self.Menu.Clear.JFarm:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
      
  self.Menu:addSubMenu("LastHit Settings", "LastHit")
    self.Menu.LastHit:addParam("On", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
    
  self.Menu:addSubMenu("KillSteal Settings", "KillSteal")
    self.Menu.KillSteal:addParam("On", "KillSteal", SCRIPT_PARAM_ONOFF, true)
    self.Menu.KillSteal:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
    if self.Ignite ~= nil then
      self.Menu.KillSteal:addParam("Blank3", "", SCRIPT_PARAM_INFO, "")
      self.Menu.KillSteal:addParam("UseI", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
    end
    
  self.Menu:addSubMenu("Flee Settings", "Flee")
    self.Menu.Flee:addParam("On", "Flee (Only Use KillSteal)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('G'))
    
  self.Menu:addSubMenu("Misc Settings", "Misc")
    self.Menu.Misc:addParam("LastE", "LastHit E even if minion isn't poisoned", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Misc:addParam("Info", "(If Mana Percent < x%)", SCRIPT_PARAM_INFO, "")
    self.Menu.Misc:addParam("EMana", "Default value = 30", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    self.Menu.Misc:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Misc:addParam("STarget", "Attack Only Selected Target (T)", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Misc:addParam("SRange", "Select range (850)", SCRIPT_PARAM_SLICE, 850, 600, 1100, -1)
    
  self.Menu:addSubMenu("Draw Settings", "Draw")
  
    self.Menu.Draw:addParam("On", "Draw", SCRIPT_PARAM_ONOFF, true)
  
    self.Menu.Draw:addParam("Target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Lfc", "Draw Lag free circles", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("AA", "Draw AA range", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("Q", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Draw:addParam("W", "Draw W range", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("E", "Draw E range", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("R", "Draw R range", SCRIPT_PARAM_ONOFF, false)
    if self.Ignite ~= nil then
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Draw:addParam("I", "Draw Ignite range", SCRIPT_PARAM_ONOFF, false)
    end
    if self.Smite ~= nil then
      self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.Menu.Draw:addParam("S", "Draw Smite range", SCRIPT_PARAM_ONOFF, true)
    end
    self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Path", "Draw Move Path", SCRIPT_PARAM_ONOFF, false)
    self.Menu.Draw:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    self.Menu.Draw:addParam("Hitchance", "Draw Hitchance", SCRIPT_PARAM_ONOFF, true)
    
  self.Menu.Combo.On = false
  self.Menu.Harass.On = false
  self.Menu.Clear.Farm.On = false
  self.Menu.Clear.JFarm.On = false
  self.Menu.LastHit.On = false
  self.Menu.Flee.On = false
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Orbwalk()

  if _G.AutoCarry then
  
    if _G.Reborn_Initialised then
      self.RebornLoaded = true
      self:ScriptMsg("Found SAC: Reborn.")
    else
      self.RevampedLoaded = true
      self:ScriptMsg("Found SAC: Revamped.")
    end
    
  elseif _G.Reborn_Loaded then
    DelayAction(function() self:Orbwalk() end, 1)
  elseif _G.MMA_IsLoaded then
    self.MMALoaded = true
    self:ScriptMsg("Found MMA.")
  elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
    require 'SxOrbWalk'
    
    self.SxOrbMenu = scriptConfig("SxOrb Settings", "SxOrb")
    
    self.SxOrb = SxOrbWalk()
    self.SxOrb:LoadToMenu(self.SxOrbMenu)
    
    self.SxOrbLoaded = true
    self:ScriptMsg("Found SxOrb.")
  elseif FileExist(LIB_PATH .. "SOW.lua") then
    require 'SOW'
    require 'VPrediction'
    
    self.VP = VPrediction()
    self.SOWVP = SOW(self.VP)
    
    self.Menu:addSubMenu("Orbwalk Settings (SOW)", "Orbwalk")
      self.Menu.Orbwalk:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
      self.Menu.Orbwalk:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      self.SOWVP:LoadToMenu(self.Menu.Orbwalk)
      
    self.SOWLoaded = true
    self.ScriptMsg("Found SOW.")
  else
    self:ScriptMsg("Orbwalk not founded.")
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:OnTick()

  if myHero.dead then
    return
  end
  
  self:Targets()
  
  if self.Menu.Combo.On then
    self:Combo()
  end
  
  if self.Menu.Harass.On then
    self:Harass()
  end
  
  if self.Menu.Clear.Farm.On then
    self.EnemyMinions:update()
    self:Farm()
  end
  
  if self.Menu.Clear.JFarm.On then
    self.JungleMobs:update()
    self:JFarm()
  end
  
  if self.Menu.LastHit.On then
    self.EnemyMinions:update()
    self:LastHit()
  end
  
  if self.Menu.KillSteal.On then
    self:KillSteal()
  end
  
  if self.Menu.Flee.On then
    self:Flee()
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Clock()
  return os.clock()-GetLatency()/2000
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Level(spell)
  return myHero:GetSpellData(spell).level
end

function HTTF_Cassiopeia:Ready(spell)
  return spell and myHero:CanUseSpell(spell) == READY
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Targets()

  if self.Menu.Misc.STarget and GetTarget() and GetTarget().type == myHero.type and GetTarget().team ~= myHero.team then
    self.Target = GetTarget()
  else
    self.Target = nil
  end
  
  if self.Target and ValidTarget(self.Target, self.Menu.Misc.SRange) then
    self.QTarget = self.Target
    self.ETarget = self.Target
    return
  end
  
  self.QTS:update()
  self.QTarget = self.QTS.target
  
  self.ETS:update()
  self.ETarget = self.ETS.target
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Combo()

  local UseQ = self.Menu.Combo.UseQ
  local UseW = self.Menu.Combo.UseW
  local WMana = self.Menu.Combo.WMana
  local UseE = self.Menu.Combo.UseE
  
  if self.ETarget and self:TargetPoisoned(self.ETarget) and UseE and self:Ready(_E) and ValidTarget(self.ETarget, self.E.range) then
    self:CastE(self.ETarget)
  end
  
  if self.QTarget and UseQ and self:Ready(_Q) and ValidTarget(self.QTarget, self.Q.range) then
    self:CastQ(self.QTarget, "Combo")
  end
  
  if self.QTarget and not self:TargetPoisoned(self.QTarget) and UseW and self:Ready(_W) and WMana <= self:ManaPercent() and ValidTarget(self.QTarget, self.W.range) then
    self:CastW(self.QTarget, "Combo")
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Harass()

  local UseQ = self.Menu.Harass.UseQ
  local UseW = self.Menu.Harass.UseW
  local WMana = self.Menu.Harass.WMana
  local UseE = self.Menu.Harass.UseE
  
  if self.ETarget and self:TargetPoisoned(self.ETarget) and UseE and self:Ready(_E) and ValidTarget(self.ETarget, self.E.range) then
    self:CastE(self.ETarget)
  end
  
  if self.QTarget and UseQ and self:Ready(_Q) and ValidTarget(self.QTarget, self.Q.range) then
    self:CastQ(self.QTarget, "Harass")
  end
  
  if self.QTarget and not self:TargetPoisoned(self.QTarget) and UseW and self:Ready(_W) and WMana <= self:ManaPercent() and ValidTarget(self.QTarget, self.W.range) then
    self:CastW(self.QTarget, "Harass")
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Farm()

  local UseQ = self.Menu.Clear.Farm.UseQ
  local QMana = self.Menu.Clear.Farm.QMana
  local UseW = self.Menu.Clear.Farm.UseW
  local WMana = self.Menu.Clear.Farm.WMana
  local UseE = self.Menu.Clear.Farm.UseE
  
  if UseE and self:Ready(_E) then
    self:FarmE()
  end
  
  if UseQ and self:Ready(_Q) and QMana <= self:ManaPercent() then
    self:FarmQ()
  end
  
  if UseW and self:Ready(_W) and WMana <= self:ManaPercent() then
    self:FarmW()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:FarmE()

  local EMana = self.Menu.Clear.Farm.EMana
  local LastE = self.Menu.Misc.LastE
  local LastEMana = self.Menu.Misc.EMana
  
  for i, minion in pairs(self.EnemyMinions.objects) do
  
    local EMinionDmg = self:GetDmg("E", minion)
    
    if self:TargetPoisoned(minion) and EMinionDmg >= self.HPred:PredictHealth(minion, GetDistance(minion, myHero)/1900) and ValidTarget(minion, self.E.range) then
      self:CastE(minion)
      return
    end
    
  end
  
  if LastE and LastEMana >= self:ManaPercent() then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local EMinionDmg = self:GetDmg("E", minion)
      
      if EMinionDmg >= self.HPred:PredictHealth(minion, GetDistance(minion, myHero)/1900) and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
        return
      end
      
    end
    
  end
  
  if EMana <= self:ManaPercent() then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      if self:TargetPoisoned(minion) and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:FarmQ()

  for i, minion in pairs(self.EnemyMinions.objects) do
  
    local QMinionDmg = self:GetDmg("Q", minion)
    local EMinionDmg = self:GetDmg("E", minion)
    
    if not self:TargetPoisoned(minion) and (EMinionDmg < minion.health or 2/3*QMinionDmg < minion.health and QMinionDmg/3+EMinionDmg >= minion.health) and ValidTarget(minion, self.Q.range) then
      self:CastQ(minion)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:FarmW()

  for i, minion in pairs(self.EnemyMinions.objects) do
  
    local WMinionDmg = self:GetDmg("W", minion)
    local EMinionDmg = self:GetDmg("E", minion)
    
    if not self:TargetPoisoned(minion) and (EMinionDmg < minion.health or 2/9*WMinionDmg < minion.health and WMinionDmg/9+EMinionDmg >= minion.health) and ValidTarget(minion, self.W.range) then
      self:CastW(minion)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:JFarm()

  local UseQ = self.Menu.Clear.JFarm.UseQ
  local UseW = self.Menu.Clear.JFarm.UseW
  local UseE = self.Menu.Clear.JFarm.UseE
  
  if UseE and self:Ready(_E) then
    self:JFarmE()
  end
  
  if UseQ and self:Ready(_Q) then
    self:JFarmQ()
  end
  
  if UseW and self:Ready(_W) then
    self:JFarmW()
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:JFarmE()

  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    for j = 1, #self.FocusJungleNames do
    
      if junglemob.name == self.FocusJungleNames[j] and self:TargetPoisoned(junglemob) and GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.E.range) then
        self:CastE(junglemob)
        return
      end
      
    end
    
  end
  
  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    if self:TargetPoisoned(junglemob) and GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.E.range) then
      self:CastE(junglemob)
      return
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:JFarmQ()

  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    for j = 1, #self.FocusJungleNames do
    
      if junglemob.name == self.FocusJungleNames[j] and GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.Q.range) then
        self:CastQ(junglemob)
        return
      end
      
    end
    
  end
  
  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    if GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.Q.range) then
      self:CastQ(junglemob)
      return
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:JFarmW()

  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    for j = 1, #self.FocusJungleNames do
    
      if junglemob.name == self.FocusJungleNames[j] and GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.W.range) then
        self:CastW(junglemob)
        return
      end
      
    end
    
  end
  
  for i, junglemob in pairs(self.JungleMobs.objects) do
  
    if GetDistance(junglemob, mousePos) <= 800 and ValidTarget(junglemob, self.W.range) then
      self:CastW(junglemob)
      return
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:LastHit()

  local UseE = self.Menu.LastHit.On
  local LastE = self.Menu.Misc.LastE
  local LastEMana = self.Menu.Misc.EMana
  
  if UseE and self:Ready(_E) then
  
    for i, minion in pairs(self.EnemyMinions.objects) do
    
      local EMinionDmg = self:GetDmg("E", minion)
      
      if self:TargetPoisoned(minion) and EMinionDmg >= self.HPred:PredictHealth(minion, GetDistance(minion, myHero)/1900) and ValidTarget(minion, self.E.range) then
        self:CastE(minion)
        return
      end
      
    end
    
    if LastE and LastEMana >= self:ManaPercent() then
    
      for i, minion in pairs(self.EnemyMinions.objects) do
      
        local EMinionDmg = self:GetDmg("E", minion)
        
        if EMinionDmg >= self.HPred:PredictHealth(minion, GetDistance(minion, myHero)/1900) and ValidTarget(minion, self.E.range) then
          self:CastE(minion)
          return
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:KillSteal()

  local UseQ = self.Menu.KillSteal.UseQ
  local UseE = self.Menu.KillSteal.UseE
  local UseI = self.Menu.KillSteal.UseI
  
  for i, enemy in ipairs(self.EnemyHeroes) do
  
    local QTargetDmg = self:GetDmg("Q", enemy)
    local ETargetDmg = self:GetDmg("E", enemy)
    local ITargetDmg = self:GetDmg("IGNITE", enemy)
    
    if UseI and self:Ready(self.Ignite) and ITargetDmg >= enemy.health and ValidTarget(enemy, self.I.range) then
      self:CastI(enemy)
    end
    
    if UseQ and self:Ready(_Q) and QTargetDmg >= enemy.health and ValidTarget(enemy, self.Q.range) then
      self:CastQ(enemy, "KillSteal")
    end
    
    if UseE and self:Ready(_E) and ETargetDmg >= enemy.health and ValidTarget(enemy, self.E.range) then
      self:CastE(enemy)
    end
    
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:Flee()
  self:MoveToMouse()
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:TargetPoisoned(unit)

  if TargetHaveBuff("cassiopeianoxiousblastpoison", unit) or TargetHaveBuff("cassiopeiamiasmapoison", unit) then
    return true
  end
  
  return false
end

function HTTF_Cassiopeia:ManaPercent()
  return (myHero.mana/myHero.maxMana)*100
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:GetDmg(spell, enemy)

  local ADDmg = 0
  local APDmg = 0
  
  local Level = myHero.level
  local TotalDmg = myHero.totalDamage
  local AddDmg = myHero.addDamage
  local AP = myHero.ap
  local ArmorPen = myHero.armorPen
  local ArmorPenPercent = myHero.armorPenPercent
  local MagicPen = myHero.magicPen
  local MagicPenPercent = myHero.magicPenPercent
  
  local Armor = math.max(0, enemy.armor*ArmorPenPercent-ArmorPen)
  local ArmorPercent = Armor/(100+Armor)
  local MagicArmor = math.max(0, enemy.magicArmor*MagicPenPercent-MagicPen)
  local MagicArmorPercent = MagicArmor/(100+MagicArmor)
  
  if spell == "IGNITE" then
  
    local TrueDmg = 50+20*Level
    
    return TrueDmg
  elseif spell == "SMITE" then
  
    if Level <= 4 then
    
      local TrueDmg = 370+20*Level
      
      return TrueDmg
    elseif Level <= 9 then
    
      local TrueDmg = 330+30*Level
      
      return TrueDmg
    elseif Level <= 14 then
    
      local TrueDmg = 240+40*Level
      
      return TrueDmg
    else
    
      local TrueDmg = 100+50*Level
      
      return TrueDmg
    end
  elseif spell == "AA" then
    ADDmg = TotalDmg
  elseif spell == "Q" then
    APDmg = 40*self:Level(_Q)+35+.45*AP
  elseif spell == "W" then
    APDmg = 45*self:Level(_W)+45+.9*AP
  elseif spell == "E" then
    APDmg = 25*self:Level(_E)+30+.55*AP
  elseif spell == "R" then
    APDmg = 100*self:Level(_R)+50+.5*AP
  end
  
  local TrueDmg = ADDmg*(1-ArmorPercent)+APDmg*(1-MagicArmorPercent)
  
  return TrueDmg
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:CastQ(unit, mode)

  if unit.dead then
    return
  end
  
  self.QPos, self.QHitChance = self.HPred:GetPredict(self.HPred.Presets["Cassiopeia"]["Q"], unit, myHero)
  
  if mode == "Combo" and self.QHitChance >= self.Menu.HitChance.Combo.Q or mode == "Harass" and self.QHitChance >= self.Menu.HitChance.Harass.Q or mode == "KillSteal" and self.QHitChance > 1 or mode == nil and self.QHitChance > 0 then
    CastSpell(_Q, self.QPos.x, self.QPos.z)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:CastW(unit, mode)

  if unit.dead then
    return
  end
  
  self.WPos, self.WHitChance = self.HPred:GetPredict(self.HPred.Presets["Cassiopeia"]["W"], unit, myHero)
  
  if mode == "Combo" and self.WHitChance >= self.Menu.HitChance.Combo.W or mode == "Harass" and self.WHitChance >= self.Menu.HitChance.Harass.W or mode == nil and self.WHitChance > 0 then
    CastSpell(_W, self.WPos.x, self.WPos.z)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:CastE(unit)

  if unit.dead then
    return
  end
  
  CastSpell(_E, unit)
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:CastI(unit)

  if unit.dead then
    return
  end
  
  CastSpell(self.Ignite, unit)
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:MoveToMouse()

  if mousePos and GetDistance(mousePos) <= 150 then
    MousePos = myHero+(Vector(mousePos)-myHero):normalized()*150
  else
    MousePos = mousePos
  end
  
  myHero:MoveTo(MousePos.x, MousePos.z)
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:OnDraw()

  if not self.Menu.Draw.On or myHero.dead then
    return
  end
  
  if self.Menu.Draw.Target then
  
    if self.Menu.Misc.STarget and self.Target and ValidTarget(self.Target, self.Menu.Misc.SRange) then
      self:DrawCircle(self.Target.x, self.Target.y, self.Target.z, 2*self.Target.boundingRadius, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
    else
    
      if self.Menu.Misc.STarget and self.Target then
        self:DrawCircle(self.Target.x, self.Target.y, self.Target.z, 2*self.Target.boundingRadius, ARGB(0xFF, 0xFF, 0x00, 0x00))
      end
      
      if self.QTarget then
        self:DrawCircle(self.QTarget.x, self.QTarget.y, self.QTarget.z, 2*self.QTarget.boundingRadius, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
      elseif self.ETarget then
        self:DrawCircle(self.ETarget.x, self.ETarget.y, self.ETarget.z, 2*self.ETarget.boundingRadius, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
      end
      
    end
    
  end
  
  if self.Menu.Draw.Hitchance then
  
    if self.QHitChance ~= nil then
    
      if self.QHitChance < 1 then
        self.Qcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
      elseif self.QHitChance == 3 then
        self.Qcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
      elseif self.QHitChance >= 2 then
        self.Qcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
      elseif self.QHitChance >= 1 then
        self.Qcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
      end
      
      DrawText("Q HitChance: "..self.QHitChance, 20, 1250, 550, self.Qcolor)
      self.QHitChance = nil
    end
    
    if self.WHitChance ~= nil then
    
      if self.WHitChance < 1 then
        self.Wcolor = ARGB(0xFF, 0xFF, 0x00, 0x00)
      elseif self.WHitChance == 3 then
        self.Wcolor = ARGB(0xFF, 0x00, 0x54, 0xFF)
      elseif self.WHitChance >= 2 then
        self.Wcolor = ARGB(0xFF, 0x1D, 0xDB, 0x16)
      elseif self.WHitChance >= 1 then
        self.Wcolor = ARGB(0xFF, 0xFF, 0xE4, 0x00)
      end
      
      DrawText("W HitChance: "..self.WHitChance, 20, 1250, 600, self.Wcolor)
      self.WHitChance = nil
    end
    
  end
  
  if self.Menu.Draw.AA then
  
    if self.Target and ValidTarget(self.Target, self:TrueRange(self.Target)) then
      self:DrawCircle(myHero.x, myHero.y, myHero.z, self:TrueRange(self.Target), ARGB(0xFF, 0, 0xFF, 0))
    else
      self:DrawCircle(myHero.x, myHero.y, myHero.z, myHero.range+myHero.boundingRadius, ARGB(0xFF, 0, 0xFF, 0))
    end
    
  end
  
  if self.Menu.Draw.Q then
    self:DrawCircle(myHero.x, myHero.y, myHero.z, self.Q.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.Menu.Draw.W and self:Ready(_W) then
    self:DrawCircle(myHero.x, myHero.y, myHero.z, self.W.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.Menu.Draw.E then
    self:DrawCircle(myHero.x, myHero.y, myHero.z, self.E.range, ARGB(0xFF, 0xFF, 0xFF, 0xFF))
  end
  
  if self.Menu.Draw.R and self:Ready(_R) then
    self:DrawCircle(myHero.x, myHero.y, myHero.z, self.R.range, ARGB(0xFF, 0x00, 0x00, 0xFF))
  end
  
  if self.Menu.Draw.I and self:Ready(self.Ignite) then
    self:DrawCircle(myHero.x, myHero.y, myHero.z, self.I.range, ARGB(0xFF, 0xFF, 0x24, 0x24))
  end
  
  if self.Menu.Draw.Path then
  
    if myHero.hasMovePath and myHero.pathCount >= 2 then
    
      local IndexPath = myHero:GetPath(myHero.pathIndex)
      
      if IndexPath then
        DrawLine3D(myHero.x, myHero.y, myHero.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
      end
      
      for i=myHero.pathIndex, myHero.pathCount-1 do
      
        local Path = myHero:GetPath(i)
        local Path2 = myHero:GetPath(i+1)
        
        DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
      end
      
    end
    
    for i, enemy in ipairs(self.EnemyHeroes) do
    
      if enemy == nil then
        return
      end
      
      if enemy.hasMovePath and enemy.pathCount >= 2 then
      
        local IndexPath = enemy:GetPath(enemy.pathIndex)
        
        if IndexPath then
          DrawLine3D(enemy.x, enemy.y, enemy.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 255, 255, 255))
        end
        
        for i=enemy.pathIndex, enemy.pathCount-1 do
        
          local Path = enemy:GetPath(i)
          local Path2 = enemy:GetPath(i+1)
          
          DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 255))
        end
        
      end
      
    end
    
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:DrawCircle(x, y, z, radius, color)

  if self.Menu.Draw.Lfc then
  
    local v1 = Vector(x, y, z)
    local v2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = v1-(v1-v2):normalized()*radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    
    if OnScreen({x = sPos.x, y = sPos.y}, {x = sPos.x, y = sPos.y}) then
      self:DrawCircles2(x, y, z, radius, color) 
    end
    
  else
    DrawCircle(x, y, z, radius, color)
  end
  
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:DrawCircles2(x, y, z, radius, color)

  local length = 75
  local radius = radius*.92
  local quality = math.max(8,self:round(180/math.deg((math.asin((length/(2*radius)))))))
  local quality = 2*math.pi/quality
  local points = {}
  
  for theta = 0, 2*math.pi+quality, quality do
  
    local c = WorldToScreen(D3DXVECTOR3(x+radius*math.cos(theta), y, z-radius*math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, 2, color or 4294967295)
end

---------------------------------------------------------------------------------

function HTTF_Cassiopeia:round(num)

  if num >= 0 then
    return math.floor(num+.5)
  else
    return math.ceil(num-.5)
  end
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function HTTF_Cassiopeia:OnSendPacket(p)

  local netID = p:DecodeF()  
  
  p.pos = 22
  
  local p22D1 = p:Decode1()
  
  if (self.Menu.Combo.On or self.Menu.Harass.On) and (self.Target or self.ETarget) and GetDistance((self.Target or self.ETarget), myHero) < 400 and p.header == 0xA0 and netID == myHero.networkID and p22D1 == 0xAD then
    --p:Block()
  end
  
end
