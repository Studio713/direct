local baseEase: { [string]: (number) -> number } = {
	Linear = function(t: number)
		return t
	end,
	Quad = function(t: number)
		return t ^ 2
	end,
	Cubic = function(t: number)
		return t ^ 3
	end,
	Quart = function(t: number)
		return t ^ 4
	end,
	Quint = function(t: number)
		return t ^ 5
	end,

	Sine = function(t: number)
		return 1 - math.cos((t * math.pi) / 2)
	end,
	Expo = function(t: number)
		return if t == 0 then 0 else 2 ^ (10 * (t - 1))
	end,
	Circ = function(t: number)
		return 1 - math.sqrt(1 - t ^ 2)
	end,
	Back = function(t: number)
		local s = 1.70158
		return t ^ 3 - t * s * math.sin(t * math.pi)
	end,
	Elastic = function(t: number)
		if t == 0 or t == 1 then
			return t
		end
		return -2 ^ (10 * (t - 1)) * math.sin((t - 1.075) * (2 * math.pi) / 0.3)
	end,
	Bounce = function(t: number)
		local n1, d1 = 7.5625, 2.75
		if t < 1 / d1 then
			return n1 * t * t
		elseif t < 2 / d1 then
			t -= 1.5 / d1
			return n1 * t * t + 0.75
		elseif t < 2.5 / d1 then
			t -= 2.25 / d1
			return n1 * t * t + 0.9375
		else
			t -= 2.625 / d1
			return n1 * t * t + 0.984375
		end
	end,
}

local utility = {}

local function applyEasingDirection(t: number, curveFn: (number) -> number, direction: EasingDirection)
	if direction == "In" then
		return curveFn(t)
	elseif direction == "Out" then
		return 1 - curveFn(1 - t)
	elseif direction == "InOut" then
		if t < 0.5 then
			return curveFn(t * 2) * 0.5
		else
			return 1 - curveFn((1 - t) * 2) * 0.5
		end
	end
	return t
end

function utility.ease(alpha: number, curve: EasingStyle?, direction: EasingDirection?)
	alpha = math.clamp(alpha, 0, 1)
	local curveFn = baseEase[curve or "Linear"]
	local dir = direction or "In"
	return applyEasingDirection(alpha, curveFn, dir)
end

return utility
