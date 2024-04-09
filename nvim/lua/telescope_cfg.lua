-- telescope_cfg.lua

local TelescopeCustomFunctions = {}

local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
end
local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function find_project_root()
	local opts = {
		-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
		find_command = {
			"rg",
			"--files",
			"--smart-case",
			"--ignore",
			"--hidden",
			"--glob",
			"!**/.git/*",
			"--glob",
			"!*.out",
		},
	}

	if is_git_repo() then
		opts.cwd = get_git_root()
	end

	return opts
end

local function files_with_string()
	local opts = {
		-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
		find_command = {
			"rg",
			"--files",
			"--smart-case",
			"--ignore",
			"--hidden",
			"--glob",
			"!**/.git/*",
			"--glob",
			"!*.out",
		},
	}

	if is_git_repo() then
		opts.cwd = get_git_root()
	end

	return opts
end
TelescopeCustomFunctions.find_files_from_project_git_root = function()
	local opts = find_project_root()
	require("telescope.builtin").find_files(opts)
end

TelescopeCustomFunctions.live_grep_from_project_git_root = function()
	local opts = find_project_root()
	require("telescope.builtin").live_grep(opts)
end

TelescopeCustomFunctions.find_files_with_string = function()
	local opts = files_with_string()
	require("telescope.builtin").live_grep(opts)
end

return TelescopeCustomFunctions
