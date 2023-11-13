-- Defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.cmd(":Prettier")
	end,
})
