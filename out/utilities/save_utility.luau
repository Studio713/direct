local ServerStorage = game:GetService('ServerStorage')
local vide = require(script.Parent.Parent.packages.vide)
local save_template = require(script.Parent.Parent.templates.save_template)
local create = vide.create
local DIRECT_PLUGIN_SAVES = 'direct_cutscenes_saves'
local saveFile = {}

saveFile.__index = saveFile

local function serialize(value, indent)
    indent = indent or 0

    local pad = string.rep('\t', indent)

    if typeof(value) == 'table' then
        local out = '{\n'

        for k, v in value do
            local key = if typeof(k) == 'string' and k:match('^[%a_][%w_]*$')then k else`[{serialize(k)}]`

            out = `{out}{pad}\t{key} = {serialize(v, indent + 1)},\n`
        end

        return `{out}{pad}}`
    elseif typeof(value) == 'string' then
        return string.format('%q', value)
    elseif typeof(value) == 'number' or typeof(value) == 'boolean' then
        return tostring(value)
    else
        error(`Cannot serialize value of type {typeof(value)}`)
    end
end

function saveFile.new(module)
    local self = setmetatable({}, saveFile)

    self.data = ((require)(module))
    self.module = module

    return self
end
function saveFile.save(self)
    local luaSource = 'return ' .. serialize(self.data)

    self.module.Source = luaSource
end

local utility = {}
local cache = {}

local function getSavesFolder()
    local saves = ServerStorage:FindFirstChild(DIRECT_PLUGIN_SAVES)

    if not saves then
        saves = utility.createSavesFolder()
    end

    return saves
end
local function createSave(name)
    local saves = getSavesFolder()
    local newSaveFile = create('ModuleScript')({
        Name = name,
        Source = save_template.defaultSaveFile,
        Parent = saves,
    })
    local save = saveFile.new(newSaveFile)

    cache[name] = save

    return save
end

function utility.createSavesFolder()
    return create('Folder')({
        Name = DIRECT_PLUGIN_SAVES,
        Parent = ServerStorage,
    })
end
function utility.getSaves()
    local saves = getSavesFolder()

    for _, module in (saves):GetChildren()do
        if not module:IsA('ModuleScript') then
            continue
        end
        if cache[module.Name] then
            continue
        end

        cache[module.Name] = saveFile.new(module)
    end

    return cache
end
function utility.getSave(name)
    local saves = utility.getSaves()
    local save = saves[name]

    if not save then
        save = createSave(name)
    end

    return save
end
function utility.save(timeline) end

return utility
