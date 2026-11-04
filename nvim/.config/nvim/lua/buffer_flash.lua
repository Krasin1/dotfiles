-- Briefly flash the window background when buffers or splits change.
--
-- Inspired by tmux-pop (https://github.com/roosta/tmux-pop): the window's
-- Normal background is temporarily replaced, so a transparent colorscheme
-- lets the flash color through.
local M = {}

local defaults = {
	-- Flash length in milliseconds.
	duration = 90,

	-- Flash color. nil keeps the colorscheme's value for that attribute.
	bg = "#3b4261",
	fg = nil,
	ctermbg = nil,
	ctermfg = nil,

	-- Window-local groups that should get the flash background.
	groups = { "Normal", "EndOfBuffer", "LineNr", "CursorLineNr", "SignColumn", "FoldColumn" },

	-- Do not flash special buffers.
	exclude_buftypes = { "help", "nofile", "nowrite", "prompt", "quickfix", "terminal" },
	exclude_filetypes = {
		"fzf",
		"snacks_dashboard",
		"snacks_picker_input",
		"snacks_picker_list",
	},

	-- Set to true to flash the buffer that was already open at startup.
	flash_on_startup = false,

	-- Optional extra predicate: function(buf, win) -> boolean.
	-- Return false to skip the flash.
	filter = nil,
}

local cfg = vim.deepcopy(defaults)
local flash_ns = vim.api.nvim_create_namespace("BufferFlash")
local augroup
local active = {} ---@type table<integer, { timer: table, generation: integer }>
local saved_hl_ns = {} ---@type table<integer, integer>
local last_win = nil ---@type integer?
local last_buf = nil ---@type integer?

local function make_set(list)
	local set = {}
	for _, value in ipairs(list or {}) do
		set[value] = true
	end
	return set
end

local excluded_buftypes = {}
local excluded_filetypes = {}

local function set_highlights()
	for _, group in ipairs(cfg.groups) do
		-- Start from the colorscheme's attributes so fg, bold, etc. survive.
		local hl = vim.deepcopy(vim.api.nvim_get_hl(0, { name = group }))
		for _, key in ipairs({ "bg", "fg", "ctermbg", "ctermfg" }) do
			if cfg[key] then
				hl[key] = cfg[key]
			end
		end
		vim.api.nvim_set_hl(flash_ns, group, hl)
	end
end

local function restore(win, generation)
	local state = active[win]
	if not state or state.generation ~= generation then
		return
	end

	active[win] = nil
	local previous = saved_hl_ns[win]
	saved_hl_ns[win] = nil
	if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_hl_ns({ winid = win }) == flash_ns then
		vim.api.nvim_win_set_hl_ns(win, previous or -1)
	end
end

---Flash a window manually.
---@param win? integer Window handle (defaults to the current window).
function M.flash(win)
	win = win or vim.api.nvim_get_current_win()
	if not vim.api.nvim_win_is_valid(win) then
		return
	end

	-- Only the window that just became active should stay lit.
	for other, other_state in pairs(active) do
		if other ~= win then
			other_state.timer:stop()
			other_state.timer:close()
			restore(other, other_state.generation)
		end
	end

	local state = active[win]
	if state then
		-- Restart the timeout, but keep the window's original namespace.
		state.timer:stop()
		state.timer:close()
	else
		saved_hl_ns[win] = vim.api.nvim_get_hl_ns({ winid = win })
	end

	set_highlights()
	vim.api.nvim_win_set_hl_ns(win, flash_ns)

	local generation = (state and state.generation or 0) + 1
	local timer = vim.defer_fn(function()
		restore(win, generation)
	end, cfg.duration)

	active[win] = { timer = timer, generation = generation }
end

local function should_flash(buf, win)
	if excluded_buftypes[vim.bo[buf].buftype] then
		return false
	end
	if excluded_filetypes[vim.bo[buf].filetype] then
		return false
	end
	if cfg.filter and not cfg.filter(buf, win) then
		return false
	end
	return true
end

local function on_enter(args)
	local win = vim.api.nvim_get_current_win()
	local buf = args.buf

	if last_win == win and last_buf == buf then
		return
	end

	if not cfg.flash_on_startup and vim.v.vim_did_enter == 0 then
		last_win = win
		last_buf = buf
		return
	end
	if should_flash(buf, win) then
		last_win = win
		last_buf = buf
		M.flash(win)
	end
end

local function clear_window_state(win)
	local state = active[win]
	if state then
		state.timer:stop()
		state.timer:close()
	end
	active[win] = nil
	saved_hl_ns[win] = nil
end

---Set up the plugin. Safe to call more than once.
---@param opts? table
function M.setup(opts)
	-- Stop any flashes left over from a previous setup call.
	for win, state in pairs(active) do
		state.timer:stop()
		state.timer:close()
		restore(win, state.generation)
	end

	cfg = vim.tbl_extend("force", vim.deepcopy(defaults), opts or {})
	excluded_buftypes = make_set(cfg.exclude_buftypes)
	excluded_filetypes = make_set(cfg.exclude_filetypes)

	if augroup then
		vim.api.nvim_del_augroup_by_id(augroup)
	end
	augroup = vim.api.nvim_create_augroup("BufferFlash", { clear = true })

	-- Remember the window and buffer open at startup so they do not count as a switch.
	last_win = vim.api.nvim_get_current_win()
	last_buf = vim.api.nvim_get_current_buf()

	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
		group = augroup,
		callback = on_enter,
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		group = augroup,
		callback = function(args)
			clear_window_state(tonumber(args.match))
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = augroup,
		callback = function()
			for win in pairs(active) do
				clear_window_state(win)
			end
		end,
	})

	return M
end

return M
