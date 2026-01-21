local playback = require("@core/playback")
local vide = require("@pkgs/vide")
local vide_charm = require("@pkgs/vide-charm")
local plugin_state = require("@src/plugin_state")
local save_utility = require("@src/utilities/save_utility")
local adjustable_divider = require("@ui/components/shared/adjustable_divider")

-- Function Alias
local scale = UDim2.fromScale
local create = vide.create
local mount = vide.mount
local source = vide.source
local changed = vide.changed
local useSignal = vide_charm.useSignalState

local function app(props: AppProps)
	local loadedTimeline = useSignal(plugin_state.loadedCutscene)
	local currentFrame = useSignal(plugin_state.currentFrame)

	local shrink = source(2)
	local isPlaying = source(false)

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
							Text = function()
								local timeline = loadedTimeline()
								if not timeline then
									return ""
								end

								return `{timeline.id}`
							end,
							PlaceholderText = "Select a Timeline",
							TextSize = 20,
							TextXAlignment = Enum.TextXAlignment.Left,
							ClipsDescendants = true,
							changed("Text", function(text)
								local timeline = plugin_state.loadedCutscene()
								if timeline then
									local save = save_utility.getSave(timeline.id)
									if not save then
										return
									end
									save_utility.removeSave(timeline.id)
									timeline.id = text
									save:save()
								end
							end),
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

						Activated = function()
							props.menu:ShowAsync()
						end,

						create("UIAspectRatioConstraint")({}),
					}),
				}),
				create("ImageButton")({
					-- Play Button
					Name = "PlayButtonContainer",
					BackgroundColor3 = Color3.fromRGB(125, 255, 160),
					Size = scale(0.2, 1),

					Activated = function()
						if not loadedTimeline() then
							return
						end

						if not isPlaying() then
							isPlaying(true)
							playback.start()
						else
							isPlaying(false)
							playback.stop()
						end
					end,

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
					create("UIListLayout")({
						FillDirection = Enum.FillDirection.Horizontal,
					}),
					-- create("UIPadding")({
					-- 	PaddingRight = UDim.new(0, 5),
					-- }),

					create("TextBox")({
						Text = function()
							return `{currentFrame()}`
						end,
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Right,
						Size = scale(0.5, 1),
					}),
					create("TextLabel")({
						Text = function()
							return `/ {3600}`
						end,
						TextScaled = true,
						Size = scale(0.5, 1),
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

local function mountApp(parent: Instance, props: AppProps)
	return mount(function()
		return app(props)
	end, parent)
end

return mountApp
