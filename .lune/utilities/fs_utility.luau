local fs = require("@lune/fs")
local task = require("@lune/task")

local fs_utility = {}

local function buildSnapshot(root: string)
	local snapshot = {}

	local function walk(dir: string)
		for _, entry in fs.readDir(dir) do
			local fullPath = `{dir}/{entry}`
			local stat = fs.metadata(fullPath)

			if not stat.exists then
				return
			end

			if stat.kind == "dir" then
				walk(fullPath)
			else
				snapshot[fullPath] = stat.modifiedAt
			end
		end
	end

	walk(root)
	return snapshot
end

local function diffSnapshots(old, new)
	for key, lastMod in old do
		if new[key] ~= lastMod then
			return true
		end
	end

	return false
end

function fs_utility.watch(directory: string, callback: () -> ())
	local snapshot = buildSnapshot(directory)

	while true do
		-- fs.metadata
		local nextSnapshot = buildSnapshot(directory)
		local diff = diffSnapshots(snapshot, nextSnapshot)

		if diff then
			snapshot = nextSnapshot
			callback()
		end

		task.wait(1)
	end
end

return fs_utility
