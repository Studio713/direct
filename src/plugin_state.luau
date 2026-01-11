local charm = require("@pkgs/charm")

-- Function Alias
local atom = charm.atom

local state = {
	isPlaying = atom(false),
	enabled = atom(false),
	selectedCutscene = atom(nil) :: charm.Atom<string>,
	loadedCutscene = atom(nil) :: charm.Atom<Timeline>,
	cutsceneEnvironment = atom(nil) :: charm.Atom<Environment>,
	currentFrame = atom(0),
}

return state
