local plugin_state = require(script.Parent.Parent.plugin_state)
local save_utility = require(script.Parent.Parent.utilities.save_utility)
local timeline = {}

timeline.__index = timeline

local function createTimeline(createFile)
    local self = setmetatable({}, timeline)

    if createFile then
        save_utility.save(self)
    end

    self.actors = {}
    self.tracks = {}
    self.id = 'unnamed'
    self.length = 60

    return self
end

function timeline.new()
    local tl = createTimeline(true)

    plugin_state.selectedCutscene(tl.id)

    return tl
end
function timeline.load(name)
    local tl = createTimeline(false)

    plugin_state.selectedCutscene(name)

    return tl
end

return timeline
