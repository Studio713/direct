local fs = require("@lune/fs")
local process = require("@lune/process")
local stdio = require("@lune/stdio")
local task = require("@lune/task")
local fs_utility = require("./utilities/fs_utility")

local input_dir = "src"
local output_dir = "out"

local function log(...)
	stdio.write(table.concat({ ... }, " "))
	stdio.write("\n")
end

local function compile()
	local output = fs.metadata(output_dir)
	if output.exists then
		fs.removeDir(output_dir)
	end

	local darkluaExec = process.exec("darklua", { "process", input_dir, output_dir })

	local argonExec = process.exec("argon", { "build", "-p", "build.project.json" })

	if not darkluaExec.ok then
		log(`Failed to rebuild due to darklua: {darkluaExec.stderr}`)
		return
	end
	if not argonExec.ok then
		log(`Failed to rebuild due to argon: {argonExec.stderr}`)
		return
	end

	log(`Rebuilding project`)
end

log(`Started watching at {input_dir}`)
task.spawn(compile)
task.spawn(fs_utility.watch, input_dir, compile)
