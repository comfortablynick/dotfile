return function(on_attach)
  local rust_on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.cmd(
      [[au InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> lua ]]
        .. [[require('lsp_extensions').inlay_hints]]
        .. [[{ prefix = " » ", aligned = false, highlight = "NonText", enabled = {"ChainingHint", "TypeHint"}}]]
    )
  end

  return {
    cmd = { "rust-analyzer" },
    on_attach = rust_on_attach,
    filetypes = { "rust" },
    settings = {
      ["rust-analyzer"] = {
        diagnostics = { disabled = { "inactive-code" } },
        rustfmt = { extraArgs = { "+nightly" } },
        trace = { server = "off" },
      },
    },
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        { update_in_insert = false }
      ),
    },
  }
end
