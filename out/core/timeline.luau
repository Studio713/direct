local save_utility = require(script.Parent.Parent.utilities.save_utility)
local timeline = {}

timeline.__index = timeline

local function applyMetatable(tl)
    local self = setmetatable(tl, timeline)

    return self
end
local function createTimeline(createFile)
    local tl = {}

    tl.actors = {}
    tl.id = 'unnamed'
    tl.length = 60

    local self = applyMetatable(tl)

    if createFile then
        save_utility.getSave(self.id):save()
    end

    return self
end

function timeline.load(name)
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

    print('loaded timeline')

    return tl
end

return timeline
