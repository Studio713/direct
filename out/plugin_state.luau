local charm = require(script.Parent.packages.charm)
local atom = charm.atom
local state = {
    isPlaying = atom(false),
    enabled = atom(false),
    selectedCutscene = (atom(nil)),
    loadedCutscene = (atom(nil)),
    cutsceneEnvironment = (atom(nil)),
    currentFrame = atom(0),
}

return state
