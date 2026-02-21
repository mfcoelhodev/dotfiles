return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Filter out tree-sitter-cli from the auto-install list
      opts.ensure_installed = vim.tbl_filter(function(v)
        return v ~= "tree-sitter-cli"
      end, opts.ensure_installed or {})
    end,
  },
}
