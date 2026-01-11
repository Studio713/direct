export type EasingStyle = "Linear"

export type EasingDirection = "In" | "Out" | "InOut"

export type InterpolationMode = "Linear" | "Step"

export type InterpolationType = number | Vector3 | CFrame

export type ModifiableProperties = "CFrame" | "Position" | "Rotation"

export type DirectFrame = {
	time: number,
	targets: {
		[string]: Target,
	},
}

export type Target = {
	[string]: InterpolationType,
}

export type DirectActor = {
	id: string,
	name: string,

	binding: {
		type: "Existing" | "Spawn", -- Existing uses the object while Spawn clones the object
		path: string, -- Asset path
	},

	track: { Track },
}

export type Keyframe<T = InterpolationType> = {
	time: number, -- Seconds from timeline start
	value: T, -- Track-defined payload
}

export type Track = {
	property: ModifiableProperties,
	easingStyle: EasingStyle,
	easingDirection: EasingDirection,
	keyframes: { Keyframe },
	interpolation: InterpolationMode,
}

export type TimelineImpl = {
	__index: TimelineImpl,
	new: () -> Timeline,
	load: (name: string) -> Timeline,
}
export type Timeline = setmetatable<SaveData, TimelineImpl>

export type SaveData = {
	actors: { [string]: DirectActor },
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

export type EnvironmentData = {
	instances: { [string]: Instance },
	cleanup: { Instance },
}
export type EnvironmentImpl = {
	__index: EnvironmentImpl,
	new: (actors: { [string]: DirectActor }) -> Environment,
	apply: (self: Environment, frame: DirectFrame) -> (),
	destroy: (self: Environment) -> (),
}
export type Environment = setmetatable<EnvironmentData, EnvironmentImpl>

return nil
