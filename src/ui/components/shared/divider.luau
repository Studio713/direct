local vide = require("@pkgs/vide")

-- Function Alias
local create = vide.create

local function divider(props: DividerProps)
	local dividerSize = 5

	local size = if props.size
		then props.size
		elseif props.direction == "vertical" then UDim2.new(0, dividerSize, 1, 0)
		else UDim2.new(1, 0, 0, dividerSize)

	return create("Frame")({
		Name = "Divider",
		LayoutOrder = props.order,
		BackgroundColor3 = props.color,
		Size = size,

		table.unpack(props),
	})
end

return divider
