local RunService = game:GetService("RunService")
local TouchInputService = game:GetService("TouchInputService")

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

local function makeActionsFromSaves(menu: PluginMenu, actionCleaner: janitor.Janitor)
	actionCleaner:Cleanup()

	local saves = save_utility.getSaves()
	for name, save in saves do
		save:reload()

		local action = plugin:CreatePluginAction(`save_{name}`, name, `Load {name}`)
		action.Name = name
		menu:AddAction(action)
		actionCleaner:Add(action.Triggered:Connect(function()
			plugin_state.selectedCutscene(name)
		end))
		actionCleaner:Add(action)
		save.module:GetPropertyChangedSignal("Source"):Once(function()
			makeActionsFromSaves(menu, actionCleaner)
		end)
	end
end

function main()
	local pluginCleaner = janitor.new()
	local actionCleaner = janitor.new()
	save_utility.loadSaves()

	plugin.Unloading:Once(function()
		pluginCleaner:Destroy()
	end)

	local toolbar = plugin:CreateToolbar("Direct")
	local button = toolbar:CreateButton("direct", "Open Cutscene Director", "", "Direct")
	local menu = plugin:CreatePluginMenu("direct", "Direct", "")

	local saveAction = plugin:CreatePluginAction("save", "Save", "Save a timeline")
	local load = plugin:CreatePluginMenu("Load", "Load")

	makeActionsFromSaves(load, actionCleaner)

	menu:AddMenu(load)
	menu:AddAction(saveAction)

	pluginCleaner:Add(saveAction.Triggered:Connect(function()
		if plugin_state.loadedCutscene() then
			local save = save_utility.getSave(plugin_state.loadedCutscene().id)
			if save then
				save_utility.removeSave(save.data.id)
				save:save()
			end
		end
	end))

	local widget = makeDockWidget()

	pluginCleaner:Add(mount_app(widget, {
		toolbar = toolbar,
		button = button,
		menu = menu,
	}))

	pluginCleaner:Add(button.Click:Connect(function()
		local enabled = plugin_state.enabled()

		plugin_state.enabled(not enabled)
	end))

	pluginCleaner:Add(RunService.Heartbeat:Connect(function()
		local camera = workspace.CurrentCamera

		if not plugin_state.isPlaying() then
			camera.CameraType = Enum.CameraType.Custom
			return
		end

		local tl = plugin_state.loadedCutscene()
		if not tl then
			camera.CameraType = Enum.CameraType.Custom
			return
		end
		camera.CameraType = Enum.CameraType.Scriptable

		local env = plugin_state.cutsceneEnvironment()
		local frame = plugin_state.currentFrame()

		if frame >= tl.length then
			playback.stop()
			plugin_state.currentFrame(0)
			return
		end

		local evaluation = evaluator.evaluate(tl, frame)
		if evaluation then
			env:apply(evaluation)
			plugin_state.currentFrame(frame + 1)
		end
	end))

	pluginCleaner:Add(subscribe(plugin_state.enabled, function(enabled)
		button:SetActive(enabled)
		widget.Enabled = enabled
	end))

	pluginCleaner:Add(subscribe(plugin_state.selectedCutscene, function(cutscene)
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

	-- Testing
	print("Successfully built plugin")
end

main()
