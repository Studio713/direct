function main()
local a=plugin:CreateToolbar"Direct"
local b=a:CreateButton("direct","Open Cutscene Director","","Direct")

b.Click:Connect(function()end)

print"Successfully built plugin"
end

main()