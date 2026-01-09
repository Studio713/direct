local RunService = game:GetService("RunService")
local timeline = require("@core/timeline")
local plugin_state = require("@src/plugin_state")
local save_utility = require("@src/utilities/save_utility")

local playback = {}

local function startPlayback()
	plugin_state.isPlaying(true)
end

local function stopPlayback()
	plugin_state.isPlaying(false)
end

function playback.play()
	if plugin_state.isPlaying() then
		stopPlayback()
	else
		startPlayback()
	end
end

-- RunService.Heartbeat:Connect(function()
-- local currentTimeline = timeline.getTimeline()
-- end)

-- print(save_utility.getSave("test_cutscene"):save())
print(save_utility.getSave("test_cutscene"))

return playback
