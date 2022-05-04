-- Add the path to this plugin to the runtimepath
vim.cmd('set rtp+=' .. vim.fn.expand('<sfile>:p:h:h'))

-- Turn on termguicolors for feline
vim.opt.termguicolors = true

-- Download the packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
end

-- Turn on and setup packer
vim.cmd([[packadd packer.nvim]])
require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    use({
        'feline-cosmos',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'famiu/feline.nvim',
            'tpope/vim-fugitive',
        },
    })
end)

if packer_bootstrap then
    require('packer').sync()
    print('Please, restart nvim through try.sh to use installed plugins.')
else
    -- Configuration for test:

    local components = require('feline-cosmos.statusline').generate()
    local theme = require('feline-cosmos.themes.dark')
    vim.g.components = vim.inspect(components)
    require('feline').setup({
        components = components,
        theme = theme,
        vi_mode_colors = theme.vi_mode_colors
    })
end
