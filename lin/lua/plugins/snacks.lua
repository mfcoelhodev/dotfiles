return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      -- general explorer module settings live here
      -- e.g. replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                n = "explorer_add",
              },
            },
          },
        },
      },
    },
  },
}
