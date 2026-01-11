local ReflectionService = game:GetService("ReflectionService")
local instance_utility = require("@src/utilities/instance_utility")
local environment = {} :: EnvironmentImpl
environment.__index = environment

local function applyMetatable<T>(input: T): Environment
	return setmetatable(input, environment)
end

local function resolvePath(path: string): Instance
	local segments = path:split("/")
	local current: Instance = game

	for _, name in segments do
		local child = current:FindFirstChild(name)
		if not child then
			error(("Path resolution failed: %s (missing %s)"):format(path, name))
		end

		current = child
	end

	return current
end

function environment.new(actors)
	local env = {} :: EnvironmentData

	env.instances = {}
	env.cleanup = {}

	for _, actor in actors do
		local obj

		if actor.binding.type == "Existing" then
			obj = resolvePath(actor.binding.path)
		else
			local template = resolvePath(actor.binding.path)
			obj = template:Clone()
			obj.Parent = workspace
		end

		env.instances[obj.Name] = obj
		table.insert(env.cleanup, obj)
	end

	local self = applyMetatable(env)

	return self
end

function environment.apply(self: Environment, frame: DirectFrame)
	for targetId, properties in frame.targets do
		local instance = self.instances[targetId]
		if not instance then
			continue
		end

		for property, value in properties do
			instance_utility.safelyApplyProperty(instance, property :: never, value :: never)
		end
	end
end

function environment.destroy(self: Environment)
	for _, obj in self.cleanup do
		if typeof(obj) == "Instance" then
			obj:Destroy()
		end
	end
end

return environment
