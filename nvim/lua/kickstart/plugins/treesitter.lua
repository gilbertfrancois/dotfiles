return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            local parsers = {
                'bash',
                'c',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'python',
            }

            require('nvim-treesitter').setup {
                install_dir = vim.fn.stdpath 'data' .. '/site',
            }

            -- require('nvim-treesitter').install(parsers)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = {
                    'sh',
                    'c',
                    'diff',
                    'html',
                    'lua',
                    'markdown',
                    'python',
                    'query',
                    'vim',
                    'help',
                },
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
-- vim: ts=2 sts=2 sw=2 et
