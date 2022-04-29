local c = require('feline-components.conditions')
local u = require('feline-components.utils')

local M = {

    ---@alias FelineComponent table

    ---@type fun(): string
    -- Uses `vim.bo.filetype` to take and return a type of the current file.
    ---@return string file_type the type of the current file.
    file_type = function()
        return vim.bo.filetype
    end,

    ---@type fun(): string
    -- Resolves the name of the current file relative to the current working directory.
    -- If file is not in the one of subdirectories of the working directory, then its
    -- path will be returned with:
    --  * prefix "/.../" in case when the file is not in the one of home subdirectories;
    --  * prefix "~/" in case when the file is in one of home subdirectories.
    --
    ---@return string relative_file_name the name of the file relative to the current working directory.
    relative_file_name = function()
        local full_name = vim.fn.expand('%:p')
        local name = vim.fn.expand('%:.')
        if name == full_name then
            name = vim.fn.expand('%:~')
        end
        if name == full_name then
            name = '/.../' .. vim.fn.expand('%:t')
        end
        return name
    end,

    ---@type fun(component: FelineComponent): string
    -- Cuts the current working path and gets the `component.length` directories from the end
    -- with prefix ".../". For example: inside the path `/3/2/1` this provider will return
    -- the string ".../2/1" for length 2. If `component.length` is more then directories in the path,
    -- then path will be returned as is.
    --
    ---@param component FelineComponent with properties:
    -- * `length: number`   it will be used as count of the last directories in the working path. Default is 2.
    --
    ---@return string working_path_tail last `component.length`  directories of the current working path.
    working_path_tail = function(component)
        local full_path = vim.fn.getcwd()
        local count = component.length or 2
        local sep = '/' -- FIXME: use system separator
        local dirs = vim.split(full_path, sep, { plain = true, trimempty = true })
        local result = '...' .. sep
        if count > #dirs then
            return full_path
        end
        if count <= 0 then
            return result
        end
        local tail = vim.list_slice(dirs, #dirs - count + 1, #dirs)
        for _, dir in ipairs(tail) do
            result = result .. dir .. sep
        end
        return result
    end,

    ---@type fun(component: FelineComponent): string
    -- Returns an icon for the first lsp client attached to the current buffer.
    -- Icon will be taken from the `component.icons` or from the module 'nvim-web-devicons'.
    -- If no one client will be found, the `component.client_off` or 'ﮤ' will be returned.
    --
    ---@param component FelineComponent with properties:
    -- * `icons: table?`        is an optional table with icons for possible lsp clients.
    --                          Keys are names of the lsp clients in lowercase; Values are icons;
    -- * `client_off: string?`  is an optional string with icon which means that no one client is
    --                          attached to the current buffer;
    ---@return string lsp_client_icon a string which contains an icon for the lsp client.
    lsp_client_icon = function(component)
        local icon = u.lsp_client_icon(component.icons)
        if icon == nil then
            return component.client_off or 'ﮤ'
        else
            return icon.icon
        end
    end,

    ---@type fun(component: FelineComponent): string, string
    -- Returns a list of languages used to spell check, plus icon '暈'.
    --
    ---@return string languages a list of languages used to spell check
    ---@return string icon  '暈'
    spellcheck = function()
        if vim.wo.spell then
            return vim.bo.spelllang,  '暈'
        else
            return '',   '暈'
        end
    end,

    ---@type fun(component: FelineComponent): string, string
    -- Returns the curent git branch and icon '  '.
    -- It uses `vim.fn.FugitiveHead` to take a current git branch.
    --
    ---@return string branch a name of the current branch or empty string;
    ---@return string icon  '  ';
    fugitive_branch = function()
        if c.is_git_workspace() then
            return vim.fn.FugitiveHead(), '  '
        else
            return '', '  '
        end
    end,
}
return M
