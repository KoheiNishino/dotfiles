local M = {}

local log_file = vim.fn.stdpath("data") .. "/keylog.jsonl"

local enabled_modes = {
	n = true,
	v = true,
	o = true,
}

local keys = {}
local timer

local function flush()
	if #keys == 0 then
		return
	end

	local file = io.open(log_file, "a")
	if not file then
		return
	end

	for _, entry in ipairs(keys) do
		file:write(vim.json.encode(entry) .. "\n")
	end

	file:close()
	keys = {}
end

function M.start()
	local start_time = vim.uv.hrtime()
	vim.on_key(function(_, typed)
		if typed == "" then
			return
		end

		local mode = vim.api.nvim_get_mode().mode
		if not enabled_modes[mode] then
			return
		end

		table.insert(keys, {
			ts = (vim.uv.hrtime() - start_time) / 1e6,
			mode = mode,
			key = vim.fn.keytrans(typed),
		})

		if not timer then
			timer = vim.uv.new_timer()
			timer:start(5000, 5000, vim.schedule_wrap(flush))
		end
	end)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = flush,
	})
end

return M
