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

--- Telescope Commands are <leader>t*
map("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

--- Harpoon Commands are <leader>h*
local harpoon = require("harpoon")

harpoon:setup()
map("n", "<leader>ha", function()
  harpoon:list():add()
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
wk.add({
  {
    "<leader>h1",
    function()
      harpoon:list():select(1)
    end,
    desc = harpoon_desc(1),
  },
  {
    "<leader>h2",
    function()
      harpoon:list():select(2)
    end,
    desc = harpoon_desc(2),
  },
  {
    "<leader>h3",
    function()
      harpoon:list():select(3)
    end,
    desc = harpoon_desc(3),
  },
  {
    "<leader>h4",
    function()
      harpoon:list():select(4)
    end,
    desc = harpoon_desc(4),
  },
})
map("n", "<leader>hh", function()
  harpoon:list():prev()
end, { desc = "Harpoon: prev" })
map("n", "<leader>hl", function()
  harpoon:list():next()
end, { desc = "Harpoon: next" })

--- Buffer Commands are <leader>b*

--- Conform Commands are <leader>f*
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })
