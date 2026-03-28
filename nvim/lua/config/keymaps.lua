local map = vim.keymap.set

--- Diagnostic Commands are <leader>e*
map("n", "<leader>ef", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "<leader>el", function()
  vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })
map("n", "<leader>eh", function()
  vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })

--- Window Navigation are <C-*>
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

--- Sidebar Commands are <leader>B*
map("n", "<leader>BB", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Tree Window" })

--- Fuzzy Find Commands are <leader>l*
map("n", "<leader>lf", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>lg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>lr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>ls", "<cmd>FzfLua grep_cword<cr>", { desc = "Search word under cursor" })
map("n", "<leader>lk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })

--- Harpoon Commands are <leader>h*
local harpoon = require("harpoon")

harpoon:setup()
local function harpoon_redraw()
  vim.schedule(function()
    vim.cmd("redrawtabline")
  end)
end

map("n", "<leader>ha", function()
  harpoon:list():add()
  harpoon_redraw()
end, { desc = "Harpoon Add" })
map("n", "<leader>he", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Toggle Menu" })
local function harpoon_desc(idx)
  return function()
    local item = harpoon:list():get(idx)
    return item
        and ("Harpoon: " .. vim.fn.fnamemodify(item.value, ":h:t") .. "/" .. vim.fn.fnamemodify(item.value, ":t"))
      or ("Harpoon slot " .. idx)
  end
end

local wk = require("which-key")
local harpoon_entries = {}
for i = 1, 9 do
  table.insert(harpoon_entries, {
    "<leader>h" .. i,
    function()
      harpoon:list():select(i)
    end,
    desc = harpoon_desc(i),
  })
end
wk.add(harpoon_entries)
map("n", "<leader>hh", function()
  harpoon:list():prev()
end, { desc = "Harpoon: prev" })
map("n", "<leader>hl", function()
  harpoon:list():next()
end, { desc = "Harpoon: next" })

--- Git Commands are <leader>g*
map("n", "<leader>gg", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = { border = "curved" },
    highlights = {
      Normal = { guibg = "#000000" },
      NormalFloat = { guibg = "#000000" },
    },
    hidden = true,
  })
  lazygit:toggle()
end, { desc = "Open LazyGit" })

--- Buffer Commands are <leader>b*
map("n", ".", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", ",", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })

--- Conform Commands are <leader>f*
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

--- Terminal Commands are <M-i> and <M-h>
map({ "n", "t" }, "<M-i>", function()
  _G.popup_term:toggle()
end, { desc = "Toggle popup terminal" })
map({ "n", "t" }, "<M-h>", function()
  _G.horizontal_term:toggle()
end, { desc = "Toggle horizontal terminal" })
