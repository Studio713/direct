local RunService = game:GetService('RunService')
local timeline = require(script.Parent.timeline)
local plugin_state = require(script.Parent.Parent.plugin_state)
local save_utility = require(script.Parent.Parent.utilities.save_utility)
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

print(save_utility.getSave('test_cutscene'))

return playback
