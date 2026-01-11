local ServerStorage = game:GetService("ServerStorage")

local vide = require("@pkgs/vide")
local save_template = require("@templates/save_template")

-- Function Alias
local create = vide.create

local DIRECT_PLUGIN_SAVES = "direct_cutscenes_saves"

local saveFile = {} :: SaveImpl
saveFile.__index = saveFile

local function serialize(value, indent: number?): string
	indent = indent or 0
	local pad = string.rep("\t", indent)

	if typeof(value) == "table" then
		local out = "{\n"
		for k, v in value do
			local key = if typeof(k) == "string" and k:match("^[%a_][%w_]*$") then k else `[{serialize(k)}]`

			out = `{out}{pad}\t{key} = {serialize(v, indent + 1)},\n`
		end
		return `{out}{pad}}`
	elseif typeof(value) == "string" then
		return string.format("%q", value)
	elseif typeof(value) == "number" or typeof(value) == "boolean" then
		return tostring(value)
	else
		error(`Cannot serialize value of type {typeof(value)}`)
	end
end

function saveFile.new(module: ModuleScript): Save
	local self = setmetatable({}, saveFile)

	self.data = (require :: any)(module) :: SaveData
	self.module = module

	return self
end

function saveFile.save(self: Save)
	local luaSource = "return " .. serialize(self.data)

	self.module.Source = luaSource
end

local utility = {}

local cache: Saves = {}

local function createSavesFolder()
	return create("Folder")({
		Name = DIRECT_PLUGIN_SAVES,
		Parent = ServerStorage,
	})
end

local function getSavesFolder()
	local saves = ServerStorage:FindFirstChild(DIRECT_PLUGIN_SAVES)

	if not saves then
		saves = createSavesFolder()
	end

	return saves
end

local function createSave(name: string)
	local saves = getSavesFolder()

	local newSaveFile = create("ModuleScript")({
		Name = name,
		Source = save_template.defaultSaveFile,
		Parent = saves,
	})

	local save = saveFile.new(newSaveFile)

	cache[name] = save

	return save
end

function utility.saveExists(name: string)
	return cache[name] ~= nil
end

function utility.getSaves(): Saves
	return cache
end

function utility.getSave(name: string)
	local saves = utility.getSaves()
	local save = saves[name]

	if not save then
		save = createSave(name)
	end

	return save
end

function utility.loadSaves()
	local saves = getSavesFolder()

	for _, module in (saves :: Instance):GetChildren() do
		if not module:IsA("ModuleScript") then
			continue
		end
		if cache[module.Name] then
			continue
		end
		cache[module.Name] = saveFile.new(module)
	end
end

return utility
