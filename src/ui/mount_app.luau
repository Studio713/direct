local vide = require("@pkgs/vide")
local adjustable_divider = require("@ui/components/shared/adjustable_divider")

-- Function Alias
local scale = UDim2.fromScale
local create = vide.create
local mount = vide.mount
local source = vide.source

local function app()
	local shrink = source(2)

	-- App needs to show timeline
	-- list of actors
	-- keyframes of actors across the timeline
	return create("Frame")({
		Name = "App",
		BackgroundTransparency = 1,
		Size = scale(1, 1),

		create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		adjustable_divider({
			direction = "vertical",
			source = shrink,
			min = 1.5,
			max = 3.5,
			order = 1,
			color = Color3.fromRGB(20, 20, 20),
		}),
		create("Frame")({
			Name = "ActorContainer",
			LayoutOrder = 0,
			BackgroundColor3 = Color3.fromRGB(206, 129, 25),
			Size = scale(1, 1),

			create("UIFlexItem")({
				FlexMode = Enum.UIFlexMode.Custom,
				ShrinkRatio = shrink,
			}),
			create("Frame")({
				-- needs playbutton
				-- the current frame
				Name = "Topbar",
				Size = UDim2.new(1, 0, 0, 25),

				create("UIListLayout")({
					FillDirection = Enum.FillDirection.Horizontal,
				}),
				create("UIStroke")({
					Thickness = 5,
					LineJoinMode = Enum.LineJoinMode.Miter,
				}),
				create("Frame")({
					-- Name/...
					Name = "TimelineTitleContainer",
					BackgroundColor3 = Color3.fromRGB(62, 52, 60),
					Size = scale(0.2, 1),

					create("UIListLayout")({
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 3),
					}),
					create("UIPadding")({
						PaddingLeft = UDim.new(0, 5),
					}),
					create("UIFlexItem")({
						FlexMode = Enum.UIFlexMode.Custom,
						GrowRatio = 2,
					}),
					create("Frame")({
						Name = "TextBoxContainer",
						Size = UDim2.new(0.8, 0, 0, 20),

						create("TextBox")({
							-- Text = "", -- current timeline
							PlaceholderText = "Select a Timeline",
							TextSize = 20,
							TextXAlignment = Enum.TextXAlignment.Left,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = scale(0.5, 0.5),
							Size = UDim2.new(1, -10, 1, 0),

							create("UIFlexItem")({
								FlexMode = Enum.UIFlexMode.Fill,
							}),
						}),
					}),
					create("ImageButton")({
						-- ... Button
						Size = scale(0.2, 1),

						create("UIAspectRatioConstraint")({}),
					}),
				}),
				create("ImageButton")({
					-- Play Button
					Name = "PlayButtonContainer",
					BackgroundColor3 = Color3.fromRGB(125, 255, 160),
					Size = scale(0.2, 1),

					create("UIAspectRatioConstraint")({}),
				}),
				create("Frame")({
					-- Scrubbing
					Name = "ScrubbingContainer",
					BackgroundColor3 = Color3.fromRGB(29, 123, 69),
					Size = UDim2.new(0, 75, 1, 0),

					create("UIFlexItem")({
						FlexMode = Enum.UIFlexMode.Custom,
						GrowRatio = 0.5,
					}),
				}),
			}),
		}),
		create("Frame")({
			Name = "TimelineContainer",
			LayoutOrder = 2,
			BackgroundColor3 = Color3.fromRGB(125, 203, 69),
			Size = scale(1, 1),
		}),
	})
end

local function mountApp(parent: Instance)
	return mount(app, parent)
end

return mountApp
