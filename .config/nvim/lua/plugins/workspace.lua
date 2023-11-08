return {
	"sanathks/workspace.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("workspace").setup({
			workspaces = {
				{ name = "WORK", path = "~/WORK", keymap = { "<leader>wo" } },
				{ name = "PERSONAL", path = "~/personal", keymap = { "<leader>pers" } },
			},
		})
	end,
}
