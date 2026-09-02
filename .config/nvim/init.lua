vim.loader.enable()

vim.env.PATH = '/opt/homebrew/opt/node@24/bin:' .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

vim.keymap.set('n', '<leader>cp', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path, vim.log.levels.INFO)
end, { desc = '[C]opy [P]ath of current buffer' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font,
        opts = {
          override = {
            ['pnpm-lock.yaml'] = { icon = '', color = '#cbcb41', name = 'Yaml' },
            ['pnpm-workspace.yaml'] = { icon = '', color = '#cbcb41', name = 'Yaml' },
            yaml = { icon = '', color = '#cbcb41', name = 'Yaml' },
            yml = { icon = '', color = '#cbcb41', name = 'Yaml' },
          },
        },
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob',
            '!.git/*',
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = true,
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(d)
            return d.message
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local kotlin_maven_profiles = {}

      local function maven_project(root)
        local root_pom = vim.fs.joinpath(root, 'pom.xml')
        if vim.fn.filereadable(root_pom) ~= 1 then
          return root, nil
        end

        local root_pom_text = table.concat(vim.fn.readfile(root_pom), '\n')
        local artifact = root_pom_text:match '</parent>%s*<artifactId>%s*([^%s<]+)%s*</artifactId>'
        local current = root
        while current do
          local pom = vim.fs.joinpath(current, 'pom.xml')
          if vim.fn.filereadable(pom) == 1 then
            local pom_text = table.concat(vim.fn.readfile(pom), '\n')
            local profile = artifact and 'build-' .. artifact
            if profile and pom_text:find '<modules>' and pom_text:find('<id>' .. profile .. '</id>', 1, true) then
              return current, profile
            end
          end

          local parent = vim.fs.dirname(current)
          if parent == current then
            break
          end
          current = parent
        end

        return root, nil
      end

      local servers = {
        bashls = {},
        cssls = {},
        eslint = {},
        html = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        kotlin_lsp = {
          cmd = function(dispatchers, config)
            local root_dir = config.root_dir or vim.fn.getcwd()
            local system_path = vim.fs.joinpath(vim.fn.stdpath 'cache', 'kotlin-lsp', vim.fn.sha256(root_dir):sub(1, 12))
            local env = vim.fn.environ()
            if config.cmd_env then
              env = vim.tbl_extend('force', env, config.cmd_env)
            end
            if kotlin_maven_profiles[root_dir] then
              env.MAVEN_ARGS = '-P' .. kotlin_maven_profiles[root_dir]
            end

            return vim.lsp.rpc.start(
              { 'intellij-server', '--stdio', '--system-path', system_path },
              dispatchers,
              { env = env }
            )
          end,
          root_dir = function(bufnr, on_dir)
            local module_root = vim.fs.root(bufnr, {
              'settings.gradle',
              'settings.gradle.kts',
              'pom.xml',
              'build.gradle',
              'build.gradle.kts',
              'gradle.properties',
              '.git',
            })

            local root, profile = maven_project(module_root or vim.fn.getcwd())
            if profile then
              kotlin_maven_profiles[root] = profile
            end
            on_dir(root)
          end,
          root_markers = {
            'settings.gradle',
            'settings.gradle.kts',
            'pom.xml',
            'build.gradle',
            'build.gradle.kts',
            'gradle.properties',
            '.git',
          },
        },
        tailwindcss = {},
        ts_ls = {
          before_init = function(params, config)
            local root_dir = params.rootUri and vim.uri_to_fname(params.rootUri) or config.root_dir
            local workspace_tsserver = root_dir and vim.fs.joinpath(root_dir, 'node_modules/typescript/lib/tsserver.js')
            local tsserver_path = workspace_tsserver

            if not tsserver_path or vim.fn.filereadable(tsserver_path) ~= 1 then
              tsserver_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason/packages/typescript-language-server/node_modules/typescript/lib/tsserver.js')
            end

            config.init_options.tsserver.path = tsserver_path
          end,
          init_options = {
            disableAutomaticTypingAcquisition = true,
            hostInfo = 'neovim',
            maxTsServerMemory = 4096,
            tsserver = {
              path = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason/packages/typescript-language-server/node_modules/typescript/lib/tsserver.js'),
              useSyntaxServer = 'auto',
            },
          },
        },
      }

      vim.lsp.config('*', { capabilities = capabilities })
      for server_name, server_config in pairs(servers) do
        vim.lsp.config(server_name, server_config)
      end

      local ensure_installed = vim.tbl_keys(servers)
      table.insert(ensure_installed, 'jdtls')
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        automatic_enable = vim.tbl_keys(servers),
      }

      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua',
          'tailwindcss-language-server',
          'prettierd',
        },
      }
    end,
  },

  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = { 'mason-org/mason.nvim', 'saghen/blink.cmp' },
    config = function()
      local jdtls = require 'jdtls'
      local root_markers = {
        'mvnw',
        'gradlew',
        'pom.xml',
        'build.gradle',
        'build.gradle.kts',
        '.git',
      }
      local notified_missing_jdtls = false

      local function find_lombok()
        local candidates = {
          vim.fn.stdpath 'data' .. '/mason/packages/jdtls/lombok.jar',
          vim.fn.expand '~/.local/share/java/lombok.jar',
        }
        vim.list_extend(candidates, vim.fn.glob(vim.fn.expand '~/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar', false, true))

        for _, path in ipairs(candidates) do
          if path ~= '' and vim.fn.filereadable(path) == 1 then
            return path
          end
        end
      end

      local function start_jdtls(bufnr)
        if vim.bo[bufnr].filetype ~= 'java' then
          return
        end

        if vim.fn.executable 'jdtls' ~= 1 then
          if not notified_missing_jdtls then
            vim.notify('jdtls is not available yet. Run :MasonInstall jdtls and reopen the Java buffer.', vim.log.levels.WARN)
            notified_missing_jdtls = true
          end
          return
        end

        local source = vim.api.nvim_buf_get_name(bufnr)
        local root_dir = jdtls.setup.find_root(root_markers, source) or vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(root_dir, ':t')
        local workspace_dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls', project_name .. '-' .. vim.fn.sha256(root_dir):sub(1, 8))
        local lombok = find_lombok()
        local jvm_args = { '--jvm-arg=-Xmx4G' }
        if lombok then
          table.insert(jvm_args, '--jvm-arg=-javaagent:' .. lombok)
        end

        jdtls.start_or_attach {
          cmd = vim.list_extend({ 'jdtls' }, vim.list_extend(jvm_args, { '-data', workspace_dir })),
          capabilities = require('blink.cmp').get_lsp_capabilities(),
          root_dir = root_dir,
          settings = {
            java = {
              configuration = {
                updateBuildConfiguration = 'interactive',
              },
              contentProvider = {
                preferred = 'fernflower',
              },
              eclipse = {
                downloadSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              maven = {
                downloadSources = true,
              },
              references = {
                includeDecompiledSources = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              signatureHelp = {
                enabled = true,
              },
            },
          },
          init_options = {
            bundles = {},
          },
        }
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        group = vim.api.nvim_create_augroup('java-jdtls', { clear = true }),
        callback = function(event)
          start_jdtls(event.buf)
        end,
      })

      if vim.bo.filetype == 'java' then
        start_jdtls(0)
      end
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { timeout_ms = 500, lsp_format = 'never' }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
      },
    },
  },

  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
      vim.cmd.hi 'Comment gui=none'
      vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#939ab7', italic = true })
      vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { sp = '#939ab7', underline = true })
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter'
      local parsers = {
        'bash',
        'css',
        'html',
        'java',
        'kotlin',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'ruby',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
      }
      local filetypes = {
        'bash',
        'css',
        'html',
        'java',
        'kotlin',
        'javascript',
        'javascriptreact',
        'json',
        'lua',
        'markdown',
        'ruby',
        'tsx',
        'typescript',
        'typescriptreact',
        'vim',
        'vimdoc',
      }

      treesitter.setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }
      treesitter.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(event)
          if not pcall(vim.treesitter.start, event.buf) then
            return
          end

          if vim.bo[event.buf].filetype ~= 'ruby' then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  { import = 'custom.plugins' },
}, {
  ui = { icons = vim.g.have_nerd_font and {} or {} },
})
