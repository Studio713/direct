local plugin_state = require("@src/plugin_state")

local playback = {}

local function startPlayback()
	plugin_state.isPlaying(true)
end

local function stopPlayback()
	plugin_state.isPlaying(false)
end

playback.start = startPlayback
playback.stop = stopPlayback

return playback
