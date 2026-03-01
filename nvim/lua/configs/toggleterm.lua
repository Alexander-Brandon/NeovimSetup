local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup({
  direction = "horizontal",
  size = 15,
  open_mapping = nil, -- manage manually
  shade_terminals = true,
  persist_mode = true,
  close_on_exit = true,
})

-- Terminal configuration
local current_term_idx = 1
local terms = {}
local term_objects = {}  -- Store Terminal instances by ID

-- Helper to get or create a terminal instance
local function get_or_create_term(idx)
  if not term_objects[idx] then
    term_objects[idx] = Terminal:new({
      id = idx,
      display_name = "Term " .. idx,
      hidden = true,
      direction = "horizontal",
      size = 15,
    })
    table.insert(terms, term_objects[idx])
  end
  return term_objects[idx]
end

-- Initialize with 2 terminals
for i = 1, 2 do
  get_or_create_term(i)
end

-- Toggle terminal by index
function _G.toggle_term(idx)
  local term = get_or_create_term(idx)
  if not term then return end

  -- Check if this terminal's buffer is visible
  local is_visible = term.bufnr
    and vim.api.nvim_buf_is_valid(term.bufnr)
    and #vim.fn.win_findbuf(term.bufnr) > 0

  if is_visible then
    -- Close the terminal window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
      if ok and buf == term.bufnr then
        vim.api.nvim_win_close(win, false)
        break
      end
    end
  else
    -- Close any other open terminal windows first
    for other_idx, other_term in pairs(term_objects) do
      if other_idx ~= idx and other_term.bufnr then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
          if ok and buf == other_term.bufnr then
            vim.api.nvim_win_close(win, false)
            break
          end
        end
      end
    end
    -- Open this terminal
    term:open()
    current_term_idx = idx
  end
end

-- Toggle the currently selected terminal
function _G.toggle_current_term()
  _G.toggle_term(current_term_idx)
end

-- Cycle to next terminal instance
function _G.cycle_next_term()
  -- Detect which terminal we're actually in (immune to stale current_term_idx)
  local cur_buf = vim.api.nvim_get_current_buf()
  for idx, term in pairs(term_objects) do
    if term.bufnr == cur_buf then
      current_term_idx = idx
      break
    end
  end

  -- Close current terminal window (mirrors toggle_term approach)
  local current_term = term_objects[current_term_idx]
  if current_term and current_term.bufnr then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
      if ok and buf == current_term.bufnr then
        vim.api.nvim_win_close(win, false)
        break
      end
    end
  end

  -- Collect and sort all existing terminal indices
  local indices = {}
  for idx in pairs(term_objects) do
    table.insert(indices, idx)
  end
  table.sort(indices)

  -- Find current position, then advance (wrapping)
  local pos = 1
  for i, idx in ipairs(indices) do
    if idx == current_term_idx then pos = i; break end
  end
  local next_idx = indices[(pos % #indices) + 1]

  current_term_idx = next_idx

  -- Open the next terminal
  local next_term = term_objects[current_term_idx]
  next_term:open()
end

-- Cycle to next terminal instance
function _G.cycle_previous_term()
  -- Detect which terminal we're actually in (immune to stale current_term_idx)
  local cur_buf = vim.api.nvim_get_current_buf()
  for idx, term in pairs(term_objects) do
    if term.bufnr == cur_buf then
      current_term_idx = idx
      break
    end
  end

  -- Close current terminal window (mirrors toggle_term approach)
  local current_term = term_objects[current_term_idx]
  if current_term and current_term.bufnr then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
      if ok and buf == current_term.bufnr then
        vim.api.nvim_win_close(win, false)
        break
      end
    end
  end

  -- Collect and sort all existing terminal indices
  local indices = {}
  for idx in pairs(term_objects) do
    table.insert(indices, idx)
  end
  table.sort(indices)

  -- Find current position, then advance (wrapping)
  local pos = 1
  for i, idx in ipairs(indices) do
    if idx == current_term_idx then pos = i; break end
  end
  local previous_idx = indices[((pos - 2) % #indices) + 1]

  current_term_idx = previous_idx

  -- Open the next terminal
  local next_term = term_objects[current_term_idx]
  next_term:open()
end

-- Dynamic terminal creation
function _G.create_terminal(idx)
  get_or_create_term(idx)
end

-- Expose for statusline
_G.toggleterm_instances = terms
_G.toggleterm_current_idx = function() return current_term_idx end
