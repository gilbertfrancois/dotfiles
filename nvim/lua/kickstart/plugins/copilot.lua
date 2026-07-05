return {
    { 'github/copilot.vim' },

    {
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim', branch = 'master' } },
        build = 'make tiktoken',
        config = function()
            require('CopilotChat').setup {
                prompts = {
                    LazyLog = {
                        prompt = table.concat({
                            'Rewrite the selected Python logging statement(s) to use lazy logging formatting.',
                            'Rules:',
                            '- Never use f-strings or .format() inside logger.* calls',
                            "- Use logger.info/debug/warning/error('...', args...) style",
                            '- Prefer %d for ints, %f for floats, %s for strings/objects',
                            '- Keep behavior identical; change only the logging formatting',
                            'Return only the changed code (no explanation).',
                        }, '\n'),
                        description = 'Convert logger f-strings to lazy formatting',
                    },
                },
            }

            -- <leader>l on the *current line*
            vim.keymap.set('n', '<leader>l', function()
                local l = vim.fn.line '.'
                vim.cmd(('%d,%dCopilotChatLazyLog'):format(l, l))
            end, { desc = 'CopilotChat: Lazy-log current line' })

            -- <leader>l on a *visual selection*
            vim.keymap.set('v', '<leader>l', function()
                vim.cmd "'<,'>CopilotChatLazyLog"
            end, { desc = 'CopilotChat: Lazy-log selection' })
        end,
    },
}
