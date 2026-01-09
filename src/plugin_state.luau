local charm = require("@pkgs/charm")

-- Function Alias
local atom = charm.atom

local state = {
	isPlaying = atom(false),
	enabled = atom(false),
	selectedCutscene = atom(nil) :: charm.Atom<string>,
}

return state
