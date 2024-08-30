local M = {}

local term_buf = nil
local term_win = nil

M.state = {
  is_open = false,
}

-- Default options
M.config = {
  -- Command Options
  command = {
    -- Enable :Gitui command
    -- @type: bool
    enable = true,
  },
  -- Path to binary
  -- @type: string
  binary = "gitui",
  -- Argumens to gitui
  -- @type: table of string
  args = {},
  -- WIndow Options
  window = {
    options = {
      -- Width window in %
      -- @type: number
      width = 90,
      -- Height window in %
      -- @type: number
      height = 80,
      -- Border Style
      -- Enum: "none", "single", "rounded", "solid" or "shadow"
      -- @type: string
      border = "rounded",
    },
  },
}

local function calc_window_options(init_window_options)
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * (init_window_options.height / 100))
  local win_width = math.ceil(width * (init_window_options.width / 100))
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  return {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = init_window_options.border,
    noautocmd = true,
  }
end

M.setup = function(overrides)
  M.config = vim.tbl_deep_extend("force", M.config, overrides or {})

  if M.config.command.enable then
    vim.cmd([[command! Gitui :lua require"gitui".toggle()]])
  end
end

M.toggle = function()
  assert(vim.fn.executable(M.config.binary) == 1, M.config.binary .. " not a executable")

  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    return
  end

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  local window_options = calc_window_options(M.config.window.options)
  term_win = vim.api.nvim_open_win(term_buf, true, window_options)

  if not M.state.is_open then
    M.state.is_open = true
    local term_params = table.concat(vim.tbl_flatten({ M.config.binary, M.config.args }), " ")

    vim.fn.termopen(term_params, {
      on_exit = function ()
        M.terminate()
      end
    })
  end

  vim.cmd([[startinsert!]])
end

M.terminate = function ()
  if term_buf then
    vim.api.nvim_buf_delete(term_buf, { force = true })
  end

  term_buf = nil
  term_win = nil

  M.state.is_open = false
end

return M
