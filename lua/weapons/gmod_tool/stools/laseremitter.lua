local gsUnit = LaserLib.GetTool()
local gsLaseremCls = LaserLib.GetClass(1)
local gsCrystalCls = LaserLib.GetClass(2)
local gsReflectCls = LaserLib.GetClass(3)

if(CLIENT) then

  TOOL.Information = {
    {name = "info"      , icon = "gui/info"   , icon2 = ""},
    {name = "left"      , icon = "gui/lmb.png", icon2 = ""},
    {name = "right"     , icon = "gui/rmb.png", icon2 = ""},
    {name = "reload"    , icon = "gui/r.png"  , icon2 = ""},
    {name = "reload_use", icon = "gui/r.png"  , icon2 = "gui/e.png"},
  }

  language.Add("tool."..gsUnit..".name", "Laser Spawner")
  language.Add("tool."..gsUnit..".desc", "Spawn very dangerous lasers!")
  language.Add("tool."..gsUnit..".0", "Do not look into beam with remaining eye!")
  language.Add("tool."..gsUnit..".left", "Create/Update a laser where you are aiming")
  language.Add("tool."..gsUnit..".right", "Retrieve laser settings form trace entity")
  language.Add("tool."..gsUnit..".reload", "Reset material. Hold SHIFT to make prop mirror")
  language.Add("tool."..gsUnit..".reload_use", "Apply transparent texture to trace prop")
  language.Add("tool."..gsUnit..".frozen_con", "Freeze on creation")
  language.Add("tool."..gsUnit..".frozen", "Freezes the laser when created")
  language.Add("tool."..gsUnit..".key_con", "Control key")
  language.Add("tool."..gsUnit..".key", "Numpad key that controls the laser trigger")
  language.Add("tool."..gsUnit..".width_con", "Width:")
  language.Add("tool."..gsUnit..".width", "Controls laser beam width")
  language.Add("tool."..gsUnit..".length_con", "Length:")
  language.Add("tool."..gsUnit..".length", "Controls laser beam maximum length")
  language.Add("tool."..gsUnit..".damage_con", "Damage:")
  language.Add("tool."..gsUnit..".damage", "Controls laser beam damage amount")
  language.Add("tool."..gsUnit..".material", "Select laser beam material form the ones shown here")
  language.Add("tool."..gsUnit..".model_con", "Laser entity model:")
  language.Add("tool."..gsUnit..".model", "Select laser visual model form the ones shown here")
  language.Add("tool."..gsUnit..".dissolvetype_con", "Dissolve type:")
  language.Add("tool."..gsUnit..".dissolvetype", "Controls visuals used when dissolving players")
  language.Add("tool."..gsUnit..".startsound_con", "Start sound:")
  language.Add("tool."..gsUnit..".startsound", "Controls sounds used when starting the laser")
  language.Add("tool."..gsUnit..".stopsound_con", "Stop sound:")
  language.Add("tool."..gsUnit..".stopsound", "Controls sounds used when stopping the laser")
  language.Add("tool."..gsUnit..".killsound_con", "Kill sound:")
  language.Add("tool."..gsUnit..".killsound", "Controls sounds used when killing players or NPC")
  language.Add("tool."..gsUnit..".toggle_con", "Toggled operation")
  language.Add("tool."..gsUnit..".toggle", "Starts the laser when the button is hit")
  language.Add("tool."..gsUnit..".starton_con", "Start on creation")
  language.Add("tool."..gsUnit..".starton", "Starts the laser on when gets created")
  language.Add("tool."..gsUnit..".forcecenter_con", "Apply center force")
  language.Add("tool."..gsUnit..".forcecenter", "When prop push force is present enable to force the center instead")
  language.Add("tool."..gsUnit..".pushforce_con", "Push props:")
  language.Add("tool."..gsUnit..".pushforce", "Seutp the laser beam to push props")
  language.Add("tool."..gsUnit..".endingeffect_con", "Enable ending effect")
  language.Add("tool."..gsUnit..".endingeffect", "Allow showing ending effects on beam hit")
  language.Add("tool."..gsUnit..".worldweld_con", "Weld to surface")
  language.Add("tool."..gsUnit..".worldweld", "Welds the laser to the trace surface")
  language.Add("tool."..gsUnit..".reflectrate_con", "Reflection power ratio")
  language.Add("tool."..gsUnit..".reflectrate", "Reflect the amount of power according to the surface material type")
  language.Add("tool."..gsUnit..".refractrate_con", "Refraction power ratio")
  language.Add("tool."..gsUnit..".refractrate", "Refract the amount of power according to the medium material type")
  language.Add("tool."..gsUnit..".enonvermater_con", "Non-override material")
  language.Add("tool."..gsUnit..".enonvermater", "Interact with surfaces that still have their original material")
  language.Add("tool."..gsUnit..".openmaterial", "Default material override manager for: ")
  language.Add("Cleanup_"..gsUnit, "Lasers")
  language.Add("Cleaned_"..gsUnit, "Cleaned up all Lasers")
  language.Add("Undone_"..gsUnit, "Undone Laser Emitter")
  language.Add("SBoxLimit_"..gsUnit.."s", "You've hit the Laser emiters limit!")

  concommand.Add(gsUnit.."_openmaterial",
    function(ply, cmd, args)
      local ratM, datM = LaserLib.GetRatio()
      local keyM = tostring(args[1] or ""):upper()
      if(keyM == "REFLECT") then
        datM = LaserLib.DataReflect("*")
      elseif(keyM == "REFRACT") then
        datM = LaserLib.DataRefract("*")
      else
        return nil
      end
      local pnFrame = vgui.Create("DFrame"); if(not IsValid(pnFrame)) then return nil end
      local scrW, scrH = surface.ScreenWidth(), surface.ScreenHeight()
      pnFrame:SetTitle(language.GetPhrase("tool."..gsUnit..".openmaterial")..keyM)
      pnFrame:SetVisible(false)
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame:SetPos(0, 0)
      pnFrame:SetSize(scrW / (1.4 * ratM), scrH / (1.4 * ratM))
      local pnMat = vgui.Create("MatSelect"); if(not IsValid(pnMat)) then return nil end
            pnMat:SetParent(pnFrame)
            pnMat:DockPadding(3, 3, 3, 3)
            pnMat:Dock(FILL)
            pnMat:SetItemWidth(0.16)
            pnMat:SetItemHeight(0.22)
            pnMat:InvalidateLayout(true)
      for key, val in pairs(datM) do
        if(type(val) == "table" and tostring(key):find("/")) then
          local matL = "{"..table.concat(val, "|").."} "..key
          local matB = vgui.Create("DImageButton"); if(not IsValid(matB)) then return nil end
                matB:SetParent(pnMat)
                matB:SetOnViewMaterial(key, "models/wireframe")
                matB.AutoSize, matB.Value = false, key
                matB:SetTooltip(matL)
                matB.DoClick = function(button)
                  LaserLib.ConCommand(nil, keyM:lower().."used", key)
                end
                matB.DoRightClick = function(button)
                  local matM = DermaMenu()
                  matM:AddOption("#spawnmenu.menu.copy",
                    function() SetClipboardText(key) end):SetIcon("icon16/page_copy.png")
                  matM:Open()
                end
              pnMat.List:AddItem(matB)
              table.insert(pnMat.Controls, matB)
              pnMat:InvalidateLayout(true)
              pnMat.List:InvalidateLayout(true)
        end
      end
      pnMat:InvalidateChildren(true)
      pnFrame:Center()
      pnFrame:SetVisible(true)
      pnFrame:MakePopup()
    end)
