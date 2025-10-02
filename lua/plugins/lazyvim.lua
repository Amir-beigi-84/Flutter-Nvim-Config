return {
  -- add jsonls and schemastore packages and set up null-ls
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "json-lsp" })
    end,
  },
}
