local save_utility = require("@src/utilities/save_utility")

local timeline = {} :: TimelineImpl
timeline.__index = timeline

local function applyMetatable(tl: SaveData): Timeline
	local self = setmetatable(tl, timeline)
	return self
end

local function createTimeline(createFile: boolean): Timeline
	local tl = {}

	tl.actors = {}
	tl.id = "unnamed"
	tl.length = 60

	local self = applyMetatable(tl :: SaveData)

	if createFile then
		save_utility.getSave(self.id):save()
	end

	return self
end

function timeline.load(name: string?)
	local tl

	if not name then
		return createTimeline(true)
	end

	if save_utility.saveExists(name) then
		local save = save_utility.getSave(name)
		tl = applyMetatable(save.data)
	else
		tl = createTimeline(true)
	end

	print("loaded timeline")
	return tl
end

return timeline
