return {
  { 'github/copilot.vim' },
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ['<C-t>'] = function()
            require('custom.tmux-switcher').open()
          end,
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float)
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    lazy = false,
    config = function()
      vim.keymap.set('n', '<C-t>', function()
        require('custom.tmux-switcher').open()
      end, { noremap = true, silent = true, desc = '[T]mux session switcher' })
    end,
  },
}