end

TOOL.Category = "Construction"
TOOL.Name     = (language and language.GetPhrase("tool."..gsUnit..".name"))

if(SERVER) then
  CreateConVar("sbox_max"..gsUnit.."s", 20)
end

if(CLIENT) then
  language.Add(gsLaseremCls, "Laser Emiter") -- Relative to materials
  killicon.Add(gsLaseremCls, "vgui/entities/gmod_laser_killicon", LaserLib.GetColor("WHITE"))

  language.Add(gsCrystalCls, "Laser Crystal")
  killicon.AddAlias(gsCrystalCls, gsLaseremCls)
end

cleanup.Register(gsUnit.."s")

TOOL.ClientConVar =
{
  [ "key"          ] = 5,
  [ "width"        ] = 4,
  [ "length"       ] = 30000,
  [ "damage"       ] = 2500,
  [ "material"     ] = "cable/physbeam",
  [ "model"        ] = "models/props_combine/headcrabcannister01a_skybox.mdl",
  [ "dissolvetype" ] = "core",
  [ "startsound"   ] = "ambient/energy/weld1.wav",
  [ "stopsound"    ] = "ambient/energy/weld2.wav",
  [ "killsound"    ] = "ambient/levels/citadel/weapon_disintegrate1.wav",
  [ "toggle"       ] = 0,
  [ "starton"      ] = 0,
  [ "pushforce"    ] = 100,
  [ "endingeffect" ] = 1,
  [ "worldweld"    ] = 0,
  [ "angleoffset"  ] = 270,
  [ "reflectrate"  ] = 1,
  [ "refractrate"  ] = 1,
  [ "reflectused"  ] = LaserLib.DataReflect(),
  [ "refractused"  ] = LaserLib.DataRefract(),
  [ "enonvermater" ] = 0,
  [ "forcecenter"  ] = 0,
  [ "frozen"       ] = 1 -- The cold never bothered me anyway
}

