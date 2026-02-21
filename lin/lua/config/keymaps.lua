-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

-- =====================
-- DELETE / CHANGE SEM YANK
-- =====================
map("n", "d", '"_d')
map("n", "c", '"_c')
map("n", "x", '"_x')
map("n", "<leader>d", "d")
-- vim.keymap.set("v", "y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })

-- =====================
-- BUFFERS
-- =====================
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<S-l>", ":bnext<CR>")

-- =====================
-- SPLITS
-- =====================
map("n", "<leader>v", ":vsplit<CR>")
map("n", "<leader>s", ":split<CR>")

-- =====================
-- PANE NAVIGATION
-- =====================
map("n", "<leader>h", "<C-w>h")
map("n", "<leader>j", "<C-w>j")
map("n", "<leader>k", "<C-w>k")
map("n", "<leader>l", "<C-w>l")
map("n", "<leader>qq", ":bd<CR>", { noremap = true, silent = true, desc = "delete buffer / close window" })
map("n", "<leader>qQ", ":quitall<CR>", { noremap = true, silent = true, desc = "quitall" })
-- =====================
-- FILES
-- =====================
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>x", ":x<CR>")

-- =====================
-- TELESCOPE
-- =====================
map("n", "<leader>n", ":enew<CR>")

-- =====================
-- LSP
-- =====================
map("n", "gh", vim.lsp.buf.hover)
map("n", "<leader>g", vim.lsp.buf.hover)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>p", vim.lsp.buf.format)

-- =====================
-- DIAGNOSTICS
-- =====================
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- =====================
-- MOVE LINES
-- =====================
map("n", "<S-j>", ":m .+1<CR>==")
map("n", "<S-k>", ":m .-2<CR>==")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- =====================
-- ZEN MODE
-- =====================
map("n", "<C-i>", ":ZenMode<CR>")

-- Toggle comment (normal + visual) using comment.nvim
vim.keymap.set({ "n", "v" }, "<leader>cm", function()
  local api = require("Comment.api")

  if vim.fn.mode() == "n" then
    -- Normal mode: toggle current line
    api.toggle.linewise.current()
  else
    -- Visual mode: toggle selected lines
    api.toggle.linewise(vim.fn.visualmode())
  end
end, { desc = "Toggle comment (linewise)" })
