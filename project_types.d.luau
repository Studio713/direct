export type DirectActor = {
	id: string,
	name: string,

	binding: {
		type: "Existing" | "Spawn", -- Existing uses the object while Spawn clones the object
		path: string, -- Asset path
	},

	tracks: { string }, -- Track IDs
}

export type Keyframe<T = any> = {
	time: number, -- Seconds from timeline start
	value: T, -- Track-defined payload
}

export type Track = {
	id: string,

	type: "",

	keyframes: { Keyframe },
}

export type TimelineImpl = {
	__index: TimelineImpl,
	new: () -> Timeline,
	load: (name: string) -> Timeline,
}
export type Timeline = setmetatable<SaveData, TimelineImpl>

export type SaveData = {
	actors: { [string]: DirectActor }, -- Actor ID -> Actor
	tracks: { [string]: Track }, -- Track ID -> Track
	id: string,
	length: number,
}
export type SaveImpl = {
	__index: SaveImpl,
	new: (module: ModuleScript) -> Save,
	save: (self: Save) -> (),
}
export type Save = setmetatable<{
	data: SaveData,
	module: ModuleScript,
}, SaveImpl>

export type Saves = { [string]: Save }

return nil
