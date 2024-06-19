return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {},
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        ["<c-n>"] = cmp.mapping.select_next_item(),
        ["<c-p>"] = cmp.mapping.select_prev_item(),
        ["<c-b>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
        ["<c-y>"] = cmp.mapping.confirm({ select = true }),
        ["<c-Space>"] = cmp.mapping.complete({}),
        ["<c-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<c-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = {
        {
          name = "lazydev",
          group_index = 0,
        },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      },
    })
  end,
}
