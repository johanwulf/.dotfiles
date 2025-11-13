local M = {}

vim.api.nvim_set_hl(0, 'TmuxSessionCurrent', { fg = '#88C0D0', bold = true })
vim.api.nvim_set_hl(0, 'TmuxSessionActive', { fg = '#5E81AC' })
vim.api.nvim_set_hl(0, 'TmuxSessionInactive', { fg = '#4C566A' })

local function get_dirs(path)
  local handle = vim.loop.fs_scandir(path)
  if not handle then
    return {}
  end

  local dirs = {}
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == 'directory' then
      table.insert(dirs, path .. '/' .. name)
    end
  end
  return dirs
end

local function get_tmux_sessions()
  local sessions = {}
  local output = vim.fn.system "tmux list-sessions -F '#{session_name}:#{session_windows}:#{session_path}' 2>/dev/null"
  if vim.v.shell_error == 0 then
    for line in output:gmatch '[^\r\n]+' do
      local name, windows, path = line:match '^(.+):(%d+):(.+)$'
      if name and windows then
        sessions[name] = {
          windows = tonumber(windows),
          path = path,
        }
      end
    end
  end
  return sessions
end

local function get_current_session()
  if vim.env.TMUX then
    local output = vim.fn.system "tmux display-message -p '#S'"
    return output:gsub('%s+$', '')
  end
  return nil
end

local function switch_tmux_session(entry)
  local session_name = entry.session_name or entry.name
  local selected_path = entry.path
  local in_tmux = vim.env.TMUX ~= nil
  local tmux_running = vim.fn.system('pgrep tmux'):gsub('%s+', '') ~= ''

  if not in_tmux and not tmux_running then
    if selected_path then
      vim.fn.system(string.format("tmux new-session -s '%s' -c '%s'", session_name, selected_path))
    end
    return
  end

  local session_exists = vim.fn.system(string.format("tmux has-session -t='%s' 2>/dev/null; echo $?", session_name)):match '^0'
  if not session_exists and selected_path then
    vim.fn.system(string.format("tmux new-session -ds '%s' -c '%s'", session_name, selected_path))
  end
  vim.fn.system(string.format("tmux switch-client -t '%s'", session_name))
end

local function kill_tmux_session(session_name, callback)
  local choice = vim.fn.confirm(string.format("Kill tmux session '%s'?", session_name), '&Yes\n&No', 2)

  if choice == 1 then
    vim.fn.system(string.format("tmux kill-session -t '%s'", session_name))
    if callback then
      callback()
    end
  end
end

function M.open()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local conf = require('telescope.config').values
  local entry_display = require 'telescope.pickers.entry_display'

  local repos_path = vim.env.REPOS_PATH or (vim.env.HOME .. '/repos')
  local all_dirs = get_dirs(repos_path)
  local tmux_sessions = get_tmux_sessions()
  local current_session = get_current_session()

  local seen_sessions = {}

  local entries = {}

  for _, dir in ipairs(all_dirs) do
    local dir_name = vim.fn.fnamemodify(dir, ':t')
    local session_name = dir_name:gsub('%.', '_')
    local session_info = tmux_sessions[session_name]
    local is_current = (session_name == current_session)

    seen_sessions[session_name] = true

    table.insert(entries, {
      path = dir,
      name = dir_name,
      session_name = session_name,
      is_current = is_current,
      has_session = session_info ~= nil,
      windows = session_info and session_info.windows or 0,
      is_repo = true,
    })
  end

  for session_name, session_info in pairs(tmux_sessions) do
    if not seen_sessions[session_name] then
      local is_current = (session_name == current_session)
      table.insert(entries, {
        path = nil,
        name = session_name,
        session_name = session_name,
        is_current = is_current,
        has_session = true,
        windows = session_info.windows,
        is_repo = false,
      })
    end
  end

  table.sort(entries, function(a, b)
    if a.is_current ~= b.is_current then
      return a.is_current
    end
    if a.has_session ~= b.has_session then
      return a.has_session
    end
    return a.name < b.name
  end)

  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 2 },
      { remaining = true },
    },
  }

  pickers
    .new(require('telescope.themes').get_dropdown(), {
      prompt_title = 'Sessions',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          local indicator = '  '
          local hl_group = 'TmuxSessionInactive'

          if entry.is_current then
            indicator = '➜ '
            hl_group = 'TmuxSessionCurrent'
          elseif entry.has_session then
            indicator = '● '
            hl_group = 'TmuxSessionActive'
          end

          local display_text = entry.name
          if entry.has_session then
            display_text = display_text .. string.format(' [%d windows]', entry.windows)
          end

          return {
            value = entry,
            display = function()
              return displayer {
                { indicator, hl_group },
                { display_text, hl_group },
              }
            end,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            switch_tmux_session(selection.value)
          end
        end)

        map('i', '<C-d>', function()
          local selection = action_state.get_selected_entry()
          if selection and selection.value.has_session then
            kill_tmux_session(selection.value.session_name, function()
              actions.close(prompt_bufnr)
              vim.schedule(function()
                M.open()
              end)
            end)
          end
        end)

        map('n', '<C-d>', function()
          local selection = action_state.get_selected_entry()
          if selection and selection.value.has_session then
            kill_tmux_session(selection.value.session_name, function()
              actions.close(prompt_bufnr)
              vim.schedule(function()
                M.open()
              end)
            end)
          end
        end)

        return true
      end,
    })
    :find()
end

return M
