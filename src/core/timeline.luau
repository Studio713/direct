local plugin_state = require("@src/plugin_state")
local save_utility = require("@src/utilities/save_utility")

local timeline = {} :: TimelineImpl
timeline.__index = timeline

local function createTimeline(createFile: boolean): Timeline
	local self = setmetatable({} :: SaveData, timeline)

	if createFile then
		save_utility.save(self)
	end

	self.actors = {}
	self.tracks = {}
	self.id = "unnamed"
	self.length = 60

	return self
end

function timeline.new(): Timeline
	local tl: Timeline = createTimeline(true)
	plugin_state.selectedCutscene(tl.id)
	return tl
end

function timeline.load(name: string)
	local tl: Timeline = createTimeline(false)
	plugin_state.selectedCutscene(name)
	return tl
end

return timeline
