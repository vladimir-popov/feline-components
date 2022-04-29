local u = require('feline-components.utils')

vim.cmd('augroup feline_components_git_status')
vim.cmd('autocmd!')
vim.cmd(
    'autocmd BufEnter,FocusGained,BufWritePost * let b:git_status = systemlist("git status --porcelain")'
)
vim.cmd('augroup end')

local M = {

    ---@type fun(): boolean
    ---@return boolean is_buffer_empty `true` when buffer has a single line with an empty string.
    is_buffer_empty = function()
        return vim.fn.line('$') == 1 and u.is_empty(vim.fn.getline(1))
    end,

    ---@type fun(): boolean
    -- Uses 'tpope/vim-fugitive' to resolve is the file of the current buffer is in a git workspace.
    ---@return boolean is_git_workspace `true` when the file of the current buffer is in git workspace.
    ---@see vim.fn.FugitiveGitDir
    is_git_workspace = function()
        return not u.is_empty(vim.fn.FugitiveGitDir())
    end,

    ---@type fun(): boolean
    -- Checks the status of files whithin the current git workspace using `git status --poreclain`.
    ---@return boolean is_git_changed `true` if one of the files in the current git workspace was changed.
    is_git_changed = function()
        return (vim.b.git_status and next(vim.b.git_status)) ~= nil
    end,
}

return M
