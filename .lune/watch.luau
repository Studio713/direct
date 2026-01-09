local fs = require("@lune/fs")
local process = require("@lune/process")
local stdio = require("@lune/stdio")
local task = require("@lune/task")
local fs_utility = require("./utilities/fs_utility")

local input_dir = "src"
local output_dir = "out"

local function log(color: stdio.Color, ...)
	local time = os.date("%H:%M:%S")
	local message = table.concat({ ... }, " ")

	stdio.write(stdio.color(color))
	print(`[{time}]: {message}\n`)
	stdio.write(stdio.color("reset"))
end

local function compile()
	local output = fs.metadata(output_dir)
	if output.exists then
		fs.removeDir(output_dir)
	end

	local argonSourcemapResult = process.exec("argon", { "build", "-p", "build.project.json" })

	local darkluaProcessResult = process.exec("darklua", { "process", input_dir, output_dir, "--format", "readable" })

	local argonBuildResult = process.exec("argon", { "build", "-p", "build.project.json" })

	if not argonSourcemapResult.ok then
		log("red", `Failed to rebuild due to argon: {argonSourcemapResult.stderr}`)
		return
	end
	if not darkluaProcessResult.ok then
		log("red", `Failed to rebuild due to darklua: {darkluaProcessResult.stderr}`)
		return
	end
	if not argonBuildResult.ok then
		log("red", `Failed to rebuild due to argon: {argonBuildResult.stderr}`)
		return
	end

	log("green", `Rebuilding project`)
end

log("white", `Started watching at {input_dir}`)
task.spawn(compile)
task.spawn(fs_utility.watch, input_dir, compile)
