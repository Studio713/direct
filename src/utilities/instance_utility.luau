local ReflectionService = game:GetService("ReflectionService")

local utility = {}

local cache = {}

local function getClassProps(class: string)
  if not cache[class] then
    local props = ReflectionService:GetPropertiesOfClass(class)

    local map = {}
    for _,prop in props do
      map[prop.Name] = true
    end
    cache[class] = map :: never
  end

  return cache[class]
end

function utility.safelyApplyProperty(instance: Instance, property: keyof<Instance>, value: index<Instance,keyof<Instance>>)
  local class = instance.ClassName
  local props = getClassProps(class)

  if props[property] then
    (instance :: any)[property] = value
  end
end



return utility