LaserLib.SetupModels()
LaserLib.SetupMaterials()
LaserLib.SetupSoundEffects()
LaserLib.SetupDissolveTypes()

cleanup.Register(gsUnit.."s")

--[[
Applies the final posutional and angular offsets to the laser spawned
Adjusts the custom model angle and calculates the touch position
 * ent   > The laser entity to preform the operation for
 * trace > The trace that player is aiming for
]]
function TOOL:ApplySpawn(ent, trace)
  local ang = self:GetClientNumber("angleoffset")
  LaserLib.SnapNormal(ent, trace.HitPos, trace.HitNormal, ang)
end

function TOOL:LeftClick(trace)
  if(CLIENT) then return true end
  if(not trace.HitPos) then return false end
  if(trace.Entity:IsPlayer()) then return false end
  if(not self:GetSWEP():CheckLimit(gsUnit.."s")) then return false end

  local key          = self:GetClientNumber("key")
  local width        = self:GetClientNumber("width")
  local length       = self:GetClientNumber("length")
  local damage       = self:GetClientNumber("damage")
  local pushforce    = self:GetClientNumber("pushforce")
  local model        = self:GetClientInfo("model")
  local material     = self:GetClientInfo("material")
  local stopsound    = self:GetClientInfo("stopsound")
  local killsound    = self:GetClientInfo("killsound")
  local startsound   = self:GetClientInfo("startsound")
  local dissolvetype = self:GetClientInfo("dissolvetype")
  local angleoffset  = self:GetClientNumber("angleoffset")
  local toggle       = (self:GetClientNumber("toggle") ~= 0)
  local frozen       = (self:GetClientNumber("frozen") ~= 0)
  local starton      = (self:GetClientNumber("starton") ~= 0)
  local worldweld    = (self:GetClientNumber("worldweld") ~= 0)
  local reflectrate  = (self:GetClientNumber("reflectrate") ~= 0)
  local refractrate  = (self:GetClientNumber("refractrate") ~= 0)
  local endingeffect = (self:GetClientNumber("endingeffect") ~= 0)
  local forcecenter  = (self:GetClientNumber("forcecenter") ~= 0)
  local enonvermater = (self:GetClientNumber("enonvermater") ~= 0)
  local ply, ent     = self:GetOwner(), trace.Entity
  local pos, ang     = trace.HitPos   , trace.HitNormal:Angle()

  if(ent:IsValid() and
     ent:GetClass() == gsLaseremCls)
  then
    LaserLib.Notify(ply, "Paste settings !", "UNDO")
    ent:Setup(width       , length     , damage     , material    ,
              dissolvetype, startsound , stopsound  , killsound   ,
              toggle      , starton    , pushforce  , endingeffect,
              reflectrate , refractrate, forcecenter, enonvermater, true)
    return true
  end

  local laser = LaserLib.New(ply        , pos         , ang         , model       ,
                             angleoffset, key         , width       , length      ,
                             damage     , material    , dissolvetype, startsound  ,
                             stopsound  , killsound   , toggle      , starton     ,
                             pushforce  , endingeffect, reflectrate , refractrate ,
                             forcecenter, frozen      , enonvermater)

  if(not (laser and laser:IsValid())) then return false end

  self:ApplySpawn(laser, trace)

  undo.Create("LaserEmitter")
    undo.AddEntity(laser)
    if(ent:IsValid() or worldweld) then
      local weld = constraint.Weld(laser, ent, trace.PhysicsBone, 0, 0)
      if(weld and weld:IsValid()) then
        undo.AddEntity(weld) -- Inser the weld in the undo list
        laser:DeleteOnRemove(weld) -- Remove the weld with the laser
        ent:DeleteOnRemove(weld) -- Remove weld with the anchor
      end
    end
    undo.SetPlayer(ply)
  undo.Finish()

  LaserLib.Notify(ply, "Laser created !", "GENERIC")
  ply:AddCleanup(gsUnit.."s", laser)

  return true
