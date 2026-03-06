require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ToggleTerm keymaps
-- opt+h: toggle horizontal terminal (overrides NvChad's built-in <A-h>)
map({ "n", "t" }, "<A-h>", function() _G.toggle_current_term() end,
  { desc = "Toggle horizontal terminal" })

-- In terminal mode: alt+shift+l cycles to next terminal
map("t", "<A-S-l>", function() _G.cycle_next_term() end,
  { desc = "Cycle to next terminal instance" })

-- In terminal mode: alt+shift+h cycles to previous terminal
map("t", "<A-S-h>", function() _G.cycle_previous_term() end,
  { desc = "Cycle to previous terminal instance" })

map("n", "<leader>td", "<cmd>Telescope diagnostics<cr>", { desc = "telescope diagnostics"})
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous diagnostic" })

-- Numbered quick-access in normal AND terminal mode (auto-creates terminals if needed)
for i = 1, 5 do
  map({ "n", "t" }, "<A-" .. i .. ">", function()
    _G.create_terminal(i)
    _G.toggle_term(i)
  end, { desc = "Terminal " .. i })
end
