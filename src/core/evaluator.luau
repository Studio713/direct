local easing_utility = require("@src/utilities/easing_utility")
local evaluator = {}

local function clampTime(t: number, duration: number)
	if t < 0 then
		return 0
	elseif t > duration then
		return duration
	end
	return t
end

local function getSurroundingKeyframes(keyframes: { Keyframe }, time: number)
	local left = 1
	local right = #keyframes

	while left <= right do
		local mid = math.floor((left + right) * 0.5)

		if keyframes[mid].time < time then
			left += 1
		else
			right -= 1
		end
	end

	return keyframes[left - 1], keyframes[left]
end

local function interpolate(a: InterpolationType, b: InterpolationType, alpha: number, mode: InterpolationMode)
	if mode == "Step" then
		return a
	end

	if typeof(a) == "number" and typeof(b) == "number" then
		return a + (b - a) * alpha
	elseif typeof(a) == "Vector3" and typeof(b) == "Vector3" then
		return (a):Lerp(b, alpha)
	elseif typeof(a) == "CFrame" and typeof(b) == "CFrame" then
		return (a):Lerp(b, alpha)
	end

	error("Unsupported interpolation type")
end

local function evaluateTrack(track: Track, time: number): InterpolationType
	local keyframes = track.keyframes
	local count = #keyframes

	if count == 0 then
		return nil :: never
	end

	if time <= keyframes[1].time then
		return keyframes[1].value
	end

	if time >= keyframes[count].time then
		return keyframes[count].value
	end

	local keyframeA: Keyframe, keyframeB: Keyframe = getSurroundingKeyframes(keyframes, time)
	local rawAlpha = (time - keyframeA.time) / (keyframeB.time - keyframeA.time)
	local alpha = easing_utility.ease(rawAlpha, track.easingStyle, track.easingDirection)

	return interpolate(keyframeA.value, keyframeB.value, alpha, track.interpolation or "Linear")
end

function evaluator.evaluate(timeline: Timeline, time: number): DirectFrame
	local t = clampTime(time, timeline.length)

	local frame = {
		time = t,
		targets = {},
	}

	for _, actor in timeline.actors do
		for _, track in actor.track do
			local value = evaluateTrack(track, t)

			local target: { [string]: InterpolationType } = frame.targets[actor.id]
			if not target then
				target = {}
				frame.targets[actor.id] = target
			end

			target[track.property] = value
		end
	end

	return frame
end

evaluator.evaluateTrack = evaluateTrack

return evaluator
