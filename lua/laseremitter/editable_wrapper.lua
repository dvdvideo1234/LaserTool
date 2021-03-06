ENT.EditableOrderInfo = {Ord = 0, Typ = {}}

function ENT:EditableGetOrderID(typ)
  local data = self.EditableOrderInfo
  if(not data.Typ[typ]) then data.Typ[typ] = 0
  else data.Typ[typ] = data.Typ[typ] + 1 end
  data.Ord = data.Ord + 1
  return typ, data.Ord, data.Typ[typ]
end

function ENT:EditableSetVector(name, catg)
  local typ, ord, id = self:EditableGetOrderID("Vector")
  self:NetworkVar(typ, id, name, {
    KeyName = name:lower(),
    Edit = {
      category = catg,
      order    = ord,
      type     = typ
    }})
end

function ENT:EditableSetVectorColor(name, catg, min, max)
  local typ, ord, id = self:EditableGetOrderID("Vector")
  self:NetworkVar(typ, id, name, {
    KeyName = name:lower(),
    Edit = {
      category = catg,
      order    = ord,
      type     = typ.."Color"
    }})
end

function ENT:EditableSetBool(name, catg)
  local typ, ord, id = self:EditableGetOrderID("Bool")
  self:NetworkVar(typ, id, name, {
    KeyName = name:lower(),
    Edit = {
      category = catg,
      order    = ord,
      type     = typ
    }})
end

function ENT:EditableSetFloat(name, catg, min, max)
  local typ, ord, id = self:EditableGetOrderID("Float")
  self:NetworkVar(typ, id, name, {
    KeyName = name:lower(),
    Edit = {
      category = catg,
      order    = ord,
      type     = typ,
      min      = (tonumber(min) or -100),
      max      = (tonumber(max) or  100)
    }})
end

function ENT:EditableSetComboString(name, catg, vals, key)
  local val = vals -- Use provided values unless a table
  local typ, ord, id = self:EditableGetOrderID("String")
  if(key) then val = {} -- Allocate
    for k, v in pairs(vals) do
      val[k] = v[key] -- Populate
    end -- Produce proper ke-value pairs
  end -- When list value is a table
  self:NetworkVar(typ, id, name, {
    KeyName = name:lower(),
    Edit = {
      category = catg,
      order    = ord,
      type     = "Combo",
      values   = val
    }})
end
