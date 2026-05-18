require('claude-chat').setup({})

vim.keymap.set({ "n", "v" }, "<leader>cc", ":ClaudeChat<CR>", { desc = "Toggle Claude Chat" })
