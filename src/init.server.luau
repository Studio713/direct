function main()
	local toolbar = plugin:CreateToolbar("Direct")
	local button = toolbar:CreateButton("direct", "Open Cutscene Director", "", "Direct")

	button.Click:Connect(function() end)

	print("Successfully built plugin")
end

main()
