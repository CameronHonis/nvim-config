local M = {}

M.toggle_terminal = function()
  -- Check if current buffer is a terminal
  local is_term = vim.bo.buftype == 'terminal'
  
  if is_term then
    -- If we're in a terminal, close it
    vim.cmd('close')
  else
    -- If not in a terminal, open a horizontal split with a terminal
    vim.cmd('split')
    vim.cmd('wincmd j')  -- Move to the new split
    vim.cmd('terminal')  -- Open terminal in the new split
    vim.cmd('startinsert')  -- Start in insert mode
  end
end

return M
