vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
    require("nvim-tree.api").tree.expand_all() 
  end,
})
