vim.o.updatetime = 1000

RemoveHighlight = function()
  vim.lsp.buf.clear_references()
end

HighlightUnderCursor = function()
  local word = vim.fn.expand('<cword>')
  if word == '' then
    return
  end
  vim.lsp.buf.document_highlight()
end

vim.cmd([[
augroup lsp_highlight
  autocmd!
  autocmd CursorMoved * lua RemoveHighlight()
  autocmd CursorHold,CursorHoldI * lua HighlightUnderCursor()
augroup END
]], false)

-- local bufnr = vim.api.nvim_get_current_buf()

-- Key mappings to move to previous and next highlight
vim.api.nvim_set_keymap('n', '<C-p>', '#<cword>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-n>', '#<cword>N', { noremap = true })

