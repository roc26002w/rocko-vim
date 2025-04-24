 -- Set up nvim-cmp.
local cmp = require('cmp')
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local auto_select = true

cmp.setup({
  snippet = {
    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping({
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end, {"i","s","c",}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end, {"i","s","c",}),
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
         else
           fallback()
         end
       end,
     --  s = cmp.mapping.confirm({ select = true }),
     --  c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
  }),

  sources = cmp.config.sources({
    { name = 'ultisnips' }, -- For ultisnips users.
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})
