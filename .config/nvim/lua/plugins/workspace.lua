return {
  "sanathks/workspace.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("workspace").setup({
      workspaces = {
        { name = "WORK", path = "~/IKEA", keymap = { "<leader>wo" } },
        { name = "PERSONAL", path = "~/personal", keymap = { "<leader>pers" } },
      },
    })
  end,
}
