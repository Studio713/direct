local vide = require(script.Parent.Parent.Parent.Parent.packages.vide)
local divider = require(script.Parent.divider)
local create = vide.create
local source = vide.source
local action = vide.action
local cleanup = vide.cleanup

local function AdjustableDivider(props: AdjustableDividerProps)
    local startPos = source(Vector2.zero)

    return divider({
        direction = props.direction,
        color = props.color,
        order = props.order,
        size = props.size,
        create('UIDragDetector')({
            DragStart = function(pos)
                startPos(pos)
            end :: (((Vector2) -> ()) -> ()),
            DragEnd = function()
                startPos(Vector2.zero)
            end,
            action(function(dragDetector: Instance)
                if not (dragDetector and dragDetector:IsA('UIDragDetector')) then
                    return
                end

                local conn = dragDetector.DragContinue:Connect(function(pos)
                    local drag = dragDetector.DragUDim2

                    if not drag then
                        return
                    end

                    local deltaScale = drag.X.Offset
                    local sens = 0.01
                    local valueDelta = -deltaScale * sens
                    local currentValue = props.source()
                    local nextValue = math.clamp(currentValue + valueDelta, props.min, props.max)

                    props.source(nextValue)
                end)

                cleanup(conn)
			end),
        }),
        create('UISizeConstraint')({
            MinSize = if props.direction == 'vertical'then Vector2.new(5, 0)else Vector2.new(0, 5),
        }),
        action(function(divider: Instance)
            local detector = divider:FindFirstChild('UIDragDetector')

            if not (detector and detector:IsA('UIDragDetector')) then
                return
            end

            divider:GetPropertyChangedSignal('Parent'):Once(function()
                detector.ReferenceUIInstance = divider :: GuiObject
            end)
        end),
    })
end

return AdjustableDivider