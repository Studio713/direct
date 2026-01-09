local playback = require(script.core.playback)
local charm = require(script.packages.charm)
local plugin_state = require(script.plugin_state)
local subscribe = charm.subscribe

local function makeDockWidget()
    local initialDockState = Enum.InitialDockState.Bottom
    local initEnabled = false
    local overriedEnabledRestore = false
    local floatXSize = 1000
    local floatYSize = 400
    local minWidth = 300
    local minHeight = 100
    local widgetInfo = DockWidgetPluginGuiInfo.new(initialDockState, initEnabled, overriedEnabledRestore, floatXSize, floatYSize, minWidth, minHeight)
    local widget = plugin:CreateDockWidgetPluginGuiAsync('direct', widgetInfo)

    widget.Name = 'Direct'
    widget.Title = 'Direct'

    return widget
end

function main()
    local toolbar = plugin:CreateToolbar('Direct')
    local button = toolbar:CreateButton('direct', 'Open Cutscene Director', '', 'Direct')
    local widget = makeDockWidget()
    local playButton = Instance.new('TextButton')

    playButton.Size = UDim2.fromScale(1, 1)

    playButton.Activated:Connect(function()
        playback.play()
    end)

    playButton.Parent = widget

    button.Click:Connect(function()
        local enabled = plugin_state.enabled()

        plugin_state.enabled(not enabled)
    end)
    subscribe(plugin_state.enabled, function(enabled)
        button:SetActive(enabled)

        widget.Enabled = enabled
    end)
    print('Successfully built plugin')
end

main()
