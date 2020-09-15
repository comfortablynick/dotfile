-- LSP configurations
local M = {}
local api = vim.api
local def_diagnostics_cb = vim.lsp.callbacks["textDocument/publishDiagnostics"]
local util = require"util"
local lsp = util.npcall(require, "nvim_lsp")

-- Customized rename function; defaults to name under cursor
function M.rename(new_name)
  local params = vim.lsp.util.make_position_params()
  local cursor_word = vim.fn.expand("<cexpr>")
  new_name = new_name or util.npcall(vim.fn.input, "New Name: ", cursor_word)
  if not (new_name and #new_name > 0) then return end
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params)
end

local diagnostics_qf_cb = function(err, method, result, client_id)
  -- Use default callback too
  def_diagnostics_cb(err, method, result, client_id)
  -- Add to quickfix
  if result and result.diagnostics then
    for _, v in ipairs(result.diagnostics) do
      v.bufnr = client_id
      v.lnum = v.range.start.line + 1
      v.col = v.range.start.character + 1
      v.text = v.message
    end
    vim.lsp.util.set_qflist(result.diagnostics)
  end
end

local on_attach_cb = function(client, bufnr)
  local text_complete = {
    {complete_items = {"buffers"}},
    {complete_items = {"path"}, triggered_only = {"/"}},
  }
  local complete_chain = {
    default = {
      {complete_items = {"lsp", "snippet", "UltiSnips"}},
      {complete_items = {"buffers"}},
      {complete_items = {"path"}, triggered_only = {"/"}},
    },
    string = text_complete,
    comment = text_complete,
  }
  local completion = util.npcall(require, "completion")
  if completion then completion.on_attach{chain_complete_list = complete_chain} end
  require"ntm/snippets"
  api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  local map_opts = {noremap = true, silent = true}
  local nmaps = {
    [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["<F2>"] = "<Cmd>lua require'lsp'.rename()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
  }

  for lhs, rhs in pairs(nmaps) do
    api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
  end

  vim.cmd[[augroup lsp_lua_on_attach]]
  vim.cmd[[autocmd CompleteDone * if pumvisible() == 0 | pclose | endif]]
  vim.cmd[[augroup END]]

  -- Not sure what these are supposed to do
  -- vim.cmd[[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  -- vim.cmd[[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  -- vim.cmd[[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]]
end

function M.init()
  -- Safely return without error if nvim_lsp isn't installed
  if not lsp then return end
  local configs = {
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = {version = "LuaJIT"},
          diagnostics = {
            enable = true,
            globals = {"vim", "nvim", "sl", "p", "printf"},
          },
        },
      },
    },
    vimls = {},
    yamlls = {
      filetypes = {"yaml", "yaml.ansible"},
      settings = {
        yaml = {
          schemas = {["http://json.schemastore.org/ansible-stable-2.9"] = "*"},
        },
      },
    },
    -- pyls_ms = {},
  }

  -- Set global callbacks
  -- Can also be set locally for each server
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = diagnostics_qf_cb

  -- Set local configs
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    lsp[server].setup(cfg)
  end
end

return M