end

function TOOL:RightClick(trace)
  if(CLIENT) then return true end
  if(not trace) then return false end
  local ply, ent = self:GetOwner(), trace.Entity

  if(not ent) then return false end
  if(not ent:IsValid()) then return false end

  if(ent:GetClass() == gsLaseremCls) then
    LaserLib.ConCommand(ply, "width"       , ent:GetBeamWidth())
    LaserLib.ConCommand(ply, "length"      , ent:GetBeamLength())
    LaserLib.ConCommand(ply, "damage"      , ent:GetDamageAmount())
    LaserLib.ConCommand(ply, "material"    , ent:GetBeamMaterial())
    LaserLib.ConCommand(ply, "dissolvetype", ent:GetDissolveType())
    LaserLib.ConCommand(ply, "startsound"  , ent:SetStartSound())
    LaserLib.ConCommand(ply, "stopsound"   , ent:SetStopSound())
    LaserLib.ConCommand(ply, "killsound"   , ent:GetKillSound())
    LaserLib.ConCommand(ply, "pushforce"   , ent:GetPushForce())
    LaserLib.ConCommand(ply, "starton"     , (ent:GetOn() and 1 or 0))
    LaserLib.ConCommand(ply, "toggle"      , (ent:GetStartToggle() and 1 or 0))
    LaserLib.ConCommand(ply, "forcecenter" , (ent:GetForceCenter() and 1 or 0))
    LaserLib.ConCommand(ply, "endingeffect", (ent:GetEndingEffect() and 1 or 0))
    LaserLib.ConCommand(ply, "reflectrate" , (ent:GetReflectRatio() and 1 or 0))
    LaserLib.ConCommand(ply, "refractrate" , (ent:GetRefractRatio() and 1 or 0))
    LaserLib.ConCommand(ply, "enonvermater", (ent:GetInNonOverMater() and 1 or 0))
    LaserLib.Notify(ply, "Copy settings !", "UNDO")
  else
    local ang = math.atan2(math.Round(trace.HitNormal:Dot(ent:GetUp()), 3),
                           math.Round(trace.HitNormal:Dot(ent:GetForward()), 3))
    local mod, ang = ent:GetModel(), math.deg(ang)
    LaserLib.ConCommand(ply, "model", mod)
    LaserLib.ConCommand(ply, "angleoffset", ang)
    LaserLib.Notify(ply, "Pick: "..mod.." ["..ang.."]", "UNDO")
    if(ply:KeyDown(IN_SPEED)) then -- Easy export export
      print("table.insert(data, {\""..mod.."\","..ang.."})")
    end
  end

  return true
end

function TOOL:Reload(trace)
  if(CLIENT) then return true end
  if(not trace) then return false end
  local ply, ent = self:GetOwner(), trace.Entity
  if(trace.HitWorld) then
    if(ply:KeyDown(IN_USE)) then
      LaserLib.ConCommand(ply, "openmaterial", "refract")
    elseif(ply:KeyDown(IN_SPEED)) then
      LaserLib.ConCommand(ply, "openmaterial", "reflect")
    end
  else
    if(not trace.Entity)  then return false end
    if(not ent:IsValid())  then return false end
    if(ent:IsPlayer()) then return false end
    if(ply:KeyDown(IN_USE)) then
      LaserLib.SetMaterial(ent, self:GetClientInfo("refractused"))
    elseif(ply:KeyDown(IN_SPEED)) then
      LaserLib.SetMaterial(ent, self:GetClientInfo("reflectused"))
    else
      LaserLib.SetMaterial(ent)
    end
  end

  return true
end

if(SERVER) then
  duplicator.RegisterEntityClass(gsLaseremCls, LaserLib.New     ,
    --[[  ply  ]]  "pos"         , "ang"         , "model"      ,
    "angleOffset", "key"         , "width"       , "length"     ,
    "damage"     , "material"    , "dissolveType", "startSound" ,
    "stopSound"  , "killSound"   , "toggle"      , "startOn"    ,
    "pushForce"  , "endingEffect", "reflectRate" , "refractRate",
    "forceCenter", "frozen"      , "enOnverMater")
end

