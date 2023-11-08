-- Defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Lines to keep visible above/below cursor when scrolling
vim.opt.scrolloff = 15

-- Disable Netrw as we are using neo-tree.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Indenting
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

-- Show diagnostics on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- Disable need to press enter when saving file
vim.opt.shortmess = {
	o = true,
}
