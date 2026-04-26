local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Astarte layout: hjkl -> ktns
keymap("", "k", "h", opts)
keymap("", "t", "j", opts)
keymap("", "n", "k", opts)
keymap("", "s", "l", opts)

-- select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- go to line start/end
keymap("n", "K", "^", opts)
keymap("n", "S", "$", opts)

-- clear highlight
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- exit insert mode
keymap("i", "jj", "<ESC>", opts)

-- stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "K", "^", opts)
keymap("v", "S", "$", opts)

-- terminal
keymap("t", "<ESC>", "<ESC><Plug>(<ESC>)", opts)
keymap("t", "<Plug>(<ESC>)<ESC>", "<C-\\><C-n>", opts)

