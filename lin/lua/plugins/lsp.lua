-- lsp.lua file setup for Neovim with custom LSP configuration
return {
  -- Load the LSP plugin (nvim-lspconfig)
  {
    "neovim/nvim-lspconfig",

    -- Function to customize the LSP setup
    config = function()
      -- Disable LSP watcher on Linux for better performance
      local ok, wf = pcall(require, "vim.lsp._watchfiles")
      if ok then
        wf._watchfunc = function()
          return function() end
        end
      end

      -- Load and adjust keymaps for LSP
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Remove the "K" keymap (or adjust it as needed)
      -- Set "K" to false to disable it in LSP context
      keys[#keys + 1] = { "K", false }

      -- Apply the keymaps (you could add more adjustments here)
      -- If the keymap setup function needs to be applied, you might want to set this.
      -- (Ensure that `lazyvim.plugins.lsp.keymaps` is properly defined elsewhere in your config)
      -- For example:
      -- vim.keymap.set('n', 'K', false)  -- Disables the default `K` keymap
    end,

    -- Optionally, you can include more LSP configuration specific to your setup here
    -- For example, a language server setup, like:
    -- on_attach = function(client, bufnr)
    --   -- Custom on_attach logic here (e.g., defining additional keymaps, etc.)
    -- end
  },
}
