local RunService = game:GetService("RunService")

local environment = require("@core/environment")
local evaluator = require("@core/evaluator")
local playback = require("@core/playback")
local timeline = require("@core/timeline")
local charm = require("@pkgs/charm")
local janitor = require("@pkgs/janitor")
local plugin_state = require("@src/plugin_state")
local save_utility = require("@src/utilities/save_utility")
local mount_app = require("@ui/mount_app")

-- Function Alias
local subscribe = charm.subscribe

local function makeDockWidget()
	local initialDockState = Enum.InitialDockState.Bottom
	local initEnabled = false
	local overriedEnabledRestore = false
	local floatXSize = 1000
	local floatYSize = 400
	local minWidth = 300
	local minHeight = 100

	local widgetInfo = DockWidgetPluginGuiInfo.new(
		initialDockState,
		initEnabled,
		overriedEnabledRestore,
		floatXSize,
		floatYSize,
		minWidth,
		minHeight
	)

	local widget = plugin:CreateDockWidgetPluginGuiAsync("direct", widgetInfo)

	widget.Name = "Direct"
	widget.Title = "Direct"

	return widget
end

function main()
	local cleaner = janitor.new()

	plugin.Unloading:Once(function()
		cleaner:Destroy()
	end)

	local toolbar = plugin:CreateToolbar("Direct")
	local button = toolbar:CreateButton("direct", "Open Cutscene Director", "", "Direct")

	local widget = makeDockWidget()

	cleaner:Add(mount_app(widget))

	cleaner:Add(button.Click:Connect(function()
		local enabled = plugin_state.enabled()

		plugin_state.enabled(not enabled)
	end))

	cleaner:Add(RunService.Heartbeat:Connect(function()
		if not plugin_state.isPlaying() then
			return
		end

		local tl = plugin_state.loadedCutscene()
		if not tl then
			return
		end

		local env = plugin_state.cutsceneEnvironment()
		local frame = plugin_state.currentFrame()

		if frame >= tl.length then
			playback.stop()
			return
		end

		local evaluation = evaluator.evaluate(tl, frame)
		if evaluation then
			env:apply(evaluation)
			plugin_state.currentFrame(frame + 1)
		end
	end))

	cleaner:Add(subscribe(plugin_state.enabled, function(enabled)
		button:SetActive(enabled)
		widget.Enabled = enabled
	end))

	cleaner:Add(subscribe(plugin_state.selectedCutscene, function(cutscene)
		local prevEnv = plugin_state.cutsceneEnvironment()
		if prevEnv then
			prevEnv:destroy()
		end

		local tl = timeline.load(cutscene)
		local env = environment.new(tl.actors)

		plugin_state.currentFrame(0)
		plugin_state.loadedCutscene(tl)
		plugin_state.cutsceneEnvironment(env)
	end))

	save_utility.loadSaves()

	-- Testing
	plugin_state.selectedCutscene("test_cutscene")
	print("Successfully built plugin")
end

main()
