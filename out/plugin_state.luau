local charm = require(script.Parent.packages.charm)
local atom = charm.atom
local state = {
    isPlaying = atom(false),
    enabled = atom(false),
    selectedCutscene = (atom(nil)),
}

return state
