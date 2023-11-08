local Util = require("lazyvim.util")

-- Remap <leader><space> to include current working directory
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader><space>", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
  },
}