function TOOL:UpdateGhostLaserEmitter(ent, ply)
  if(not ent) then return end
  if(not ply) then return end
  if(ent:IsPlayer()) then return end
  if(not ent:IsValid()) then return end
  if(not ply:IsValid()) then return end
  if(not ply:IsPlayer()) then return end

  local trace = ply:GetEyeTrace()

  self:ApplySpawn(ent, trace)

  if(not trace.Hit or
         trace.Entity:IsPlayer() or
         trace.Entity:GetClass() == gsLaseremCls)
  then
    ent:SetNoDraw(true)
    return
  end

  ent:SetNoDraw(false)
end

function TOOL:Think()
  local model = self:GetClientInfo("model")

  if(not self.GhostEntity or
     not self.GhostEntity:IsValid() or
         self.GhostEntity:GetModel() ~= model)
  then
    local pos, ang = LaserLib.GetZeroTransform()
    self:MakeGhostEntity(model, pos, ang)
  end

  self:UpdateGhostLaserEmitter(self.GhostEntity, self:GetOwner())
end

local gtConvarList = TOOL:BuildConVarList()

-- Enter `spawnmenu_reload` in the console to reload the panel
function TOOL.BuildCPanel(panel) local pItem, pName, vData
  panel:ClearControls(); panel:DockPadding(5, 0, 5, 10)
  panel:SetName(language.GetPhrase("tool."..gsUnit..".name"))
  panel:Help   (language.GetPhrase("tool."..gsUnit..".desc"))

  pItem = vgui.Create("ControlPresets", panel)
  pItem:SetPreset(gsUnit)
  pItem:AddOption("Default", gtConvarList)
  for key, val in pairs(table.GetKeys(gtConvarList)) do pItem:AddConVar(val) end
  panel:AddItem(pItem)

  pItem = vgui.Create("CtrlNumPad", panel)
  pItem:SetConVar1(gsUnit.."_key")
  pItem:SetLabel1(language.GetPhrase("tool."..gsUnit..".key_con"))
  pItem.NumPad1:SetTooltip(language.GetPhrase("tool."..gsUnit..".key"))
  panel:AddPanel(pItem)

  pItem = panel:NumSlider(language.GetPhrase("tool."..gsUnit..".width_con"), gsUnit.."_width", 1, 30, 5)
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".width"))
  pItem = panel:NumSlider(language.GetPhrase("tool."..gsUnit..".length_con"), gsUnit.."_length", 0, 50000, 5)
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".length"))
  pItem = panel:NumSlider(language.GetPhrase("tool."..gsUnit..".damage_con"), gsUnit.."_damage", 0, 5000, 5)
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".damage"))
  pItem = panel:NumSlider(language.GetPhrase("tool."..gsUnit..".pushforce_con"), gsUnit.."_pushforce", 0, 50000, 5)
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".pushforce"))
  pItem = panel:MatSelect(gsUnit.."_material", list.GetForEdit("LaserEmitterMaterials"), true, 0.15, 0.24)
  pItem.Label:SetText(language.GetPhrase("tool."..gsUnit..".material_con"))
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".material"))

  pItem = vgui.Create("PropSelect", panel)
  pItem:Dock(TOP); pItem:SetTall(150)
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".model"))
  pItem:ControlValues({
    models = list.GetForEdit("LaserEmitterModels"),
    label  = language.GetPhrase("tool."..gsUnit..".model_con")
  }); panel:AddItem(pItem)

  LaserLib.ComboBoxString(panel, "dissolvetype", "LaserDissolveTypes")
  LaserLib.ComboBoxString(panel, "startsound"  , "LaserStartSounds"  )
  LaserLib.ComboBoxString(panel, "stopsound"   , "LaserStopSounds"   )
  LaserLib.ComboBoxString(panel, "killsound"   , "LaserKillSounds"   )

  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".worldweld_con"), gsUnit.."_worldweld")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".worldweld"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".frozen_con"), gsUnit.."_frozen")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".frozen"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".toggle_con"), gsUnit.."_toggle")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".toggle"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".starton_con"), gsUnit.."_starton")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".starton"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".endingeffect_con"), gsUnit.."_endingeffect")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".endingeffect"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".reflectrate_con"), gsUnit.."_reflectrate")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".reflectrate"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".refractrate_con"), gsUnit.."_refractrate")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".refractrate"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".forcecenter_con"), gsUnit.."_forcecenter")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".forcecenter"))
  pItem = panel:CheckBox(language.GetPhrase("tool."..gsUnit..".enonvermater_con"), gsUnit.."_enonvermater")
  pItem:SetTooltip(language.GetPhrase("tool."..gsUnit..".enonvermater"))
end
